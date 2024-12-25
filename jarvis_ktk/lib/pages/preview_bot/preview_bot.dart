import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/tabs/develop_preview_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/tabs/chat_preview_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/tabs/knowledge_preview_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/dialog/edit_preview_bot.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../data/providers/bot_provider.dart'; // Import file edit_preview_bot.dart

class PreviewBotPage extends StatefulWidget {
  //final VoidCallback onPublish; // Thêm callback onPublish

  const PreviewBotPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PreviewBotPageState createState() => _PreviewBotPageState();
}

class _PreviewBotPageState extends State<PreviewBotPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BotProvider>(builder: (context, botProvider, child) {
      final bot = botProvider.selectedBot;
      if (bot == null) return const Center(child: Text('No bot selected'));

      return DefaultTabController(
        length: 3, // Số lượng tab
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Expanded(flex: 8, child: Text(bot.assistantName)), // Tên bot
                //const SizedBox(width: 5), // Khoảng cách giữa text và nút 'Edit'
                Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => showCupertinoModalBottomSheet(
                      expand: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SingleChildScrollView(
                          child:
                              EditPreviewBotPage(bot: bot)), // Truyền bot vào
                      enableDrag: false,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0), // Add padding here
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        SimpleColors.navyBlue, // Sử dụng màu navyBlue
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Set border radius to 5
                    ),
                  ),
                  onPressed: () {}, // Gọi callback onPublish
                  child: const Row(
                    children: [
                      Icon(Icons.cloud_upload, color: Colors.white), // Add icon
                    ],
                  ),
                ),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Develop'),
                Tab(text: 'Preview'),
                Tab(text: 'Knowledge'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DevelopPreviewBotPage(
                  controller: _controller), // Truyền controller vào
              const ChatPreviewBotPage(),
              const KnowledgePreviewBotPage(),
            ],
          ),
        ),
      );
    });
  }
}
