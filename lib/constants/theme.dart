import "package:flutter/material.dart";
import "package:wordle/constants/colors.dart";

class AppTheme {
  static const String _font = "Antic";
  static const double _fontSize = 24.0;

  static final ThemeData lightTheme = ThemeData(
    fontFamily: _font,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    dividerColor: COLORS.borderLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontFamily: _font,
        fontSize: _fontSize,
        color: Colors.black,
        fontWeight: FontWeight.w900,
      ),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    primaryColor: COLORS.primary,
    primaryColorLight: COLORS.lightShadeLight,
    primaryColorDark: COLORS.darkShadeLight,
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: _font,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    dividerColor: COLORS.borderDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        fontFamily: _font,
        fontSize: _fontSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    primaryColor: COLORS.primary,
    primaryColorLight: COLORS.lightShadeDark,
    primaryColorDark: COLORS.darkShadeDark,
  );
}
