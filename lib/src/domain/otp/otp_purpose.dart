enum OtpPurpose {
  signup,
  passwordReset,
  phoneVerification,
  orderConfirmation,
}

extension OtpPurposeExtension on OtpPurpose {
  String get value {
    switch (this) {
      case OtpPurpose.signup:
        return "signup";

      case OtpPurpose.passwordReset:
        return "password_reset";

      case OtpPurpose.phoneVerification:
        return "phone_verification";

      case OtpPurpose.orderConfirmation:
        return "order_confirmation";
    }
  }
}