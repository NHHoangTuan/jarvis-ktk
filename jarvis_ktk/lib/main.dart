import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/network/bot_api.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:jarvis_ktk/data/providers/knowledge_provider.dart';
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
        ChangeNotifierProvider(create: (_) => BotProvider(getIt<BotApi>())),
        ChangeNotifierProvider(
            create: (_) => KnowledgeProvider(getIt<KnowledgeApi>())),
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
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ));
  }
}
