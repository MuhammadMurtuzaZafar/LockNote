import 'package:flutter/material.dart';

import 'constants.dart';

final ThemeData themeData2 = ThemeData(
    dialogTheme: const DialogTheme(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.2, color: Colors.white),
        )),
    scaffoldBackgroundColor: KColor.scaffold_bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ),
    primarySwatch: Colors.blue,
    primaryColor: Colors.black38,
    hintColor: Colors.white,
    buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.dark(background: KColor.scaffold_bg)),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.black),
    inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: KColor.scaffold_bg)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: KColor.scaffold_bg)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.grey)),
    cardColor: KColor.scaffold_bg,
    backgroundColor: KColor.scaffold_bg,
    textTheme: TextTheme(subtitle1: TextStyle(color: Colors.white)).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    listTileTheme: ListTileThemeData(
      textColor: KColor.white,
    )


    );
final ThemeData themeData = ThemeData(
  primaryColor: KColor.kPrimaryColor,
  buttonTheme: const ButtonThemeData(
    buttonColor: KColor.kPrimaryColor,
  ),
  colorScheme: const ColorScheme(
    primary: KColor.kPrimaryColor,
    onPrimary: Colors.white,
    primaryVariant: Colors.orange,
    background: Colors.white,
    onBackground: Colors.black,
    secondary: Color(0xFF970A0A),
    onSecondary: Colors.white,
    secondaryVariant: Colors.deepOrange,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    brightness: Brightness.light,
  ),
);
