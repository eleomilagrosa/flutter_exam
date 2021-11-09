import 'package:flutter/material.dart';
import 'package:flutter_exam/constants/colors.dart';

final ThemeData themeDataDark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  primaryColorBrightness: Brightness.dark,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.white
    )
  ),
  backgroundColor: AppColors.backgroundDark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  dialogBackgroundColor: AppColors.backgroundDark,
  dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(.2)
  ),
  inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(0.0),
      errorMaxLines: 10,
      floatingLabelStyle: TextStyle(
          color: AppColors.warmGrey
      ),
      labelStyle: TextStyle(
          color: AppColors.warmGrey
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
      )
  )
);
