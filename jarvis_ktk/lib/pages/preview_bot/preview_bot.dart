import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/tabs/develop_preview_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/tabs/chat_preview_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/tabs/knowledge_preview_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/dialog/edit_preview_bot.dart'; // Import file edit_preview_bot.dart

class PreviewBotPage extends StatefulWidget {
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
    return DefaultTabController(
      length: 3, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const SizedBox(width: 5), // Khoảng cách giữa avatar và text
              const CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'),
                radius: 20,
              ),
              const SizedBox(width: 10), // Khoảng cách giữa avatar và text
              const Text('Bot Name'),
              const SizedBox(width: 5), // Khoảng cách giữa text và nút 'Edit'
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Bo tròn các góc
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Edit Bot'),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: EditPreviewBotPage(
                            onApply: () {},
                          ), // Hiển thị EditPreviewBotPage
                        ),
                      );
                    },
                  );
                },
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
                        BorderRadius.circular(5), // Set border radius to 5
                  ),
                ),
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút 'Publish'
                },
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
          automaticallyImplyLeading: false, // Remove the back button
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
  }
}
