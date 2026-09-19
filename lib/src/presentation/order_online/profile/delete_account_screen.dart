import 'package:auto_route/auto_route.dart';
import 'package:customer_core/customer_core.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/auth/auth_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final String formUrl = 'https://forms.gle/C2Xr8risg9VvSHaa9';
  late WebViewController controller;
  int loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains("formResponse") ||
                request.url.contains("thankyou")) {
              const snackBar = SnackBar(
                content: Text(
                  'Your account is scheduled for deletion in 7 days.',
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // Optional: logout after showing message
              final authProvider = context.read<AuthProvider>();
              authProvider.logoutUser();
              authProvider.clearValues();
              context.router.replace(LoginScreenRoute());

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(formUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Account")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage /
                  AppConfig.instance.country.currencyDivisor,
              backgroundColor: Colors.grey[200],
              color: Theme.of(context).colorScheme.primary,
              minHeight: 3,
            ),
        ],
      ),
    );
  }
}
