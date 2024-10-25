import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/email_reply/email_reply_page.dart';
import 'package:jarvis_ktk/pages/personal/my_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/preview_bot.dart';
import 'package:jarvis_ktk/pages/personal/knowledge.dart';
import 'package:jarvis_ktk/widgets/nav_drawer.dart';
import 'package:provider/provider.dart';
import 'chat/chat_app_bar.dart';
import 'chat/chat_body.dart';
import 'email_reply/email_reply_app_bar.dart';
import 'chat/chat_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable to track which screen is being displayed in the body
  Widget _currentBody = ChatBody();
  PreferredSizeWidget _currentAppBar = ChatAppBar();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Correct key placement
  String _currentSelectedItem = 'Chat'; // Thêm biến để theo dõi mục đang chọn

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

  void _handleHistoryTap(int index) {
    // Tạo đoạn chat mẫu dựa trên index
    final List<Map<String, dynamic>> sampleMessages = [
      {
        'text': 'Hello, how can I help you today?',
        'isUser': false,
        'timestamp': DateTime.now(),
        'avatar': 'assets/bot_avatar.jpg',
      },
      {
        'text': 'I need some information about your services.',
        'isUser': true,
        'timestamp': DateTime.now(),
        'avatar': 'assets/user_avatar.jpg',
      },
    ];

    // Chuyển đến màn hình Chat
    _changeSelectedItem('Chat');
    _changeBody(ChatBody(isHistory: true, historyChatMessages: sampleMessages));
    _changeAppBar(ChatAppBar());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatModel(),
      child: Scaffold(
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
                _changeBody(ChatBody());
                _changeAppBar(ChatAppBar());
                break;
              case 'Personal':
                _changeBody(const Center(child: Text('Personal Chat')));
                _changeAppBar(AppBar(title: const Text('Personal Chat')));
                break;
              case 'Email Reply':
                _changeBody(const EmailReplyPage());
                _changeAppBar(const EmailReplyAppBar());
                break;
              case 'My Bot': // Handle My Bot case
                _changeBody(MyBotPage(
                  onApply: () {
                    _changeBody(const PreviewBotPage());
                    _changeAppBar(AppBar(title: const Text('Preview Bot')));
                  },
                ));
                _changeAppBar(AppBar(title: const Text('My Bot')));
                break;
              case 'Knowledge': // Handle Knowledge case
                _changeBody(const KnowledgePage());
                _changeAppBar(AppBar(title: const Text('Knowledge')));
                break;
            }

            Navigator.pop(context); // Close the drawer after selecting an item
          },
          onHistoryTap: _handleHistoryTap, // Thêm callback cho lịch sử chat
        ),
        body: Stack(
          children: [
            _currentBody, // Display the currently selected body content
            // Swipe area to open drawer
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  _scaffoldKey.currentState!.openDrawer();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
