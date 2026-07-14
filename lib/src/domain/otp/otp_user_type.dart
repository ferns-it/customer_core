enum OtpUserType {
  guest,
  registered,
}

extension OtpUserTypeExtension on OtpUserType {
  String get value {
    switch (this) {
      case OtpUserType.guest:
        return "Guest";

      case OtpUserType.registered:
        return "Registered";
    }
  }
}