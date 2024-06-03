import 'package:flutter/material.dart';

const textTheme = TextTheme(
  titleLarge: TextStyle(fontSize: 28),
  headlineSmall: TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
  titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
  labelMedium: TextStyle(fontSize: 18, color: Colors.white),
  labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
);

ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.grey[300],
    centerTitle: true,
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.blueAccent,
    cardColor: Colors.grey[100],
    backgroundColor: Colors.grey[300],
    brightness: Brightness.light,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black)
    )
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.blue
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        )
      )
    ),
  ),
  textTheme: textTheme
);