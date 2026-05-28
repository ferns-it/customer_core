import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'custom_text_styles.dart';

const double defaultRoundedRadius = 10.0;

InputDecorationTheme buildInputDecorationTheme({
  required Color borderColor,
  required Color focusedColor,
  required Color disabledColor,
  required Color errorColor,
}) {
  return InputDecorationTheme(
    hintStyle: const TextStyle(fontSize: 14.0),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultRoundedRadius)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: focusedColor),
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultRoundedRadius)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultRoundedRadius)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: disabledColor),
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultRoundedRadius)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultRoundedRadius)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor, width: 2.0),
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultRoundedRadius)),
    ),
  );
}

ThemeData quickSandTextTheme(BuildContext context) {
  final baseTextTheme = Theme.of(context).textTheme;
  return Theme.of(context).copyWith(
      textTheme: GoogleFonts.quicksandTextTheme(baseTextTheme).apply(
    displayColor: AppColors.kBlack2,
    bodyColor: AppColors.kBlack2,
  ));
}

ThemeData poppinsTextTheme(BuildContext context) {
  final baseTextTheme = Theme.of(context).textTheme;
  return Theme.of(context).copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme).apply(
    displayColor: AppColors.kBlack2,
    bodyColor: AppColors.kBlack2,
  ));
}

ThemeData appLightTheme(BuildContext context) {
  final baseTextTheme = Theme.of(context).textTheme;
  final textTheme = GoogleFonts.poppinsTextTheme(baseTextTheme).apply(
    displayColor: AppColors.kBlack2,
    bodyColor: AppColors.kBlack2,
  );

  final inputTheme = buildInputDecorationTheme(
    borderColor: AppColors.kGray2,
    focusedColor: Theme.of(context).colorScheme.primary,
    disabledColor: AppColors.kLightGray,
    errorColor: AppColors.kRed,
  );

  return ThemeData(
    dividerColor: Colors.grey.shade200,
    cardColor: AppColors.kWhite,
    useMaterial3: true,
    brightness: Brightness.light,
    extensions: [lightCustomTextStyle],
    scaffoldBackgroundColor: AppColors.kLightWhite2,
    appBarTheme: const AppBarTheme(
      color: AppColors.kLightWhite,
      surfaceTintColor: AppColors.kLightWhite,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.kBlack2),
      titleTextStyle: TextStyle(
        color: AppColors.kBlack2,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    drawerTheme: DrawerThemeData(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.1)),
    iconTheme: const IconThemeData(
      color: AppColors.kGray, // light mode
    ),
    colorScheme: ColorScheme.light(
      primary: Theme.of(context).colorScheme.primary,
      secondary: AppColors.kBlack2,
      surface: AppColors.kWhite,
      onPrimary: AppColors.kWhite,
      onSurface: Theme.of(context).colorScheme.onSurface,
    ),
    textTheme: textTheme,
    inputDecorationTheme: inputTheme,
    cardTheme: CardTheme(
      color: AppColors.kWhite,
      elevation: 0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRoundedRadius),
        side: const BorderSide(color: AppColors.kLightGray),
      ),
    ),
    disabledColor: Theme.of(context).disabledColor,
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Theme.of(context).colorScheme.primary; // selected color
        }
        return Colors.grey; // 👈 unselected color
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
        foregroundColor: const WidgetStatePropertyAll(AppColors.kWhite),
      ),
    ),
  );
}

ThemeData appDarkTheme(BuildContext context) {
  final baseTextTheme = Theme.of(context).textTheme;
  final textTheme = GoogleFonts.poppinsTextTheme(baseTextTheme).apply(
    displayColor: AppColors.kWhite,
    bodyColor: AppColors.kWhite,
  );

  final inputTheme = buildInputDecorationTheme(
    borderColor: AppColors.kGray2,
    focusedColor: Theme.of(context).colorScheme.primary,
    disabledColor: Colors.grey.shade700,
    errorColor: AppColors.kRed,
  );

  return ThemeData(
    dividerColor: AppColors.kDarkBg,
    cardColor: AppColors.kCardBackground2,
    useMaterial3: true,
    brightness: Brightness.dark,
    extensions: [darkCustomTextStyle],
    scaffoldBackgroundColor: AppColors.kDarkBg,
    appBarTheme: const AppBarTheme(
      color: AppColors.kDarkBg,
      surfaceTintColor: AppColors.kDarkBg,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.kWhite),
      titleTextStyle: TextStyle(
        color: AppColors.kWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.kDarkBg),
    iconTheme: const IconThemeData(
      color: AppColors.kGray, // light mode
    ),
    colorScheme: ColorScheme.dark(
      primary: Theme.of(context).colorScheme.primary,
      secondary: AppColors.kLightGray,
      surface: const Color(0xFF1E1E1E),
      onPrimary: AppColors.kWhite,
      onSurface: Theme.of(context).colorScheme.onSurface,
    ),
    textTheme: textTheme,
    inputDecorationTheme: inputTheme,
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Theme.of(context).colorScheme.primary; // selected color
        }
        return Colors.grey; // 👈 unselected color
      }),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRoundedRadius),
        side: const BorderSide(color: Colors.grey),
      ),
    ),
    disabledColor: Theme.of(context).disabledColor,
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
        foregroundColor: const WidgetStatePropertyAll(AppColors.kWhite),
      ),
    ),
  );
}


