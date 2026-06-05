import 'dart:developer';

import 'package:customer_core/src/domain/notification/models/notification_model.dart';
import 'package:customer_core/src/infrastructure/notification/notification_shared_prefs_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

import 'application/notification/notification_provider.dart';
import 'domain/dependency_injection/injection_config.dart';

class CustomerInitializer {
  static Future<void> init(
      // {required String env}
      ) async {
    // WidgetsFlutterBinding.ensureInitialized();

    // Firebase
    // await Firebase.initializeApp();

    // Env
    // await dotenv.load(fileName: env == 'dev' ? ".env.dev" : ".env.prod");

    // Stripe
    // Stripe.publishableKey = dotenv.env['STRIPEKEY'] ?? '';

    // DI
    configureInjection();

    // Notifications
    await NotificationProvider().init();
    final token = await FirebaseMessaging.instance.getToken();
    log(token ?? 'NULL', name: 'FCM');

    FirebaseMessaging.onMessage.listen((message) async {
      log("Received message: ${message.data}", name: 'FCM');
      if (message.data["title"] != null || message.data["body"] != null) {
        NotificationProvider().showNotification(
          message.data["title"],
          message.data["body"],
        );

        final notification = NotificationModel(
          title: message.data["title"],
          body: message.data["body"],
          dateTime: DateTime.now(),
          customerOrderID: '',
          orderID: '',
        );

        await NotificationSharedPrefs.saveNotification(notification);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    if (message.data["title"] != null || message.data["body"] != null) {
      NotificationProvider().showNotification(
        message.data["title"],
        message.data["body"],
      );
      final notification = NotificationModel(
        title: message.data["title"],
        body: message.data["body"],
        dateTime: DateTime.now(),
        customerOrderID: '',
        orderID: '',
      );
      await NotificationSharedPrefs.saveNotification(notification);
    }
  }
}
