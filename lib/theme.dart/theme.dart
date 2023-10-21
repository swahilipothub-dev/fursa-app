import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF045D87);
  static const Color secondaryColor = Color(0xFF8FC21D);
  static const Color backgroundWhite = Color(0xFFF5F5F5);

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins-Regular',
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundWhite,
    primaryColorLight: secondaryColor,
  );
}
