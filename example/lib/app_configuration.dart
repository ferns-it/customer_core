import 'package:customer_core/customer_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final appConfig = AppConfig(
  applicationName: 'Silver Spoon Bahrain',
  shopName: 'Silver Spoon Bahrain',
  shopId: '44',
  shopIdentifier: 'silver-spoons',
  shopInfoEmail: 'silverspoonstest@gmail.com',
  shopInfoPhone: ['+973 37774567'],
  shopInfoAddress: 'Building Nr 52, Road 38, Bahrain, 3121',
  buildIdentifier: 'co.uk.silverspoon.app',
  country: Country.bh,
  fireBaseProjectId: 'customerapp-6d5f7',
  env: AppEnv.dev,
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
