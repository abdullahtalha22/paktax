import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary:   AppColors.salaryBlue,
        secondary: AppColors.accentGreen,
        surface:   AppColors.darkSurface,
        onPrimary: Colors.white,
        onSurface: AppColors.textWhite,
      ),
      textTheme: _buildTextTheme(dark: true),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textWhite,
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      inputDecorationTheme: _inputTheme(dark: true),
      elevatedButtonTheme: _buttonTheme(),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary:   AppColors.salaryBlue,
        secondary: AppColors.accentGreen,
        surface:   AppColors.lightSurface,
        onPrimary: Colors.white,
        onSurface: AppColors.textDark,
      ),
      textTheme: _buildTextTheme(dark: false),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      inputDecorationTheme: _inputTheme(dark: false),
      elevatedButtonTheme: _buttonTheme(),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme({required bool dark}) {
    final baseColor = dark ? AppColors.textWhite : AppColors.textDark;
    final subColor  = dark ? AppColors.textGrey1  : AppColors.textDark2;
    return TextTheme(
      displayLarge:  GoogleFonts.sora(fontSize: 30, fontWeight: FontWeight.w800, color: baseColor, letterSpacing: -1),
      displayMedium: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w700, color: baseColor, letterSpacing: -0.5),
      headlineMedium:GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: baseColor),
      titleLarge:    GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: baseColor),
      titleMedium:   GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
      bodyLarge:     GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w400, color: subColor),
      bodyMedium:    GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w400, color: subColor),
      labelLarge:    GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
    );
  }

  static InputDecorationTheme _inputTheme({required bool dark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: dark ? AppColors.darkElevated : AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.salaryBlue, width: 1.5),
      ),
      hintStyle: GoogleFonts.sora(
        fontSize: 14,
        color: dark ? AppColors.textGrey2 : AppColors.textGrey1,
      ),
      prefixStyle: GoogleFonts.sora(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: dark ? AppColors.textGrey1 : AppColors.textDark2,
      ),
    );
  }

  static ElevatedButtonThemeData _buttonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}
