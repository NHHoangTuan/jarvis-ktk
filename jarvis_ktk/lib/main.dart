import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/home/home_page.dart';
import 'package:jarvis_ktk/pages/login/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis KTK',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
