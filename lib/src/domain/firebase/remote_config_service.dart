import 'dart:convert';

import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/domain/firebase/models/remote_config_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() => _instance;

  RemoteConfigService._internal();

  FirebaseRemoteConfig? _remoteConfig;

  bool _isInitialized = false;
  bool _hasError = false;

  bool get isInitialized => _isInitialized;

  bool get hasError => _hasError;

  /// Fallback Firebase Remote Config key used when the host app has not yet
  /// assigned [AppConfig.instance] (e.g. [CustomerInitializer.init] runs
  /// before [CustomerApp] is built). The real key is injected via
  /// [setConfigKey] as soon as the host config is available.
  static const String fallbackConfigKey = 'onlineOrder_config';

  /// Safe lazy getter — never throws, unlike reading
  /// `AppConfig.instance` directly before the host app sets it.
  static String get defaultConfigKey => AppConfig.hasInstance
      ? AppConfig.instance.remoteConfigKey
      : fallbackConfigKey;

  // Firebase JSON key — defaults to the safe fallback until the host app
  // provides its own key through [setConfigKey].
  String _appConfigKey = fallbackConfigKey;

  void setConfigKey(String key) {
    final value = key.trim();

    if (value.isEmpty) {
      throw ArgumentError('Remote Config key cannot be empty');
    }

    _appConfigKey = value;
  }

  String get configKey => _appConfigKey;

  void _ensureConfigKey() {
    if (_appConfigKey.isEmpty) {
      throw StateError(
        'Remote Config key has not been configured. '
        'Call setConfigKey() before initializing RemoteConfigService.',
      );
    }
  }

  // Parsed config model
  RemoteConfigModel? _config;

  RemoteConfigModel? get config => _config;

  Future<void> initialize() async {
    try {
      _ensureConfigKey();
      _remoteConfig = FirebaseRemoteConfig.instance;

      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval:
              kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );

      // Default JSON config matching the Firebase remote config structure
      await _remoteConfig!.setDefaults({
        _appConfigKey: jsonEncode({
          "force_update_required": false,
          "minimum_required_version": "1.0.0",
          "build_number": "1",
          "update_message":
              "A new version is available. Please update the app.",
          "update_url": ""
        }),
      });

      // Fetch latest config
      try {
        await _remoteConfig!.fetch().timeout(
              const Duration(seconds: 15),
            );
      } catch (e) {
        // Offline / timeout: fall back to defaults + cache.
        debugPrint('Remote Config fetch failed, using defaults: $e');
      }

      // Activate fetched values
      await _remoteConfig!.activate();

      _parseActiveConfig();

      _isInitialized = true;
      _hasError = false;

      _logRemoteConfigValues();
    } catch (e) {
      debugPrint('Remote Config initialize failed (non-fatal): $e');
      _hasError = true;
      _isInitialized = false;
    }
  }

  Future<void> refresh() async {
    try {
      _ensureConfigKey();
      if (_remoteConfig == null) {
        await initialize();
        return;
      }

      try {
        await _remoteConfig!.fetchAndActivate().timeout(
              const Duration(seconds: 15),
            );
      } catch (e) {
        // Offline / throttled / timeout: keep the last good config.
        debugPrint('Remote Config refresh failed, keeping cache: $e');
        return;
      }

      _parseActiveConfig();

      _logRemoteConfigValues();
    } catch (e) {
      debugPrint('Remote Config refresh failed (non-fatal): $e');
    }
  }

  /// Parses the active Remote Config JSON string. Guards against empty or
  /// malformed JSON so a bad console value can never crash the app — the
  /// previous good [_config] is preserved.
  void _parseActiveConfig() {
    final jsonString = _remoteConfig!.getString(_appConfigKey);
    if (jsonString.trim().isEmpty) {
      debugPrint('Remote Config value empty — keeping previous config.');
      return;
    }
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        debugPrint('Remote Config value is not a JSON object — ignoring.');
        return;
      }
      _config = RemoteConfigModel.fromJson(decoded);
    } catch (e) {
      debugPrint('Remote Config JSON parse failed (non-fatal): $e');
    }
  }

  void _logRemoteConfigValues() {
    if (kDebugMode) {
      debugPrint('Remote Config active: ${_config?.toString()}');
    }
  }

  // Convenience getters

  bool get forceUpdateRequired => _config?.forceUpdateRequired ?? false;

  String get minimumRequiredVersion => _config?.version ?? '1.0.0';

  int get minimumRequiredBuildNumber => _config?.buildNumber ?? 1;

  String get updateMessage =>
      _config?.updateMessage ?? 'A new version is available.';

  String get updateUrl => _config?.updateUrl ?? '';

  /// Checks if the current app version is less than the minimum required version
  bool isVersionUpdateRequired(String currentAppVersion) {
    return _config?.isVersionBehind(currentAppVersion) ?? false;
  }

  /// Checks if the current build number is less than the minimum required build number
  bool isBuildNumberUpdateRequired(int currentBuildNumber) {
    return _config?.isBuildNumberBehind(currentBuildNumber) ?? false;
  }

  /// Overall check: true if version OR build number requires update
  bool isUpdateRequired(String currentAppVersion, int currentBuildNumber) {
    return _config?.isUpdateRequired(currentAppVersion, currentBuildNumber) ??
        false;
  }

  Map<String, dynamic> getUpdateConfig() {
    if (_config == null) return {};
    return _config!.toJson();
  }
}
