import 'package:customer_core/customer_core.dart';

class AppConfig {
  static AppConfig? _instance;

  static AppConfig get instance => _instance!;

  static set instance(AppConfig value) => _instance = value;

  /// Whether [instance] was already assigned by the host app.
  static bool get hasInstance => _instance != null;

  final String applicationName;
  final String shopName;
  final String shopId;
  final String shopIdentifier;
  final String shopInfoEmail;
  final List<String> shopInfoPhone;
  final String shopInfoAddress;
  final String buildIdentifier;
  final String? fcmTopicId;
  final String fireBaseProjectId;
  final AppEnv env;
  final Country country;
  final AppThemeMode themeMode;
  final bool isCategoryImageEnabled;
  final String remoteConfigKey;

  AppConfig({
    required this.applicationName,
    required this.shopName,
    required this.shopId,
    required this.shopIdentifier,
    required this.shopInfoEmail,
    required this.shopInfoPhone,
    required this.shopInfoAddress,
    required this.buildIdentifier,
    required this.country,
    this.fcmTopicId,
    required this.fireBaseProjectId,
    required this.env,
    this.isCategoryImageEnabled = true,
    this.themeMode = AppThemeMode.system,
    required this.remoteConfigKey,
  });
}
