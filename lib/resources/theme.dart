import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kContentColorLightTheme,
    accentColor: Colors.white,
    scaffoldBackgroundColor: kContentColorDarkTheme,
    appBarTheme: appBarTheme,
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
      primaryColor: kContentColorDarkTheme,
      accentColor: Colors.black,
      scaffoldBackgroundColor: kContentColorLightTheme,
      appBarTheme: appBarTheme,
  );
}

final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);