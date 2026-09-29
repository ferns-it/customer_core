import 'package:auto_route/auto_route.dart';
import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/application/settings/app_update_provider.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boot();
    });
  }

  /// App start sequence: init providers → run the update flow
  /// (Remote Config → force/optional dialog → Play check) →
  /// then navigate. The update check never throws, so navigation
  /// always happens exactly once.
  Future<void> _boot() async {
    if (!mounted) return;
    try {
      await DependencyRegistrar.initializeAllProviders(context);
    } catch (e) {
      debugPrint('Provider init failed (non-fatal): $e');
    }

    if (!mounted) return;
    try {
      // Small delay so the splash is visible and the navigator is ready.
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      await context.read<AppUpdateProvider>().checkForUpdate(context);
    } catch (e) {
      debugPrint('Update check failed (non-fatal): $e');
    }

    _navigateNext();
  }

  void _navigateNext() {
    if (!mounted || _navigated) return;
    _navigated = true;
    context.replaceRoute(const OrderOnlineScreenRoute());

    // Future.delayed(const Duration(seconds: 2), () {
    //   context.read<AuthProvider>().checkUserIsLogged().then((isLogged) {
    //     if (isLogged) {
    //       DependencyRegistrar.initializeAllProviders(context);
    //       context.replaceRoute(OrderOnlineScreenRoute());
    //       // context.read<ProductsProvider>().getAllCategories();
    //     } else {
    //       context.replaceRoute(const WelcomeScreenRoute());
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          // image: DecorationImage(
          //   image: AssetImage(Assets.images.pattern.path),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Center(
          child: Image.asset(
            UiConfig.instance.logo,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        ),
      ),
    );
  }
}
