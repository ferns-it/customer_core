import 'dart:developer';

import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/application/connectivity/connectivity_controller.dart';
import 'package:customer_core/src/domain/firebase/remote_config_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'application/notification/notification_provider.dart';
import 'domain/dependency_injection/injection_config.dart';

class CustomerInitializer {
  static Future<void> init() async {
    await ConnectivityController.instance.init();
    // WidgetsFlutterBinding.ensureInitialized();

    // Firebase
    // await Firebase.initializeApp();

    // Env
    // await dotenv.load(fileName: env == 'dev' ? ".env.dev" : ".env.prod");

    // Stripe
    // Stripe.publishableKey = dotenv.env['STRIPEKEY'] ?? '';

    // DI
    configureInjection();
    // Remote Config must never crash/block startup: the host app assigns
    // `AppConfig.instance` when `CustomerApp` is built, which can happen
    // after this call. Guard everything and fall back gracefully.
    try {
      final remoteConfigService = RemoteConfigService();

      // `AppConfig.instance` is assigned when `CustomerApp` is built, which can
      // happen after this call, so fall back to the default key instead of
      // reading a not yet initialised AppConfig.
      remoteConfigService.setConfigKey(
        AppConfig.hasInstance
            ? AppConfig.instance.remoteConfigKey
            : RemoteConfigService.defaultConfigKey,
      );

      await remoteConfigService.refresh().timeout(
            const Duration(seconds: 15),
            onTimeout: () => debugPrint('Remote Config warm-up timed out'),
          );
    } catch (e) {
      debugPrint('Remote Config warm-up failed (non-fatal): $e');
    }

    final notificationProvider = getIt<NotificationProvider>();

    // Notifications
    await notificationProvider.init();
    final token = await FirebaseMessaging.instance.getToken();
    log(token ?? 'NULL', name: 'FCM');

    FirebaseMessaging.onMessage.listen((message) async {
      log("Received message: ${message.data}", name: 'FCM');
      if (message.data["title"] != null || message.data["body"] != null) {
        await notificationProvider.showNotification(
          message.data["title"],
          message.data["body"],
        );
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle the app being opened by tapping an FCM notification while the
    // app is in the background.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("Message opened app from background: ${message.data}", name: 'FCM');
      _navigateToNotificationFromTap();
    });

    // Handle the app being launched from a terminated state via a
    // notification tap.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      log(
        "App launched from notification: ${initialMessage.data}",
        name: 'FCM',
      );
      _navigateToNotificationFromTap();
    }

    // Orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  /// Navigates the user to the notification screen after an FCM notification
  /// tap. A short delay ensures the router and UI are ready.
  static void _navigateToNotificationFromTap() {
    Future.delayed(const Duration(milliseconds: 150), () {
      getIt<NotificationProvider>().navigateToNotificationScreen();
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    configureInjection();
    final notificationProvider = getIt<NotificationProvider>();
    if (message.data["title"] != null || message.data["body"] != null) {
      await notificationProvider.showNotification(
        message.data["title"],
        message.data["body"],
      );
    }
  }
}
