import 'dart:math';

import 'package:flutter/material.dart';

import 'widgets/chat_input.dart';
import 'widgets/chat_message.dart';
import 'widgets/empty_chat_screen.dart';

// List chat demo UI
const List<String> predefinedMessages = [
  '''
Hey everyone,

Hope you're all doing well!

I'm excited to share that I'm planning a little getaway this weekend. I'm thinking of heading to the beach to relax and soak up some sun. I'll probably spend most of my time swimming, reading, and enjoying the delicious seafood. 

Let me know if any of you are interested in joining me! It would be great to catch up and have some fun. 

Best,
[Your name]
''',
  "Cảm ơn",
  "Chúc mừng",
  "Vui vẻ",
];

class EmailReplyPage extends StatefulWidget {
  const EmailReplyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailReplyPage createState() => _EmailReplyPage();
}

class _EmailReplyPage extends State<EmailReplyPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String? action) {
    if (_controller.text.isEmpty && action == null) return;

    if (action != null) {
      _controller.text = action;
    }

    addMessage(_controller.text);
  }

  void addMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        message: _controller.text,
        isBot: false,
        onSendMessage: _sendMessage,
      ));
      _controller.clear();

      final random = Random();
      final response =
          predefinedMessages[random.nextInt(predefinedMessages.length)];

      _messages.add(ChatMessage(
        message: response,
        isBot: true,
        onSendMessage: _sendMessage,
        isPreviousMessage: true,
      ));
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 200,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              child: _messages.isEmpty
                  ? const EmptyChatScreen()
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: ChatMessage(
                            message: _messages[index].message,
                            isBot: _messages[index].isBot,
                            onSendMessage: _messages[index].onSendMessage,
                            isPreviousMessage: index == _messages.length - 1,
                          ),
                        );
                      },
                    ),
            ),
            // chat input
            ChatInput(
              controller: _controller,
              onSendMessage: () => _sendMessage(null),
              onClearMessages: () {
                setState(() {
                  _messages.clear();
                });
              },
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
