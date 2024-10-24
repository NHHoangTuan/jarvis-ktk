import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/chart_input.dart';
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

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        message: _controller.text,
        isBot: false,
      ));
      _controller.clear();

      // Generate a random response from predefinedMessages
      final random = Random();
      final response =
      predefinedMessages[random.nextInt(predefinedMessages.length)];

      _messages.add(ChatMessage(
        message: response,
        isBot: true,
      ));
    });

    // Scroll to the bottom with a slight offset
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent +
          80, // Adjust the offset as needed
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure keep-alive functionality
    return Column(
      children: <Widget>[
        Expanded(
          child: _messages.isEmpty
              ? const EmptyChatScreen()
              : ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _messages[index];
            },
          ),
        ),
        // chat input
        ChatInput(
          controller: _controller,
          onSendMessage: _sendMessage,
          onClearMessages: () {
            setState(() {
              _messages.clear();
            });
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true; // Ensure the state is kept alive
}
