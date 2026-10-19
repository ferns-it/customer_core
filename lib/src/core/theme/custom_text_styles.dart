// custom_text_styles.dart

import 'package:material_ui/material_ui.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';

double get defaultScreenPadding => 20.0;

extension ContextExtensions on BuildContext {
  CustomTextStyles get customTextTheme {
    return Theme.of(this).extension<CustomTextStyles>()!;
  }
}

CustomTextStyles get darkCustomTextStyle => _darkCustomTextStyle;

CustomTextStyles _darkCustomTextStyle = CustomTextStyles(
  text40W400: const TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
  text40W600: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
  text36W400: const TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
  text36W600: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
  text32W400: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
  text32W600: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
  text28W400: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
  text28W600: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
  text24W400: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
  text24W600: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
  text20W400: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
  text20W600: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  text18W600: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  text18W500: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  text16W700: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  text16W500: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  text16W400: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  text16W600: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  text14W600: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  text14W500: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  text14W400: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  text14W700: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
  text12W600: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  text12W500: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  text12W400: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  text10W400: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
  color: AppColors.kWhite,
);

CustomTextStyles get lightCustomTextStyle => _lightCustomTextStyle;

CustomTextStyles _lightCustomTextStyle = CustomTextStyles(
  text40W400: const TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
  text40W600: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
  text36W400: const TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
  text36W600: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
  text32W400: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
  text32W600: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
  text28W400: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
  text28W600: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
  text24W400: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
  text24W600: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
  text20W400: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
  text20W600: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  text18W600: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  text18W500: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  text16W700: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  text16W500: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  text16W400: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  text16W600: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  text14W600: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  text14W500: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  text14W400: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  text14W700: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
  text12W600: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  text12W500: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  text12W400: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  text10W400: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
  color: AppColors.kBlack,
);

