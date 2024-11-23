import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/chat/chat_model.dart';
import 'package:jarvis_ktk/routes/app_routes.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatModel()),
      ],
      child: const MainApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis KTK',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
    );
  }
}
