import 'package:flutter/material.dart';
import '../constans.dart';

class ThemeClass {
  static ThemeData appTheme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor[100]!.withOpacity(0.5),
      selectionHandleColor: primaryColor,
    ),
    primaryColor: primaryColor,
    primarySwatch: primaryColor,
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: primaryColor),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        fontSize: 25,
        color: Colors.redAccent[400],
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
    ),
  );
}
