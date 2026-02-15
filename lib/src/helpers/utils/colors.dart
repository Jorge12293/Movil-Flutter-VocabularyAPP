import 'package:flutter/material.dart';

const appPrimaryColor = Colors.indigo; // Deprecated, use AppColors
const appSecondaryColor = Color.fromRGBO(255, 255, 255, 1); // Deprecated
const appColorGrey = Color(0xFF828282); // Deprecated
const appColorRed = Color.fromARGB(255, 245, 16, 16); // Deprecated
const appColorGreenOpacity = Color.fromARGB(255, 217, 241, 229); // Deprecated
const appColorBlackOpacity = Color.fromARGB(255, 61, 59, 59); // Deprecated

class AppColors {
  // Light Theme
  static const Color lightPrimary = Colors.indigo;
  static const Color lightBackground = Color(0xFFF5F5F5); // Colors.grey[100]
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color.fromARGB(255, 61, 59, 59);
  static const Color lightTextSecondary = Color(0xFF828282);

  // Dark Theme
  static const Color darkPrimary = Colors.indigoAccent;
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.white70;
}
