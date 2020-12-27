import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singlestore/configs/colors.dart';

getSimpleAppbar(String title, List<Widget> actions) {
  return AppBar(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: THEME_COLOR_PRIMARY),
    actions: actions,
    title: Text(
      title,
      style: GoogleFonts.manrope(
        color: THEME_COLOR_PRIMARY,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
  );
}
