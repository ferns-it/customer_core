import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AlertDialogs {
  static void _showToast(
    String message, {
    BuildContext? context,
    String title = "Message",
    ToastificationType type = ToastificationType.info,
    Icon? icon,
    Duration autoCloseDuration = const Duration(seconds: 3),
  }) {
    // Prefer toastification when available and a valid BuildContext is passed.
    if (context != null) {
      try {
        toastification.show(
          context: context,
          title: Text(title),
          description: Text(
            message,
            maxLines: 5,
          ),
          autoCloseDuration: autoCloseDuration,
          alignment: Alignment.topCenter,
          showProgressBar: false,
          type: type,
          icon: icon,
          borderSide: const BorderSide(
            color: Color.fromRGBO(195, 195, 195, 1),
            width: 1.0,
          ),
          dragToClose: true,
          closeButtonShowType: CloseButtonShowType.none,
        );
        return;
      } catch (_) {
        // If toastification isn't available or fails, fall back to ScaffoldMessenger
      }

      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger != null) {
        messenger.showSnackBar(SnackBar(content: Text(message)));
        return;
      }
    }

    // If no BuildContext was provided or previous attempts failed, try toastification without context
    try {
      toastification.show(
        title: Text(title),
        description: Text(
          message,
          maxLines: 5,
        ),
        autoCloseDuration: autoCloseDuration,
        alignment: Alignment.topCenter,
        showProgressBar: false,
        type: type,
        icon: icon,
        borderSide: const BorderSide(
          color: Color.fromRGBO(195, 195, 195, 1),
          width: 1.0,
        ),
        dragToClose: true,
        closeButtonShowType: CloseButtonShowType.none,
      );
      return;
    } catch (_) {
      // final fallback
    }

    // Last resort: print to console
    // ignore: avoid_print
    print('Alert: $title - $message');
  }

  static void showSuccess(String message, {BuildContext? context}) {
    _showToast(message, context: context, type: ToastificationType.success);
  }

  static void showInfo(String message, {BuildContext? context}) {
    _showToast(message, context: context, type: ToastificationType.info);
  }

  static void showWarning(String message, {BuildContext? context}) {
    _showToast(message, context: context, type: ToastificationType.warning);
  }

  static void showError(String message, {BuildContext? context}) {
    _showToast(message, context: context, type: ToastificationType.error);
  }

  static void showCustom(
    String message, {
    BuildContext? context,
    String title = "Message",
    required Icon icon,
    Duration? autoCloseDuration,
  }) {
    _showToast(
      message,
      context: context,
      title: title,
      icon: icon,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 3),
    );
  }
}
