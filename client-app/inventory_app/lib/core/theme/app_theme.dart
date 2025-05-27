import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Colors
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color secondaryColor = Color(0xFF64748B);
  static const Color accentColor = Color(0xFF34D399);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
  static const Color successColor = Color(0xFF10B981);

  // Light theme colors
  static const Color lightScaffoldBackgroundColor = Color(0xFFF8FAFC);
  static const Color lightBackgroundColor = Colors.white;
  static const Color lightCardColor = Colors.white;
  static const Color lightDividerColor = Color(0xFFE2E8F0);
  static const Color lightTextColor = Color(0xFF1E293B);
  static const Color lightTextSecondaryColor = Color(0xFF64748B);

  // Dark theme colors
  static const Color darkScaffoldBackgroundColor = Color(0xFF0F172A);
  static const Color darkBackgroundColor = Color(0xFF1E293B);
  static const Color darkCardColor = Color(0xFF1E293B);
  static const Color darkDividerColor = Color(0xFF334155);
  static const Color darkTextColor = Color(0xFFF8FAFC);
  static const Color darkTextSecondaryColor = Color(0xFFCBD5E1);

  // Text styles
  static TextStyle get headingLarge => TextStyle(
    fontSize: 34.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.25,
    fontFamily: 'Poppins',
  );

  static TextStyle get headingMedium => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    fontFamily: 'Poppins',
  );

  static TextStyle get headingSmall => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    fontFamily: 'Poppins',
  );

  static TextStyle get titleLarge => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    fontFamily: 'Poppins',
  );

  static TextStyle get titleMedium => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    fontFamily: 'Poppins',
  );

  static TextStyle get titleSmall => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodyLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    fontFamily: 'Poppins',
  );

  static TextStyle get labelLarge => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    fontFamily: 'Poppins',
  );

  static TextStyle get labelMedium => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    fontFamily: 'Poppins',
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    fontFamily: 'Poppins',
  );

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      error: errorColor,
      background: lightBackgroundColor,
      surface: lightCardColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: lightTextColor,
      onSurface: lightTextColor,
      onError: Colors.white,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightScaffoldBackgroundColor,
    cardTheme: CardTheme(
      color: lightCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    dividerTheme: const DividerThemeData(
      color: lightDividerColor,
      thickness: 1,
    ),
    textTheme: TextTheme(
      displayLarge: headingLarge.copyWith(color: lightTextColor),
      displayMedium: headingMedium.copyWith(color: lightTextColor),
      displaySmall: headingSmall.copyWith(color: lightTextColor),
      titleLarge: titleLarge.copyWith(color: lightTextColor),
      titleMedium: titleMedium.copyWith(color: lightTextColor),
      titleSmall: titleSmall.copyWith(color: lightTextColor),
      bodyLarge: bodyLarge.copyWith(color: lightTextColor),
      bodyMedium: bodyMedium.copyWith(color: lightTextColor),
      bodySmall: bodySmall.copyWith(color: lightTextSecondaryColor),
      labelLarge: labelLarge.copyWith(color: lightTextColor),
      labelMedium: labelMedium.copyWith(color: lightTextColor),
      labelSmall: labelSmall.copyWith(color: lightTextSecondaryColor),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      buttonColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        foregroundColor: primaryColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightBackgroundColor,
      contentPadding: EdgeInsets.all(16.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: lightDividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: lightDividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: bodyMedium.copyWith(color: lightTextSecondaryColor),
      hintStyle: bodyMedium.copyWith(color: lightTextSecondaryColor),
      errorStyle: bodySmall.copyWith(color: errorColor),
    ),
    iconTheme: const IconThemeData(color: lightTextColor, size: 24),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackgroundColor,
      foregroundColor: lightTextColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: titleLarge.copyWith(color: lightTextColor),
      iconTheme: const IconThemeData(color: lightTextColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightBackgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: lightTextSecondaryColor,
      selectedLabelStyle: labelMedium,
      unselectedLabelStyle: labelMedium,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: lightTextSecondaryColor,
      labelStyle: labelMedium,
      unselectedLabelStyle: labelMedium,
      indicatorColor: primaryColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      side: const BorderSide(color: secondaryColor),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return secondaryColor;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.5);
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: lightBackgroundColor,
      disabledColor: lightDividerColor,
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: labelMedium,
      secondaryLabelStyle: labelMedium.copyWith(color: Colors.white),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: lightDividerColor),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkBackgroundColor,
      contentTextStyle: bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      behavior: SnackBarBehavior.floating,
      actionTextColor: accentColor,
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      error: errorColor,
      background: darkBackgroundColor,
      surface: darkCardColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: darkTextColor,
      onSurface: darkTextColor,
      onError: Colors.white,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkScaffoldBackgroundColor,
    cardTheme: CardTheme(
      color: darkCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    dividerTheme: const DividerThemeData(color: darkDividerColor, thickness: 1),
    textTheme: TextTheme(
      displayLarge: headingLarge.copyWith(color: darkTextColor),
      displayMedium: headingMedium.copyWith(color: darkTextColor),
      displaySmall: headingSmall.copyWith(color: darkTextColor),
      titleLarge: titleLarge.copyWith(color: darkTextColor),
      titleMedium: titleMedium.copyWith(color: darkTextColor),
      titleSmall: titleSmall.copyWith(color: darkTextColor),
      bodyLarge: bodyLarge.copyWith(color: darkTextColor),
      bodyMedium: bodyMedium.copyWith(color: darkTextColor),
      bodySmall: bodySmall.copyWith(color: darkTextSecondaryColor),
      labelLarge: labelLarge.copyWith(color: darkTextColor),
      labelMedium: labelMedium.copyWith(color: darkTextColor),
      labelSmall: labelSmall.copyWith(color: darkTextSecondaryColor),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      buttonColor: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        foregroundColor: primaryColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkBackgroundColor,
      contentPadding: EdgeInsets.all(16.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: darkDividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: darkDividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: bodyMedium.copyWith(color: darkTextSecondaryColor),
      hintStyle: bodyMedium.copyWith(color: darkTextSecondaryColor),
      errorStyle: bodySmall.copyWith(color: errorColor),
    ),
    iconTheme: const IconThemeData(color: darkTextColor, size: 24),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackgroundColor,
      foregroundColor: darkTextColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: titleLarge.copyWith(color: darkTextColor),
      iconTheme: const IconThemeData(color: darkTextColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkBackgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: darkTextSecondaryColor,
      selectedLabelStyle: labelMedium,
      unselectedLabelStyle: labelMedium,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: darkTextSecondaryColor,
      labelStyle: labelMedium,
      unselectedLabelStyle: labelMedium,
      indicatorColor: primaryColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      side: const BorderSide(color: secondaryColor),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return secondaryColor;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.5);
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkBackgroundColor,
      disabledColor: darkDividerColor,
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: labelMedium,
      secondaryLabelStyle: labelMedium.copyWith(color: Colors.white),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: darkDividerColor),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: lightBackgroundColor,
      contentTextStyle: bodyMedium.copyWith(color: lightTextColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      behavior: SnackBarBehavior.floating,
      actionTextColor: accentColor,
    ),
  );
}
