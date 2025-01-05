import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/pages/email_reply/email_reply_page.dart';
import 'package:jarvis_ktk/pages/personal/knowledge.dart';
import 'package:jarvis_ktk/pages/personal/my_bot.dart';
import 'package:jarvis_ktk/pages/personal/my_bot_app_bar.dart';
import 'package:jarvis_ktk/widgets/nav_drawer.dart';
import 'package:provider/provider.dart';

import 'chat/chat_app_bar.dart';
import 'chat/chat_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable to track which screen is being displayed in the body
  Widget _currentBody = const ChatBody(conversationId: '');
  PreferredSizeWidget _currentAppBar = const ChatAppBar();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Correct key placement
  String _currentSelectedItem = 'Chat'; // Thêm biến để theo dõi mục đang chọn
  final bool _isLoading = false;

  // Method to change the body content
  void _changeBody(Widget newBody) {
    setState(() {
      _currentBody = newBody;
    });
  }

  void _changeAppBar(PreferredSizeWidget newAppBar) {
    setState(() {
      _currentAppBar = newAppBar;
    });
  }

  // Thêm method để thay đổi selected item
  void _changeSelectedItem(String newItem) {
    setState(() {
      _currentSelectedItem = newItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        key: _scaffoldKey, // Associate the Scaffold with the GlobalKey
        appBar: _currentAppBar,
        drawer: NavDrawer(
          initialSelectedItem:
              _currentSelectedItem, // Truyền selected item hiện tại
          onItemTap: (selectedItem) {
            _changeSelectedItem(selectedItem); // Cập nhật selected item
            // Change body content based on the selected item
            switch (selectedItem) {
              case 'Chat':
                if (context.read<ChatProvider>().selectedConversationId != '' &&
                    context.read<ChatProvider>().isTapHistory == true) {
                  // Nếu có conversation được chọn, load conversation đó
                  _changeBody(ChatBody(
                    conversationId:
                        context.read<ChatProvider>().selectedConversationId,
                  ));
                } else {
                  // Nếu không có conversation được chọn, load ChatBody mặc định
                  _changeBody(const ChatBody(conversationId: ''));
                }
                //_changeBody(const ChatBody(conversationId: ''));

                _changeAppBar(const ChatAppBar());
                break;
              case 'Personal':
                _changeBody(const Center(child: Text('Personal Chat')));
                _changeAppBar(AppBar(title: const Text('Personal Chat')));
                break;
              case 'Email Reply':
                _changeBody(const EmailReplyPage());
                break;
              case 'My Bot': // Handle My Bot case
                _changeBody(const MyBotPage());
                _changeAppBar(const MyBotAppBar());
                break;
              case 'Knowledge': // Handle Knowledge case
                _changeBody(const KnowledgePage());
                _changeAppBar(AppBar(
                    title: const Text('Knowledge'),
                    scrolledUnderElevation: 0,
                    elevation: 0,
                    backgroundColor: Colors.blue[50]));
                break;
            }

            Navigator.pop(context); // Close the drawer after selecting an item
          },
        ),
        body: Stack(
          children: [
            _currentBody, // Display the currently selected body content
            // Swipe area to open drawer
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 500) {
                  _scaffoldKey.currentState!.openDrawer();
                }
              },
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    ]);
  }
}