// ThemeData appTheme(BuildContext context) {
//   final baseTextTheme = Theme.of(context).textTheme;
//   final textTheme = GoogleFonts.poppinsTextTheme(baseTextTheme).apply(
//     displayColor: AppColors.kBlack2,
//     bodyColor: AppColors.kBlack2,
//   );

//   const double defaultRoundedRadius = 10.0;

//   InputDecorationTheme inputDecorationTheme = const InputDecorationTheme(
//     hintStyle: TextStyle(fontSize: 14.0),
//     border: OutlineInputBorder(
//       borderSide: BorderSide(color: AppColors.kGray2), // Default border
//       borderRadius: BorderRadius.all(
//         Radius.circular(defaultRoundedRadius),
//       ),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
//       // Color when focused
//       borderRadius: BorderRadius.all(
//         Radius.circular(defaultRoundedRadius),
//       ),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: AppColors.kGray2), // Color when enabled
//       borderRadius: BorderRadius.all(
//         Radius.circular(defaultRoundedRadius),
//       ),
//     ),
//     disabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: AppColors.kLightGray),
//       // Color when disabled
//       borderRadius: BorderRadius.all(
//         Radius.circular(defaultRoundedRadius),
//       ),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: AppColors.kRed), // Color when error occurs
//       borderRadius: BorderRadius.all(
//         Radius.circular(defaultRoundedRadius),
//       ),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: AppColors.kRed, width: 2.0),
//       // Color when focused and there's an error
//       borderRadius: BorderRadius.all(
//         Radius.circular(defaultRoundedRadius),
//       ),
//     ),
//   );

//   final colorScheme = Theme.of(context).colorScheme;

//   return ThemeData(
//     useMaterial3: true,
//     scaffoldBackgroundColor: AppColors.kLightWhite,
//     appBarTheme: const AppBarTheme(
//       color: AppColors.kLightWhite,
//       surfaceTintColor: AppColors.kLightWhite,
//       elevation: 0,
//     ),
//     progressIndicatorTheme: const ProgressIndicatorThemeData(
//       color: AppColors.kWhite,
//     ),
//     colorScheme: colorScheme.copyWith(
//       primary: AppColors.kBlack2,
//     ),
//     dropdownMenuTheme: DropdownMenuThemeData(
//       inputDecorationTheme: inputDecorationTheme,
//     ),
//     textTheme: textTheme,
//     extensions: [customTextStyle],
//     timePickerTheme: const TimePickerThemeData(
//       dialHandColor: Theme.of(context).colorScheme.primary,
//       backgroundColor: AppColors.kLightWhite,
//       dialBackgroundColor: AppColors.kLightWhite,
//       hourMinuteShape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(defaultRoundedRadius),
//         ),
//       ),
//     ),
//     cardTheme: CardTheme(
//       color: Colors.transparent,
//       elevation: 0,
//       margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//         side: const BorderSide(
//           color: AppColors.kLightGray,
//         ),
//       ),
//     ),
//     bottomSheetTheme: const BottomSheetThemeData(
//       backgroundColor: AppColors.kWhite,
//     ),
//     inputDecorationTheme: inputDecorationTheme,
//     textButtonTheme: const TextButtonThemeData(
//       style: ButtonStyle(
//         foregroundColor: WidgetStatePropertyAll(AppColors.kBlack3),
//         shape: WidgetStatePropertyAll(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(defaultRoundedRadius),
//             ),
//           ),
//         ),
//       ),
//     ),
//     filledButtonTheme: const FilledButtonThemeData(
//       style: ButtonStyle(
//         backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
//         foregroundColor: WidgetStatePropertyAll(AppColors.kWhite),
//         minimumSize: WidgetStatePropertyAll(Size(200, 50)),
//         shape: WidgetStatePropertyAll(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(defaultRoundedRadius),
//             ),
//             side: BorderSide(
//               color: AppColors.kGray2,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
