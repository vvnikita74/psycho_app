import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Config {
  static const Color backgroundColor = Color(0xFF9DE1FC);
  static const Color headlineColor = Color(0xFFFCFCFE);
  static const Color buttonTextColor = Color(0xFF1582B4);
  static const Color backgroundLightColor = Color(0xD9C5EEFF);
  static const double basePadding = 12.0;

  static const EdgeInsets contentPadding = EdgeInsets.all(basePadding);

  static ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll<Color>(backgroundLightColor),
    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(12)),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: buttonTextColor),
      ),
    ),
  );

  static TextStyle headlineStyle = GoogleFonts.rubik(
    color: headlineColor,
    height: 1.0,
    fontWeight: FontWeight.w700,
    fontSize: 24,
  );

  static TextStyle buttonTextStyle = GoogleFonts.montserrat(
    color: buttonTextColor,
    height: 1.05,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
}
