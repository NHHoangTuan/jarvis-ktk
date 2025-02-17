import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/pages/email_reply/email_reply_page.dart';
import 'package:jarvis_ktk/pages/login/login_page.dart';
import 'package:jarvis_ktk/pages/preview_bot/publish_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/knowledge_info_page.dart';

import '../pages/home_page.dart';
import '../pages/preview_bot/preview_bot.dart';

class AppRoutes {
  // Route names
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String previewbot = '/previewbot';
  static const String emailReply = '/email-reply';
  static const String knowledgeInfo = '/knowledge-info';
  static const String publishbot = '/publishbot';

  // Route definitions
  static Map<String, Widget Function(BuildContext)> get routes => {
        initial: (context) => const HomePage(),
        login: (context) => LoginPage(),
        register: (context) => LoginPage(),
        home: (context) => const HomePage(),
        previewbot: (context) => const PreviewBotPage(),
        emailReply: (context) => const EmailReplyPage(),
        knowledgeInfo: (context) {
          final knowledge =
              ModalRoute.of(context)!.settings.arguments as Knowledge;
          return KnowledgeInfoPage(knowledge: knowledge);
        },
        publishbot: (context) => const PublishBotPage(),
      };
}
