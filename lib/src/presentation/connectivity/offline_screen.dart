import 'package:customer_core/src/presentation/widgets/button_progress.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/connectivity/connectivity_controller.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 50, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            const Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     Center(
            //         child: CircularProgressIndicator(
            //       color: Theme.of(context).colorScheme.primary,
            //     ));
            //     await ConnectivityController.instance.retry();
            //   },
            //   icon: const Icon(Icons.refresh),
            //   label: const Text('Retry'),
            // ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () async {
                await ConnectivityController.instance.retry();
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              label: Text('Retry',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface)),
            )
          ],
        ),
      ),
    );
  }
}
