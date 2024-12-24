import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/login/login_page.dart';
import '../pages/home_page.dart';
import '../pages/preview_bot/preview_bot.dart';

class AppRoutes {
  // Route names
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String previewbot = '/previewbot';

  // Route definitions
  static Map<String, Widget Function(BuildContext)> get routes => {
        initial: (context) => const HomePage(),
        login: (context) => LoginPage(),
        register: (context) => LoginPage(),
        home: (context) => const HomePage(),
        previewbot: (context) => const PreviewBotPage(),
      };
}
