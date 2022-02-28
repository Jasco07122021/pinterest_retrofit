import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      hoverColor: Colors.black,
      shadowColor: Colors.white,
      primaryColor: Colors.white,
      backgroundColor: Colors.grey.shade200,
      iconTheme: const IconThemeData(color: Colors.black),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
        toolbarTextStyle: TextStyle(color: Colors.black),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.7),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        button: TextStyle(color: Colors.black),
        headline1: TextStyle(color: Colors.black),
        headline2: TextStyle(color: Colors.black),
        bodyText1: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      listTileTheme: const ListTileThemeData(textColor: Colors.black)
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      hoverColor: Colors.white,
      primaryColor: Colors.black,
      shadowColor: CupertinoColors.secondaryLabel,
      backgroundColor: Colors.grey.shade900,
      iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.black),
        toolbarTextStyle: TextStyle(color: Colors.black),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.4),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
        )
      ),
      cardColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        headline1: TextStyle(color: Colors.white),
        headline2: TextStyle(color: Colors.white),
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        listTileTheme: const ListTileThemeData(textColor: Colors.white)
    );
  }
}