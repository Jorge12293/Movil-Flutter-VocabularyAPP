import 'package:appbasicvocabulary/src/helpers/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.lightPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    cardColor: AppColors.lightSurface,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.lightTextPrimary),
      bodyMedium: GoogleFonts.poppins(color: AppColors.lightTextSecondary),
      titleLarge: GoogleFonts.poppins(
          color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.lightPrimary,
      brightness: Brightness.light,
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.darkPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    cardColor: AppColors.darkSurface,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.darkTextPrimary),
      bodyMedium: GoogleFonts.poppins(color: AppColors.darkTextSecondary),
      titleLarge: GoogleFonts.poppins(
          color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.darkPrimary,
      brightness: Brightness.dark,
    ),
  );
}

// Deprecated, keeping for temporary compatibility if needed, but main.dart will use the above.
ThemeData buildAppTheme() => buildLightTheme();
