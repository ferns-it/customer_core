import 'dart:math';


import 'package:html/parser.dart';

import 'dart:math' as math;

import 'package:intl/intl.dart';

class Utils {
  static String removeHtmlTags(String value) {
    final data = parse(value);
    final result = parse(data.body?.text).documentElement?.text;
    return result ?? '';
  }
//  static String stripHtml(String html) {
//       return html
//           .replaceAll(
//             RegExp(r'<br\s*/?>', caseSensitive: false),
//             '\n',
//           )
//           .replaceAll(
//             RegExp(r'</p>', caseSensitive: false),
//             '\n',
//           )
//           .replaceAll(
//             RegExp(r'<[^>]*>'),
//             '',
//           )
//           .replaceAll('&nbsp;', ' ')
//           .trim();
//     }
  static String removeExtraSpaces(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String? commonValidator(String? value, [String error = "*required"]) {
    if (value == null) return null;
    if (value.isEmpty) {
      return error;
    }
    return null;
  }

  static String? validatePassword(String? value, {bool requiredOnly = false}) {
    if (value == null) return null;
    if (value.isEmpty) {
      return "*required";
    }

    if (requiredOnly) {
      return null;
    }

    if (value.length < 6) {
      return "Must be at least 6 characters";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null) return null;
    if (value.isEmpty) {
      return "*required";
    }
    if (value.isNotEmpty ) {
      return "Invalid Email Id";
    }
    return null;
  }

  static String? validateMobileNumber(String? value) {
    if (value == null) return null;
    if (value.isEmpty) {
      return "*required";
    }
    // Regular expression pattern for a 10-digit mobile number
    final RegExp mobileRegex = RegExp(r'^[0-9]{10}$');

    if (!mobileRegex.hasMatch(value)) {
      return "Invalid mobile number";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String otherValue) {
    if (value == null) return null;
    if (value.isEmpty) {
      return "*required";
    }
    if (otherValue != value) {
      return "Passwords must be same";
    }
    // if (value.isNotEmpty && value.length < 6) {
    //   return "Password must be 6 characters";
    // }
    return null;
  }

  static String generateOTP({int length = 4}) {
    final random = Random();
    final otp = List.generate(length, (_) => random.nextInt(10)).join();
    return otp;
  }

  static bool isTokenExpired(int? value) {
    if (value == null) {
      return false;
    }
    DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(value * 1000);
    return DateTime.now().isAfter(expirationDate);
  }

  static int getRandomNumber() {
    var rnd = math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }

    return next.toInt();
  }

  static String format(
    double value, {
    String locale = 'en_GB',
    String symbol = '£',
  }) {
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      customPattern: '¤ #,##0.00', // Ensures the space between symbol and value
    );

    return currencyFormat.format(value);
  }
}
