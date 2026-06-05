import 'package:customer_core/customer_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final appConfig = AppConfig(
  applicationName: 'Le Arabia Customer',
  shopName: 'Le Arabia',
  shopId: '1',
  country: Country.uk,
  env: AppEnv.dev,
  shopIdentifier: 'le-arabia',
  shopInfoEmail: 'info@learabia.co.uk',
  shopInfoPhone: ['+44 01245939257'],
  shopInfoAddress: '63 New Writtle Street, Chelmsford, CM2 0LF',
  buildIdentifier: 'co.uk.learabia.app',
  fireBaseProjectId: 'customerapp-6d5f7',
  themeMode: AppThemeMode.system,
  isCategoryImageEnabled: false,
);
final uiConfig = UiConfig(
  logo: 'assets/images/freshden logo v3.png',
  bgImage: 'assets/images/urban spicebg.png',
  bannerImages: [
    "assets/images/freshden banner.png",
    "assets/images/freshden banner (1).png",
    "assets/images/freshden banner (2).png",
  ],
);

final keyConfig = KeyConfig(
    secretKey: dotenv.env['SECRETKEY'] ?? '',
    fpSecretKey: dotenv.env['FPSECRETKEY'] ?? '',
    reservationSecretKey: dotenv.env['RESERVATIONSECRETKEY'] ?? '',
    stripeKey: dotenv.env['STRIPEKEY'] ?? '');
