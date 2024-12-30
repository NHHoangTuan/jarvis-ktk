import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/message.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:provider/provider.dart';

class ChatPreviewBotPage extends StatelessWidget {
  const ChatPreviewBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatArea(),
    );
  }
}

class ChatArea extends StatefulWidget {
  const ChatArea({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatAreaState createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  List<MessageData> _messages = [];
  final ScrollController _scrollController = ScrollController();

  final FocusNode _chatFocusNode = FocusNode();
  bool _isLoading = false;
  bool _isWaitingForResponse = false;

  @override
  void initState() {
    super.initState();
    _handleRetrieveMessage();
  }

  void _handleSendMessage() async {
    if (_controller.text.isEmpty) return;

    try {
      // Get the selected bot

      final botId = context.read<BotProvider>().selectedBot?.id;

      String userMessage = _controller.text;

      setState(() {
        _messages.add(MessageData(
            role: "user",
            createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            content: [
              MessageContent(
                  type: "text",
                  text: MessageText(value: userMessage, annotations: []))
            ]));

        // Placeholder for the bot response
        _messages.add(MessageData(
          role: "assistant",
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          content: [
            MessageContent(
              type: "text",
              text: MessageText(value: "Loading...", annotations: []),
            ),
          ],
        ));
        _isWaitingForResponse = true;
      });
      _controller.clear();

      await context.read<BotProvider>().askBot(botId!, userMessage);

      String botMessage = "";
      if (mounted) {
        botMessage = context.read<BotProvider>().currentMessageResponse ?? "";
      }

      setState(() {
        _messages[_messages.length - 1] = MessageData(
            role: "assistant",
            createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            content: [
              MessageContent(
                  type: "text",
                  text: MessageText(value: botMessage, annotations: []))
            ]);
      });

      // Scroll to the bottom with a slight offset
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent +
            100, // Adjust the offset as needed
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      _isWaitingForResponse = false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handleRetrieveMessage() async {
    setState(() {
      _isLoading = true;
    });
    final selectedBot = context.read<BotProvider>().selectedBot;
    await context
        .read<BotProvider>()
        .retrieveMessageOfThread(selectedBot!.openAiThreadIdPlay);
    if (mounted) {
      setState(() {
        _messages = context.read<BotProvider>().messages!;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleNewThreadPlayground() async {
    setState(() {
      _isLoading = true;
    });
    final selectedBot = context.read<BotProvider>().selectedBot;
    await context
        .read<BotProvider>()
        .updateAssistantWithNewThreadPlayground(selectedBot!.id);
    _messages.clear();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _chatFocusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure keep-alive functionality
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Column(
        children: <Widget>[
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _messages.isEmpty
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
                          final messageData = _messages[index];
                          return Column(
                            children: List.generate(messageData.content.length,
                                (contentIndex) {
                              final content = messageData.content[contentIndex];
                              return ChatMessage(
                                name:
                                    messageData.role == "user" ? "User" : "Bot",
                                message: content.text.value,
                                isBot: messageData.role == "assistant",
                              );
                            }),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.sms),
                  onPressed: _isLoading ? null : _handleNewThreadPlayground,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _chatFocusNode,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isWaitingForResponse ? null : _handleSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
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
                      color: isBot ? Colors.grey[300] : Colors.blue[200],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: message == "Loading..."
                        ? const Center(child: CircularProgressIndicator())
                        : Text(message),
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
