import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/network/chat_api.dart';
import 'package:jarvis_ktk/pages/email_reply/email_reply_page.dart';
import 'package:jarvis_ktk/pages/personal/my_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/preview_bot.dart';
import 'package:jarvis_ktk/pages/personal/knowledge.dart';
import 'package:jarvis_ktk/pages/preview_bot/publish_bot.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
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
  Widget _currentBody = const ChatBody();
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
    setState(() {});
  }

  // Thêm method để thay đổi selected item
  void _changeSelectedItem(String newItem) {
    setState(() {
      _currentSelectedItem = newItem;
    });
  }

  List<Map<String, dynamic>> _convertHistoryMessages(
      List<ChatHistory> historyChatMessages) {
    List<Map<String, dynamic>> convertedMessages = [];
    for (var message in historyChatMessages) {
      convertedMessages.add({
        'text': message.query,
        'isUser': true,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(message.createdAt),
        'avatar': 'assets/user_avatar.jpg',
      });
      convertedMessages.add({
        'text': message.answer,
        'isUser': false,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(message.createdAt),
        'avatar': 'assets/ai_avatar.png',
      });
    }
    return convertedMessages;
  }

  void _handleHistoryTap(String conversationId, String assistantId) async {
    // Lấy lịch sử chat từ loadConversationHistory
    final chatApi = getIt<ChatApi>();
    List<ChatHistory> historyChatMessages =
        await chatApi.loadConversationHistory(
            conversationId,
            AssistantId.values.firstWhere((e) => e.name == assistantId),
            AssistantModel.DIFY);

    // Chuyển đổi lịch sử chat thành định dạng cần thiết
    List<Map<String, dynamic>> nowMessages =
        _convertHistoryMessages(historyChatMessages);

    // Chuyển đến màn hình Chat
    _changeSelectedItem('Chat');
    _changeBody(ChatBody(
      isHistory: true,
      historyChatMessages: nowMessages,
      conversationId: conversationId,
    ));
    _changeAppBar(ChatAppBar(onAgentChanged: _handleAgentChanged));
  }

  void _handleAgentChanged(String agentId) {
    final chatModel = Provider.of<ChatModel>(context, listen: false);
    chatModel.setSelectedAgent(agentId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatModel(),
      child: Scaffold(
        key: _scaffoldKey, // Associate the Scaffold with the GlobalKey
        appBar: ChatAppBar(onAgentChanged: _handleAgentChanged),
        drawer: NavDrawer(
          initialSelectedItem:
              _currentSelectedItem, // Truyền selected item hiện tại
          onItemTap: (selectedItem) {
            _changeSelectedItem(selectedItem); // Cập nhật selected item
            // Change body content based on the selected item
            switch (selectedItem) {
              case 'Chat':
                _changeBody(const ChatBody());
                _changeAppBar(ChatAppBar(onAgentChanged: _handleAgentChanged));
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
                    _changeBody(PreviewBotPage(
                      onPublish: () {
                        _changeBody(const PublishBotPage());
                        _changeAppBar(AppBar(title: const Text('Publish Bot')));
                      },
                    ));
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
          onHistoryTap: (conversationId) => _handleHistoryTap(
            conversationId,
            Provider.of<ChatModel>(context, listen: false).selectedAgent,
          ),
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
