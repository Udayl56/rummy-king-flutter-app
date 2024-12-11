import 'package:flutter/material.dart';

final ThemeData theam = ThemeData(
    appBarTheme: AppBarTheme(
        color: Colors.white,
        centerTitle: false,
        shape: Border.all(color: Colors.black12),
        elevation: 3,
        scrolledUnderElevation: 1,
        titleTextStyle:
            const TextStyle(fontSize: 16, color: Color(0xff282828))),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
      color: Color.fromARGB(224, 0, 0, 0),
      fontSize: 16,
    )),
    inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
          padding:
              WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10))),
    ));
