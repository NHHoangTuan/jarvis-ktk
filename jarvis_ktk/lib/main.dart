import 'package:flutter/material.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:jarvis_ktk/pages/login/login_page.dart';

void main() {
  setupLocator();
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
