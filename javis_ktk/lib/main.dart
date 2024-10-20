import 'package:flutter/material.dart';
import 'package:javis_ktk/pages/home_page.dart';

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
      home: HomePage(),
    );
  }
}
