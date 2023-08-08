import 'package:flutter/material.dart';

// tells us the current theme preference of the user. Initialized with true
bool isDark = true;

// The themedata that we will use in dark mode.
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
);

// The themedata that we will use in light mode.
ThemeData lightTheme =
    ThemeData(brightness: Brightness.light, primaryColor: Colors.blue);
