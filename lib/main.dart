import 'dart:io';

import 'package:flutter/material.dart';

import 'page/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData;
    if (Platform.isWindows) {
      themeData = ThemeData(
        fontFamily: '微软雅黑',
        primarySwatch: Colors.blue,
      );
    } else {
      themeData = ThemeData(primarySwatch: Colors.blue);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '鸿蒙App工具助手',
      theme: themeData,
      home: const HomePage(),
    );
  }
}
