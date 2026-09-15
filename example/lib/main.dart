import 'package:customer_core/customer_core.dart';
import 'package:customer_core/theme/customer_theme_override.dart';
import 'package:example/app_configuration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CustomerInitializer.init();
  await dotenv.load(fileName: ".env.dev");

  runApp(
    CustomerApp(
      appConfig: appConfig,
      uiConfig: uiConfig,
      keyConfig: keyConfig,
      lightThemeOverride: const CustomerLightThemeOverride(
          primary: Color.fromARGB(255, 4, 51, 122),
          onSurface: Colors.white,
          disabledColor: Colors.grey,
          secondary: Color.fromARGB(255, 4, 51, 122),
          primaryIconColor: Color.fromARGB(255, 4, 51, 122)),
      darkThemeOverride: const CustomerDarkThemeOverride(
          primary: Color.fromARGB(255, 4, 51, 122),
          onSurface: Colors.white,
          disabledColor: Colors.grey,
          secondary: Colors.white,
          primaryIconColor: Color(0xFF28B9F0)),
    ),
  );
}
