import 'package:flutter/material.dart';

Widget padding(
    {double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
    Widget? child}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(left, top, right, bottom),
    child: child,
  );
}
