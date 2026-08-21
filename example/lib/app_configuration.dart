import 'package:customer_core/customer_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final appConfig = AppConfig(
  applicationName: 'Le Arabia Customer',
  shopName: 'Le Arabia',
  shopId: '1',
  // shopId: '93',
  country: Country.uk,
  env: AppEnv.prod,
  shopIdentifier: 'le-arabia',
  // shopIdentifier: 'brew--chew-',
  shopInfoEmail: 'info@learabia.co.uk',
  shopInfoPhone: ['+44 01245939257'],
  shopInfoAddress: '63 New Writtle Street, Chelmsford, CM2 0LF',
  buildIdentifier: 'co.uk.learabia.app',
  fireBaseProjectId: 'customerapp-6d5f7',
  themeMode: AppThemeMode.system,
  isCategoryImageEnabled: true,
  // applicationName: 'Urban Spice',
  // shopName: 'Urban Spice',
  // shopId: '76',
  // country: Country.uk,
  // env: AppEnv.prod,
  // shopIdentifier: 'urban-spice',
  // shopInfoEmail: 'info@urbanspicechelmsford.com',
  // shopInfoPhone: ['+44 01245939257'],
  // shopInfoAddress: '63 New Writtle Street, Chelmsford, CM2 0LF',
  // buildIdentifier: 'co.uk.urbanspice.app',
  // fireBaseProjectId: 'customerapp-6d5f7',
  // themeMode: AppThemeMode.system,
  // isCategoryImageEnabled: true,
);
final uiConfig = UiConfig(
  logo: 'assets/images/urban spice logo.png',
  bgImage: 'assets/images/urban spicebg.png',
  bannerImages: [
    "assets/images/banner1.png",
    "assets/images/banner2.png",
    "assets/images/banner3.png",
  ],
);

final keyConfig = KeyConfig(
    secretKey: dotenv.env['SECRETKEY'] ?? '',
    fpSecretKey: dotenv.env['FPSECRETKEY'] ?? '',
    reservationSecretKey: dotenv.env['RESERVATIONSECRETKEY'] ?? '',
    stripeKey: dotenv.env['STRIPEKEY'] ?? '');
    // stripeKey: "pk_test_BEdMOuu01og3dXu6tF86DdAe00Nb6Sb37J");