class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
  final TextStyle text40W400;
  final TextStyle text40W600;
  final TextStyle text36W400;
  final TextStyle text36W600;
  final TextStyle text32W400;
  final TextStyle text32W600;
  final TextStyle text28W400;
  final TextStyle text28W600;
  final TextStyle text24W400;
  final TextStyle text24W600;
  final TextStyle text20W400;
  final TextStyle text20W600;
  final TextStyle text18W600;
  final TextStyle text18W500;
  final TextStyle text16W400;
  final TextStyle text16W500;
  final TextStyle text16W700;
  final TextStyle text16W600;
  final TextStyle text14W400;
  final TextStyle text14W500;
  final TextStyle text14W600;
  final TextStyle text14W700;
  final TextStyle text12W400;
  final TextStyle text12W600;
  final TextStyle text12W500;
  final TextStyle text10W400;
  final Color? color;

  CustomTextStyles({
    required this.text40W400,
    required this.text40W600,
    required this.text36W400,
    required this.text36W600,
    required this.text32W400,
    required this.text32W600,
    required this.text28W400,
    required this.text28W600,
    required this.text24W400,
    required this.text24W600,
    required this.text20W400,
    required this.text20W600,
    required this.text18W500,
    required this.text18W600,
    required this.text16W500,
    required this.text16W400,
    required this.text16W600,
    required this.text16W700,
    required this.text14W400,
    required this.text14W500,
    required this.text14W600,
    required this.text14W700,
    required this.text12W400,
    required this.text12W600,
    required this.text12W500,
    required this.text10W400,
    this.color,
  });

  @override
  CustomTextStyles copyWith({
    TextStyle? text40W400,
    TextStyle? text40W600,
    TextStyle? text36W400,
    TextStyle? text36W600,
    TextStyle? text32W400,
    TextStyle? text32W600,
    TextStyle? text28W400,
    TextStyle? text28W600,
    TextStyle? text24W400,
    TextStyle? text24W600,
    TextStyle? text20W400,
    TextStyle? text20W600,
    TextStyle? text18W600,
    TextStyle? text18W500,
    TextStyle? text16W500,
    TextStyle? text16W400,
    TextStyle? text16W600,
    TextStyle? text16W700,
    TextStyle? text14W500,
    TextStyle? text14W600,
    TextStyle? text14W400,
    TextStyle? text14W700,
    TextStyle? text12W400,
    TextStyle? text12W500,
    TextStyle? text12W600,
    TextStyle? text10W400,
    Color? color,
  }) {
    return CustomTextStyles(
      text40W400: text40W400 ?? this.text40W400,
      text40W600: text40W600 ?? this.text40W600,
      text36W400: text36W400 ?? this.text36W400,
      text36W600: text36W600 ?? this.text36W600,
      text32W400: text32W400 ?? this.text32W400,
      text32W600: text32W600 ?? this.text32W600,
      text28W400: text28W400 ?? this.text28W400,
      text28W600: text28W600 ?? this.text28W600,
      text24W400: text24W400 ?? this.text24W400,
      text24W600: text24W600 ?? this.text24W600,
      text20W400: text20W400 ?? this.text20W400,
      text20W600: text20W600 ?? this.text20W600,
      text18W500: text18W500 ?? this.text18W500,
      text18W600: text18W600 ?? this.text16W600,
      text16W500: text16W500 ?? this.text16W500,
      text16W400: text16W400 ?? this.text16W400,
      text16W600: text16W600 ?? this.text16W600,
      text16W700: text16W700 ?? this.text16W700,
      text14W400: text14W400 ?? this.text14W400,
      text14W500: text14W500 ?? this.text14W500,
      text14W600: text14W600 ?? this.text14W600,
      text14W700: text14W700 ?? this.text14W700,
      text12W400: text12W400 ?? this.text12W400,
      text10W400: text10W400 ?? this.text10W400,
      text12W600: text12W600 ?? this.text12W600,
      text12W500: text12W500 ?? this.text12W500,
      color: color ?? this.color,
    );
  }

  @override
  CustomTextStyles lerp(ThemeExtension<CustomTextStyles>? other, double t) {
    if (other is! CustomTextStyles) return this;
    return CustomTextStyles(
        text40W400: TextStyle.lerp(text40W400, other.text40W400, t)!,
        text40W600: TextStyle.lerp(text40W600, other.text40W600, t)!,
        text36W400: TextStyle.lerp(text36W400, other.text36W400, t)!,
        text36W600: TextStyle.lerp(text36W600, other.text36W600, t)!,
        text32W400: TextStyle.lerp(text32W400, other.text32W400, t)!,
        text32W600: TextStyle.lerp(text32W600, other.text32W600, t)!,
        text28W400: TextStyle.lerp(text28W400, other.text28W400, t)!,
        text28W600: TextStyle.lerp(text28W600, other.text28W600, t)!,
        text24W400: TextStyle.lerp(text24W400, other.text24W400, t)!,
        text24W600: TextStyle.lerp(text24W600, other.text24W600, t)!,
        text20W400: TextStyle.lerp(text20W400, other.text20W400, t)!,
        text20W600: TextStyle.lerp(text20W600, other.text20W600, t)!,
        text18W600: TextStyle.lerp(text18W600, other.text18W600, t)!,
        text18W500: TextStyle.lerp(text18W500, other.text18W500, t)!,
        text16W500: TextStyle.lerp(text16W500, other.text16W500, t)!,
        text16W400: TextStyle.lerp(text16W400, other.text16W400, t)!,
        text16W700: TextStyle.lerp(text16W700, other.text16W700, t)!,
        text16W600: TextStyle.lerp(text16W600, other.text16W600, t)!,
        text14W400: TextStyle.lerp(text14W400, other.text14W400, t)!,
        text10W400: TextStyle.lerp(text10W400, other.text10W400, t)!,
        text14W600: TextStyle.lerp(text14W600, other.text14W600, t)!,
        text14W500: TextStyle.lerp(text14W500, other.text14W400, t)!,
        text14W700: TextStyle.lerp(text14W700, other.text14W700, t)!,
        text12W400: TextStyle.lerp(text12W400, other.text12W400, t)!,
        text12W500: TextStyle.lerp(text12W500, other.text12W500, t)!,
        text12W600: TextStyle.lerp(text12W600, other.text12W600, t)!,
        color: Color.lerp(color, other.color, t));
  }
}
