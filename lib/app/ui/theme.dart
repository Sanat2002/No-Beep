import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Color(0xffFEFEFE),
    dialogBackgroundColor: Color(0xffE0E3EB),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.poppins(
            fontSize: 24,
            color: Color(0xff8081DB),
            fontWeight: FontWeight.w500),
        hintStyle: GoogleFonts.poppins(
            fontSize: 20,
            color: Color(0xff8081DB),
            fontWeight: FontWeight.normal)),
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.poppins(
          color: Color(0xff98999B), letterSpacing: 3, fontSize: 18),
      titleLarge: GoogleFonts.poppins(
          fontSize: 40, color: Color(0xff323232), fontWeight: FontWeight.w500),
      titleMedium: GoogleFonts.poppins(
          fontSize: 20, color: Color(0xff323232), fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.poppins(
          fontSize: 20,
          color: Color(0xff98999B),
          fontWeight: FontWeight.normal),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Color(0xff8081DB), // Your accent color
    ),
    bottomAppBarColor: Colors.cyan,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.cyan,
      textTheme: ButtonTextTheme.primary,
    ),
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    // buttonColor: Colors.deepPurple,
    bottomAppBarColor: Colors.deepPurple,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
