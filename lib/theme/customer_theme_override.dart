import 'package:flutter/material.dart';

class CustomerDarkThemeOverride {
  final Color? primary;
  final Color? onSurface;
  final Color? disabledColor;
  final Color? secondary;
  final Color? primaryIconColor;

  const CustomerDarkThemeOverride({
    this.primary,
    this.onSurface,
    this.disabledColor,
    this.secondary,
    this.primaryIconColor,
  });
}

class CustomerLightThemeOverride {
  final Color? primary;
  final Color? onSurface;
  final Color? disabledColor;
  final Color? secondary;
  final Color? primaryIconColor;

  const CustomerLightThemeOverride(
      {this.primary,
      this.onSurface,
      this.disabledColor,
      this.secondary,
      this.primaryIconColor});
}
