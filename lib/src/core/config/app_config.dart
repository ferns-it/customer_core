import 'package:customer_core/customer_core.dart';

class AppConfig {
  static late AppConfig instance;

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
    required this.isCategoryImageEnabled,

  
    required this.env,
  
    this.themeMode = AppThemeMode.system,
  });
}
