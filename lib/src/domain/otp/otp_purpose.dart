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

enum EmailOtpPurpose {
  signup,
  passwordReset,
  emailVerification,
  orderConfirmation,
}

extension EmailOtpPurposeExtension on EmailOtpPurpose {
  String get value {
    switch (this) {
      case EmailOtpPurpose.signup:
        return "signup";
      case EmailOtpPurpose.passwordReset:
        return "password_reset";
      case EmailOtpPurpose.emailVerification:
        return "email_verification";
      case EmailOtpPurpose.orderConfirmation:
        return "order_confirmation";
    }
  }
}
