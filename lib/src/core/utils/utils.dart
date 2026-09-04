import 'dart:math';
import 'dart:ui';

import 'package:customer_core/customer_core.dart';
import 'package:flutter/material.dart';
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
  static bool isSpiceLevelApplicable(String? spiceLevel) {
    if (spiceLevel == null) return false;
    final normalized = spiceLevel.trim().toLowerCase();
    if (normalized.isEmpty) return false;

    const notApplicableValues = {
      'not applicable',
      'n/a',
      'na',
      'none',
      'nil',
      '-',
      '0',
    };

    return !notApplicableValues.contains(normalized);
  }

  static Color spiceLevelColor(BuildContext context, String? spiceLevel) {
    if (spiceLevel == null) return Theme.of(context).cardColor;
    switch (spiceLevel.trim().toLowerCase()) {
      case 'not spicy':
        return const Color(0xFFE8F5E9); // Soft green
      case 'mild':
        return const Color(0xFFFFE69C); // Soft yellow
      case 'medium':
        return const Color(0xFFFFE8C2); // Soft orange
      case 'hot':
        return const Color(0xFFFFD6D6); // Soft red
      case 'extra hot':
        return const Color(0xFFFFB8B8); // Stronger red
      default:
        return Theme.of(context).cardColor;
    }
  }

  static Color spiceLevelTextColor(
    BuildContext context,
    String? spiceLevel,
  ) {
    switch (spiceLevel?.trim().toLowerCase()) {
      case 'not spicy':
        return const Color(0xFF2E7D32); // Dark green

      case 'mild':
        return const Color(0xFF795500);
      case 'medium':
        return const Color(0xFFE65100); // Dark orange

      case 'hot':
        return const Color(0xFFC62828); // Dark red

      case 'extra hot':
        return const Color(0xFFB71C1C); // Strong red

      default:
        return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    }
  }
  // static Color spiceLevelTextColor(
  //   BuildContext context,
  //   String? spiceLevel,
  // ) {
  //   switch (spiceLevel?.trim().toLowerCase()) {
  //     case 'not spicy':
  //       return const Color(0xFF1B5E20);

  //     case 'mild':
  //       return const Color(0xFF795500);

  //     case 'medium':
  //       return const Color(0xFFB54700);

  //     case 'hot':
  //       return const Color(0xFFB42318);

  //     case 'extra hot':
  //       return const Color(0xFF8B0000);

  //     default:
  //       return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
  //   }
  // }

  // static Color spiceLevelColor(BuildContext context, String? spiceLevel) {
  //   switch (spiceLevel?.trim().toLowerCase()) {
  //     case 'not spicy':
  //       return const Color(0xFFB7E4C7); // Fresh green

  //     case 'mild':
  //       return const Color(0xFFFFE69C); // Warm yellow

  //     case 'medium':
  //       return const Color(0xFFFFC878); // Soft orange

  //     case 'hot':
  //       return const Color(0xFFFFA8A8); // Warm red

  //     case 'extra hot':
  //       return const Color(0xFFFF7777); // Strong red

  //     default:
  //       return Theme.of(context).cardColor;
  //   }
  // }

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

  static String? postcodeValidator(String? value, Country country) {
    if (value == null || value.trim().isEmpty) {
      return '*required';
    }

    final postcode = value.trim();

    if (country == Country.ind) {
      if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(postcode)) {
        return 'Enter a valid Indian postcode';
      }
    } else if (country == Country.uk) {
      final ukPostcode = postcode.toUpperCase();

      if (!RegExp(
        r'^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$',
      ).hasMatch(ukPostcode)) {
        return 'Enter a valid UK postcode';
      }
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
    if (value.isNotEmpty) {
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
