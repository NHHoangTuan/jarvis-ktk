import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jarvis_ktk/data/network/bot_api.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/data/network/token_api.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/data/providers/knowledge_provider.dart';
import 'package:jarvis_ktk/routes/app_routes.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:provider/provider.dart';

import 'data/network/chat_api.dart';
import 'data/providers/token_provider.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // Add test devices
  if (kDebugMode) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['F6BE0FB55352045456E9D915CE0D8AB6']),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TokenProvider(getIt<TokenApi>())),
        ChangeNotifierProvider(create: (_) => ChatProvider(getIt<ChatApi>())),
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
