import 'dart:math';
import 'package:flutter/material.dart';

class ChatPreviewBotPage extends StatelessWidget {
  const ChatPreviewBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatArea(),
    );
  }
}

// List chat demo UI
const List<String> predefinedMessages = [
  "Xin chào",
  "Cảm ơn",
  "Chúc mừng",
  "Vui vẻ",
];

class ChatArea extends StatefulWidget {
  const ChatArea({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatAreaState createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        name: "User",
        message: _controller.text,
        isBot: false,
      ));
      _controller.clear();

      // Generate a random response from predefinedMessages
      final random = Random();
      final response =
          predefinedMessages[random.nextInt(predefinedMessages.length)];

      _messages.add(ChatMessage(
        name: "Bot",
        message: response,
        isBot: true,
      ));
    });

    // Scroll to the bottom with a slight offset
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent +
          100, // Adjust the offset as needed
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
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.android, size: 30),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Bot",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Start a conversation with the assistant by typing a message in the input box below",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.sms),
                onPressed: () {
                  setState(() {
                    _messages.clear();
                  });
                },
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true; // Ensure the state is kept alive
}

class ChatMessage extends StatelessWidget {
  final String name;
  final String message;
  final bool isBot;

  const ChatMessage(
      {super.key,
      required this.name,
      required this.message,
      required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment:
              isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isBot ? Colors.black : Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment:
                  isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: <Widget>[
                if (isBot)
                  const CircleAvatar(
                    child: Icon(Icons.android),
                  ),
                if (isBot) const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(top: 5.0),
                    decoration: BoxDecoration(
                      color: isBot ? Colors.grey[300] : Colors.blue[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(message),
                  ),
                ),
                if (!isBot) const SizedBox(width: 10),
                if (!isBot)
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
