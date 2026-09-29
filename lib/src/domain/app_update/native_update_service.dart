import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class NativeAppUpdateService {
  static const MethodChannel _channel = MethodChannel('app_version_channel');

  static Future<bool> checkForUpdate({
    required bool forceUpdate,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'checkForUpdate',
        <String, dynamic>{
          'forceUpdate': forceUpdate,
        },
      ).timeout(
        // Safety net: a native update flow must never block the app
        // startup, so a hanging platform call is treated as "no update".
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Native app update timed out');
          return null;
        },
      );

      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint(
        'Native app update failed: '
        'code=${e.code}, message=${e.message}',
      );
      return false;
    } catch (e) {
      debugPrint('Native app update error: $e');
      return false;
    }
  }
}
