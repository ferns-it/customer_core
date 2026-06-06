import 'package:customer_core/src/presentation/connectivity/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/connectivity/connectivity_controller.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ConnectivityController.instance.isOnline,
      builder: (context, isOnline, _) {
        if (!isOnline) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: OfflineScreen(),
          );
        }
        return child;
      },
    );
  }
}
