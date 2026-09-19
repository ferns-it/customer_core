import 'package:flutter/material.dart';

class CustomerDarkThemeOverride {
  final Color? primary;
  final Color? onSurface;
  final Color? disabledColor;
  final Color? secondary;
  final Color? primaryIconColor;
  final Color? loginCardBgColor;

  const CustomerDarkThemeOverride({
    this.primary,
    this.onSurface,
    this.disabledColor,
    this.secondary,
    this.primaryIconColor,
    this.loginCardBgColor,
  });
}

class CustomerLightThemeOverride {
  final Color? primary;
  final Color? onSurface;
  final Color? disabledColor;
  final Color? secondary;
  final Color? primaryIconColor;
  final Color? loginCardBgColor;

  const CustomerLightThemeOverride(
      {this.primary,
      this.onSurface,
      this.disabledColor,
      this.secondary,
      this.primaryIconColor,
      this.loginCardBgColor});
}
