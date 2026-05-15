import 'package:customer_core/customer_core.dart';
import 'package:customer_core/src/application/theme/theme_provider.dart';
import 'package:customer_core/src/core/theme/app_theme.dart';
import 'package:customer_core/theme/customer_theme_override.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CustomerApp extends StatefulWidget {
  final UiConfig uiConfig;
  final AppConfig appConfig;
  final KeyConfig keyConfig;
  final CustomerLightThemeOverride? lightThemeOverride;
  final CustomerDarkThemeOverride? darkThemeOverride;

  const CustomerApp(
      {super.key,
      this.lightThemeOverride,
      this.darkThemeOverride,
      required this.uiConfig,
      required this.appConfig,
      required this.keyConfig});

  @override
  State<CustomerApp> createState() => _CustomerAppState();
}

class _CustomerAppState extends State<CustomerApp> {
  var initialized = false;
  late final AppRouter appRouter;
  @override
  void initState() {
    super.initState();
    appRouter = AppRouter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!initialized) {
        DependencyRegistrar.initializeAllProviders(context);

        setState(() {
          initialized = true;
        });
      }
    });
    // initialize once
    AppConfig.instance = widget.appConfig;
    UiConfig.instance = widget.uiConfig;
    KeyConfig.instance = widget.keyConfig;
    AppEnvironment.current = widget.appConfig.env;
    Stripe.publishableKey = widget.keyConfig.stripeKey;
    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: DependencyRegistrar.providers,
      child: _buildMaterialApp(context),
    );
  }

  ThemeMode _mapThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  Widget _buildMaterialApp(BuildContext context) {
    final baseLight = appLightTheme(context);
    final baseDark = appDarkTheme(context);

    ThemeData finalLight = baseLight;
    ThemeData finalDark = baseDark;

    if (widget.lightThemeOverride != null) {
      final override = widget.lightThemeOverride!;

      finalLight = baseLight.copyWith(
        colorScheme: baseLight.colorScheme.copyWith(
          primary: override.primary ?? baseLight.colorScheme.primary,
          onSurface: override.onSurface ?? baseLight.colorScheme.onSurface,
        ),
        disabledColor: override.disabledColor ?? baseLight.disabledColor,
      );
    }

    if (widget.darkThemeOverride != null) {
      final override = widget.darkThemeOverride!;

      finalDark = baseDark.copyWith(
        colorScheme: baseDark.colorScheme.copyWith(
          primary: override.primary ?? baseDark.colorScheme.primary,
          onSurface: override.onSurface ?? baseDark.colorScheme.onSurface,
        ),
        disabledColor: override.disabledColor ?? baseDark.disabledColor,
      );
    }

    return Selector<ThemeProvider, ThemeMode>(
        selector: (_, provider) => provider.themeMode,
        builder: (context, themeMode, _) {
          return MaterialApp.router(
            title: widget.appConfig.applicationName,
            debugShowCheckedModeBanner: false,
            theme: finalLight,
            darkTheme: finalDark,
            themeMode:
                _mapThemeMode(widget.appConfig.themeMode) == ThemeMode.system
                    ? themeMode
                    : _mapThemeMode(widget.appConfig.themeMode),
            // themeMode: _mapThemeMode(widget.config.themeMode) == ThemeMode.system
            //     ? Provider.of<ThemeProvider>(context, listen: false).currentTheme
            //     : _mapThemeMode(widget.config.themeMode), // change this 👈
            routerConfig: appRouter.config(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(0.95)),
                child: ToastificationWrapper(child: child!),
              );
            },
          );
        });
  }
}
