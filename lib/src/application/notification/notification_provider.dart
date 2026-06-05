import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@LazySingleton()
class NotificationProvider extends ChangeNotifier with BaseController {
  bool _isPermissionGranted = false;

  bool get isPermissionGranted => _isPermissionGranted;

  final List<String> _notifications = [];

  List<String> get notifications => _notifications;

  @override
  Future<void> init() async {
    requestNotificationPermission();
    await initializeNotifications();
    return super.init();
  }

  Future<void> initializeNotifications() async {
    // Initialize Awesome Notifications
    AwesomeNotifications().initialize(
      // Set the icon for Android notifications
      null,
      [
        NotificationChannel(
          channelKey: 'order_notification',
          channelName: 'Order Notifications',
          channelDescription: 'Notification channel for order-related updates',
          defaultColor: Colors.deepPurple,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
      // Configure the app to show notifications while in foreground
      debug: true,
    );
  }

  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();

        if (status.isGranted) {
          _isPermissionGranted = true;
          notifyListeners();
        } else {
          _isPermissionGranted = false;
          notifyListeners();
        }
      }
    } else {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _isPermissionGranted = true;
        // await Future.delayed(const Duration(seconds: 2));

        // final apns = await FirebaseMessaging.instance.getAPNSToken();
        // log("APNS Token = $apns");

        // final fcm = await FirebaseMessaging.instance.getToken();
        // log("FCM Token = $fcm");
      } else {
        _isPermissionGranted = false;
      }
    }
  }

  void addNotification(String message) {
    _notifications.add(message);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void showNotification(String title, String body) async {
    try {
      // Create and display the notification
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(), // Unique notification ID
          channelKey: 'order_notification',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
        ),
      );

      // Add the notification message to the list (if needed)
      addNotification("$title: $body");
    } catch (e) {
      log("Error showing notification: $e");
    }
  }

  // Generate a unique ID for each notification
  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
