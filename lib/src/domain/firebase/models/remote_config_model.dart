import 'dart:convert';

class RemoteConfigModel {
  final bool forceUpdateRequired;
  final String version;
  final int buildNumber;
  final String updateMessage;
  final String updateUrl;

  RemoteConfigModel({
    required this.forceUpdateRequired,
    required this.version,
    required this.buildNumber,
    required this.updateMessage,
    required this.updateUrl,
  });

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    // Defensive coercion: Remote Config values may arrive as String/int/bool.
    final forceRaw = json['force_update_required'];
    final forceUpdateRequired = forceRaw is bool
        ? forceRaw
        : forceRaw is num
            ? forceRaw != 0
            : forceRaw?.toString().toLowerCase().trim() == 'true';

    final versionRaw = json['minimum_required_version'];
    final version = (versionRaw == null || versionRaw.toString().trim().isEmpty)
        ? '1.0.0'
        : versionRaw.toString().trim();

    final buildRaw = json['build_number'];
    final buildNumber = buildRaw is int
        ? buildRaw
        : int.tryParse(buildRaw?.toString() ?? '') ?? 1;

    final messageRaw = json['update_message'];
    final updateMessage =
        (messageRaw == null || messageRaw.toString().trim().isEmpty)
            ? 'A new version is available. Please update the app.'
            : messageRaw.toString();

    final urlRaw = json['update_url'];
    return RemoteConfigModel(
      forceUpdateRequired: forceUpdateRequired,
      version: version,
      buildNumber: buildNumber,
      updateMessage: updateMessage,
      updateUrl: urlRaw?.toString().trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'force_update_required': forceUpdateRequired,
      'minimum_required_version': version,
      'build_number': buildNumber.toString(),
      'update_message': updateMessage,
      'update_url': updateUrl,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  /// Returns true if the given app version is less than the remote required version
  bool isVersionBehind(String currentAppVersion) {
    return _compareVersions(currentAppVersion, version) < 0;
  }

  /// Returns true if the given build number is less than the remote required build number
  bool isBuildNumberBehind(int currentBuildNumber) {
    return currentBuildNumber < buildNumber;
  }

  /// Returns true if either version or build number requires update
  bool isUpdateRequired(String currentAppVersion, int currentBuildNumber) {
    return isVersionBehind(currentAppVersion) ||
        isBuildNumberBehind(currentBuildNumber);
  }

  int _compareVersions(String version1, String version2) {
    // Strip build metadata ("1.0.0+1" -> "1.0.0") and
    // pre-release suffixes ("1.0.0-dev" -> "1.0.0").
    final cleanVersion1 = version1.split(RegExp(r'[+-]')).first.trim();
    final cleanVersion2 = version2.split(RegExp(r'[+-]')).first.trim();
    final v1 =
        cleanVersion1.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final v2 =
        cleanVersion2.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final maxLength = v1.length > v2.length ? v1.length : v2.length;

    for (int i = 0; i < maxLength; i++) {
      final num1 = i < v1.length ? v1[i] : 0;
      final num2 = i < v2.length ? v2[i] : 0;
      if (num1 > num2) return 1;
      if (num1 < num2) return -1;
    }
    return 0;
  }

  @override
  String toString() {
    return 'RemoteConfigModel(forceUpdateRequired: $forceUpdateRequired, version: $version, buildNumber: $buildNumber, updateMessage: $updateMessage, updateUrl: $updateUrl)';
  }
}
