import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/models/user.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/data/providers/token_provider.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:provider/provider.dart';

import '../../services/cache_service.dart';
import '../prompt_bottom_sheet/prompt_bottom_sheet.dart';
import 'widgets/message_bubble.dart';
import 'widgets/welcome.dart';

class ChatBody extends StatefulWidget {
  final String conversationId;

  const ChatBody({
    super.key,
    required this.conversationId,
  });

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late Future<List<Prompt>> _promptsFuture;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late TextEditingController _messageController;
  late FocusNode _messageFocusNode;
  bool _showPromptList = false;
  User? _user;
  //List<ChatHistory> _listChatHistory = [];

  bool _isLoadingBotResponse = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageFocusNode = FocusNode();
    _messageController.addListener(_handleSlashAction);

    _initialize();
  }

  @override
  void didUpdateWidget(ChatBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.conversationId != '') {
      _handleLoadConversationHistory(isRefresh: true);
    }
  }

  Future<void> _initialize() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        _user = User.fromJson(userMap);
      });
    }
    if (_user != null) {
      _promptsFuture = getIt<PromptApi>().getPrompts();
    }

    if (widget.conversationId != '') {
      _handleLoadConversationHistory();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _handleSlashAction() {
    if (_messageController.text.startsWith('/') && _user != null) {
      setState(() {
        _showPromptList = true;
      });
    } else {
      setState(() {
        _showPromptList = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isLoadingBotResponse = true;
    });

    final userMessage = _messageController.text;
    final chatProvider = context.read<ChatProvider>();

    chatProvider.chatHistory.add(ChatHistory(
      query: userMessage,
      answer: '',
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      files: [],
    ));

    _messageController.clear();
    _messageFocusNode.unfocus();
    context.read<ChatProvider>().setShowWelcomeMessage(false);

    // Gửi tin nhắn qua API và nhận phản hồi
    try {
      await context.read<ChatProvider>().sendMessage(userMessage, []);

      if (mounted) {
        final assistantResponse = context.read<ChatProvider>().currentResponse!;

        var remainingUsage = assistantResponse.remainingUsage;
        context.read<TokenProvider>().setCurrentToken(remainingUsage);
        var conversationId = assistantResponse.conversationId;
        chatProvider.selectConversationId(conversationId);

        // Cập nhật dữ liệu
        chatProvider.chatHistory[chatProvider.chatHistory.length - 1] =
            ChatHistory(
          query: userMessage,
          answer: assistantResponse.message,
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          files: [],
        );

        CacheService.setCurrentHistoryLength(
            CacheService.getCurrentHistoryLength() + 1);

        showToast(chatProvider.selectedConversationId);
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
      showToast('Error sending message. Try again later.');
      chatProvider.chatHistory.removeAt(chatProvider.chatHistory.length - 1);
    } finally {
      setState(() {
        _isLoadingBotResponse = false;
      });
    }
  }

  Future<void> _handleLoadConversationHistory({bool isRefresh = false}) async {
    if (_user == null) return;
    if (context.read<ChatProvider>().selectedConversationId == '') return;
    setState(() {
      _isLoading = true;
    });
    await context.read<ChatProvider>().loadConversationHistory(
        context.read<ChatProvider>().selectedConversationId,
        AssistantId.GPT_4O_MINI,
        isRefresh: isRefresh);
    // if (mounted) {
    //   _listChatHistory = context.read<ChatProvider>().chatHistory;
    // }
    setState(() {
      _isLoading = false;
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : chatProvider.chatHistory.isEmpty
                        ? const WelcomeMessage()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: chatProvider.chatHistory.length * 2,
                            itemBuilder: (context, index) {
                              final isUser = index % 2 ==
                                  0; // query là của user, answer là của bot
                              final messageIndex = index ~/ 2;
                              final message =
                                  chatProvider.chatHistory[messageIndex];
                              final text =
                                  isUser ? message.query : message.answer;
                              final timestamp =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      message.createdAt * 1000);
                              return MessageBubble(
                                text: text,
                                isUser: isUser,
                                timestamp: timestamp,
                                avatar: isUser
                                    ? 'assets/user_avatar.png' // Đường dẫn avatar của user
                                    : chatProvider.selectedAiAgent['avatar'] ??
                                        'assets/chatbot.png', // Đường dẫn avatar của bot,
                                isLoading: !isUser &&
                                    _isLoadingBotResponse &&
                                    messageIndex ==
                                        chatProvider.chatHistory.length - 1,
                              );
                            },
                          ),
              ),
              if (_showPromptList)
                FutureBuilder<List<Prompt>>(
                  future: _promptsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No prompts available'));
                    } else {
                      final prompts = snapshot.data!;
                      final filteredPrompts = prompts.where((prompt) {
                        if (prompt is PublicPrompt) {
                          return prompt.isFavorite ||
                              prompt.userId == _user?.id;
                        }
                        return true;
                      }).toList();
                      final myPrompts =
                          filteredPrompts.whereType<MyPrompt>().toList();
                      final publicPrompts =
                          filteredPrompts.whereType<PublicPrompt>().toList();
                      return SizedBox(
                        height: 200,
                        child: ListView(
                          children: [
                            if (myPrompts.isNotEmpty) ...[
                              const ListTile(
                                title: Text('My Prompts',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              ...myPrompts.map((prompt) => ListTile(
                                    title: Text(prompt.title),
                                    onTap: () {
                                      _messageController.text = prompt.content;
                                      setState(() {
                                        _showPromptList = false;
                                      });
                                    },
                                  )),
                            ],
                            if (publicPrompts.isNotEmpty) ...[
                              const ListTile(
                                title: Text('Public Prompts',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              ...publicPrompts.map((prompt) => ListTile(
                                    title: Text(prompt.title),
                                    onTap: () {
                                      _messageController.text = prompt.content;
                                      setState(() {
                                        _showPromptList = false;
                                      });
                                    },
                                  )),
                            ],
                          ],
                        ),
                      );
                    }
                  },
                ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: SafeArea(
                  child: Row(
                    children: [
                      DropdownSearch<(IconData, String)>(
                        mode: Mode.custom,
                        items: (f, cs) => [
                          (Icons.image, 'Upload image'),
                          (Icons.photo_camera, 'Take a photo'),
                          (Icons.electric_bolt, 'Prompt'),
                        ],
                        compareFn: (item1, item2) => item1.$1 == item2.$1,
                        popupProps: PopupProps.modalBottomSheet(
                          fit: FlexFit.loose,
                          itemBuilder:
                              (context, item, isDisabled, isSelected) =>
                                  Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              leading: Icon(item.$1, color: Colors.black),
                              title: Text(
                                item.$2,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        dropdownBuilder: (ctx, selectedItem) => const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.black,
                        ),
                        onChanged: (selectedItem) {
                          if (selectedItem != null &&
                              selectedItem.$2 == 'Prompt') {
                            showPromptBottomSheet(context, onClick: (prompt) {
                              _messageController.text = prompt.content;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Center(
                          // Fixed height for the text box
                          child: TextField(
                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            maxLines: 4,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical
                                .center, // Center vertical alignment
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
