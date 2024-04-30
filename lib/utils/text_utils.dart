import 'package:flutter/material.dart';

Widget normalText(String text,
    {double fontSize = 18,
    int color = 0xFF404040,
    FontWeight fontWeight = FontWeight.w500}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: Color(color),
      fontWeight: fontWeight,
    ),
  );
}
