import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF307302);
const Color secondaryColor = Color(0xFFF28705);

final ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: primaryColor,
    primaryContainer: primaryColor,
    secondary: secondaryColor,
    secondaryContainer: secondaryColor,
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.grey,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  
);
