import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme => _build(dark: true);
  static ThemeData get lightTheme => _build(dark: false);

  static ThemeData _build({required bool dark}) {
    final base = dark ? AppColors.textWhite : AppColors.textDark;
    final sub  = dark ? AppColors.textGrey1  : AppColors.textGrey2;

    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: dark ? AppColors.darkBg : AppColors.lightBg,
      colorScheme: ColorScheme(
        brightness: dark ? Brightness.dark : Brightness.light,
        primary:    AppColors.primaryViolet,
        onPrimary:  Colors.white,
        secondary:  AppColors.accentGreen,
        onSecondary: Colors.black,
        surface:    dark ? AppColors.darkSurface : AppColors.lightSurface,
        onSurface:  dark ? AppColors.textWhite : AppColors.textDark,
        error:      AppColors.accentRed,
        onError:    Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge:   GoogleFonts.spaceGrotesk(fontSize: 34, fontWeight: FontWeight.w800, color: base, letterSpacing: -1.4),
        displayMedium:  GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.w700, color: base, letterSpacing: -0.8),
        headlineMedium: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: base, letterSpacing: -0.4),
        titleLarge:     GoogleFonts.spaceGrotesk(fontSize: 17, fontWeight: FontWeight.w600, color: base),
        titleMedium:    GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600, color: base),
        bodyLarge:      GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w400, color: sub),
        bodyMedium:     GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400, color: sub),
        labelLarge:     GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600, color: base),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 17, fontWeight: FontWeight.w700, color: base,
        ),
        iconTheme: IconThemeData(color: base),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.darkElevated : AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryViolet, width: 1.5),
        ),
        hintStyle: GoogleFonts.spaceGrotesk(fontSize: 14, color: dark ? AppColors.textGrey2 : AppColors.textGrey1),
        prefixStyle: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600, color: dark ? AppColors.textGrey1 : AppColors.textGrey2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: dark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
    );
  }
}
