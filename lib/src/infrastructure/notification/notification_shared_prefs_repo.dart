import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/domain/notification/models/notification_model.dart';

class NotificationSharedPrefs {
  static String kUserPrefsKey =
      "${AppIdentifiers.kBuildIdentifier}/notification";

  static Future<bool> clearNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .remove(kUserPrefsKey)
        .then((_) => true)
        .catchError((_) => false);
  }

  static Future<List<NotificationModel>> getNotification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? storedList = prefs.getStringList(kUserPrefsKey);

      if (storedList == null) return [];

      return storedList.map((e) => NotificationModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> saveNotification(NotificationModel notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // load existing notifications
      final List<String> storedList = prefs.getStringList(kUserPrefsKey) ?? [];

      // add new notification at the front so the latest shows first
      storedList.insert(0, notification.toJson());

      // save back to prefs
      await prefs.setStringList(kUserPrefsKey, storedList);

      return true;
    } catch (_) {
      return false;
    }
  }
}
