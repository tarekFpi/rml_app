import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmv_lite/core/theme/color_scheme.dart';
import 'package:tmv_lite/utils/hexcolor.dart';

class AppTheme {
  static ThemeData lightTheme() {
    //transparent status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark
    ));


    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white, backgroundColor: Colors.white),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: HexColor("#FFFFFF"),
            backgroundColor: HexColor("#5154B2"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      )),
      inputDecorationTheme: InputDecorationTheme(
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#BCC2EB")),
              borderRadius: BorderRadius.circular(8)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#BCC2EB")),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#BCC2EB"), width: 2),
              borderRadius: BorderRadius.circular(8))),
      colorScheme: lightColorScheme,
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: HexColor("5154B2"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
    );
  }
}
