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
      this.icon,
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
  final IconData? icon;
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        // fillColor: fillColor ?? Colors.white,
        filled: true,
        errorMaxLines: 2,
        hintText: hintText,

        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.38),
          fontSize: 14,
        ),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(
        //     left: 18,
        //     right: 12,
        //   ),
        //   child: Icon(
        //     icon,
        //     color: Colors.white.withOpacity(0.75),
        //     size: 24,
        //   ),
        // ),
        // prefixIconConstraints: const BoxConstraints(
        //   minWidth: 58,
        //   minHeight: 58,
        // ),
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          // borderSide: BorderSide.none,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primaryIconColor ??
                Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          // borderSide: BorderSide.none,
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.7),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 12,
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
