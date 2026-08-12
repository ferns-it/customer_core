import 'dart:developer';
import 'dart:io';
import 'package:customer_core/src/domain/notification/models/notification_model.dart';
import 'package:customer_core/src/infrastructure/notification/notification_shared_prefs_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/core/global/global_variable.dart';
import 'package:customer_core/src/core/routes/routes.dart';
import 'package:customer_core/src/core/routes/routes.gr.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@LazySingleton()
class NotificationProvider extends ChangeNotifier with BaseController {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isPermissionGranted = false;

  bool get isPermissionGranted => _isPermissionGranted;

  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  @override
  Future<void> init() async {
    await initializeNotifications();
    await requestNotificationPermission();
    await loadNotifications();

    return super.init();
  }

  Future<void> loadNotifications() async {
    _notifications = await NotificationSharedPrefs.getNotification();
    notifyListeners();
  }

  Future<void> initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'order_notification',
      'Order Notifications',
      description: 'Notification channel for order-related updates',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      _isPermissionGranted = status.isGranted;
      notifyListeners();
    } else if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      _isPermissionGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized;

      notifyListeners();
    }
  }

  Future<void> addNotification(
    String title,
    String body,
  ) async {
    final notification = NotificationModel(
      title: title,
      body: body,
      dateTime: DateTime.now(),
    );

    await NotificationSharedPrefs.saveNotification(notification);

    _notifications = await NotificationSharedPrefs.getNotification();

    notifyListeners();
  }
  Future<void> clearNotifications() async {
    await NotificationSharedPrefs.clearNotification();
    _notifications.clear();

    notifyListeners();
  }

  
  Future<void> showNotification(
    String title,
    String body,
  ) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'order_notification',
        'Order Notifications',
        channelDescription: 'Notification channel for order-related updates',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        createUniqueId(),
        title,
        body,
        details,
      );

      await addNotification(title, body);
    } catch (e, stackTrace) {
      log(
        'Error showing notification: $e',
        stackTrace: stackTrace,
      );
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    log('Notification tapped');
    log('Payload: ${response.payload}');
    navigateToNotificationScreen();
  }
  void navigateToNotificationScreen() {
    final router = GlobalVariable.router;
    if (router != null) {
      _pushNotificationScreen(router);
      return;
    }

    log('Router not ready, will retry navigation');
    Future.delayed(const Duration(milliseconds: 200), () {
      final readyRouter = GlobalVariable.router;
      if (readyRouter != null) {
        _pushNotificationScreen(readyRouter);
      }
    });
  }

  void _pushNotificationScreen(AppRouter router) {
    if (router.isRouteActive(NotificationScreenRoute.name)) return;
    router.push(const NotificationScreenRoute());
  }

  // Generate a unique ID for each notification
  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
