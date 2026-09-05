import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:customer_core/src/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      this.prefixIcon,
      this.controller,
      this.validator,
      this.hintText,
      this.keyboardType,
      this.inputFormatters,
      this.textInputAction,
      this.suffixIcon,
      this.onChanged,
      this.obscureText,
      this.textColor,
      this.fillColor,
      this.enabled});

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  void Function(String)? onChanged;
  final Color? fillColor;
  final Color? textColor;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      style: TextStyle(
        color: textColor ?? AppColors.kBlack,
      ),
      onChanged: onChanged,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters ?? [],
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: validator,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        fillColor: fillColor ?? Colors.white,
        filled: true,
        errorMaxLines: 2,
        hintText: hintText,

        hintStyle: const TextStyle(color: AppColors.kGray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),

        // prefixIcon: Icon(
        //   FluentIcons.mail_24_regular,
        //   color: AppColors.kGray3,
        // ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
