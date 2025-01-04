import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/models/user.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/data/providers/token_provider.dart';
import 'package:jarvis_ktk/pages/chat/widgets/message_input.dart';
import 'package:jarvis_ktk/pages/chat/widgets/prompt_widget.dart';
import 'package:jarvis_ktk/pages/chat/widgets/welcome_bot.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../data/models/message.dart';
import '../../data/providers/bot_provider.dart';
import '../../services/cache_service.dart';
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
    if (_messageController.text.startsWith('/') &&
        _messageController.text.trim().length == 1 &&
        _user != null) {
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
    final botProvider = context.read<BotProvider>();

    chatProvider.chatHistory.add(ChatHistory(
      query: userMessage,
      answer: '',
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      files: [],
    ));

    _messageController.clear();
    _messageFocusNode.unfocus();
    chatProvider.setShowWelcomeMessage(false);

    // Gửi tin nhắn qua API và nhận phản hồi
    try {
      if (chatProvider.isBOT) {
        if (chatProvider.selectedConversationId == '') {
          await botProvider.createThread(
              botProvider.selectedBot!.id, userMessage);

          // Set selected conversation ID to the last thread ID
          chatProvider.selectConversationId(botProvider.newThreadId);
        }
        await botProvider.askBot(botProvider.selectedBot!.id,
            chatProvider.selectedConversationId, userMessage);
      } else {
        await chatProvider.sendMessage(userMessage, []);
      }

      if (mounted) {
        String answer = '';
        if (!chatProvider.isBOT) {
          final assistantResponse = chatProvider.currentResponse!;

          var remainingUsage = assistantResponse.remainingUsage;
          context.read<TokenProvider>().setCurrentToken(remainingUsage);
          var conversationId = assistantResponse.conversationId;
          chatProvider.selectConversationId(conversationId);

          answer = assistantResponse.message;
        } else {
          answer = botProvider.currentMessageResponse!;
        }

        // Cập nhật dữ liệu
        chatProvider.chatHistory[chatProvider.chatHistory.length - 1] =
            ChatHistory(
          query: userMessage,
          answer: answer,
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          files: [],
        );

        CacheService.setCurrentHistoryLength(
            CacheService.getCurrentHistoryLength() + 1);
        await botProvider.loadThreads();
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
    final chatProvider = context.read<ChatProvider>();
    final botProvider = context.read<BotProvider>();

    if (chatProvider.isBOT) {
      await botProvider
          .retrieveMessageOfThread(chatProvider.selectedConversationId);
      final chatHistory = convertMessageDataToChatHistory(botProvider.messages);
      chatProvider.setChatHistory(chatHistory);
    } else {
      await chatProvider.loadConversationHistory(
          chatProvider.selectedConversationId, AssistantId.GPT_4O_MINI,
          isRefresh: isRefresh);
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<ChatHistory> convertMessageDataToChatHistory(
      List<MessageData>? messageDataList) {
    List<ChatHistory> chatHistoryList = [];

    if (messageDataList == null) return chatHistoryList;

    String? query;
    String? answer;
    int? createdAt;
    List<String> files = [];

    for (var message in messageDataList) {
      if (message.role == 'user') {
        query = message.content
            .map((content) => content.text.value)
            .join(' '); // Gộp nội dung query nếu cần
        createdAt = message.createdAt;
      } else if (message.role == 'assistant') {
        answer = message.content
            .map((content) => content.text.value)
            .join(' '); // Gộp nội dung answer nếu cần
        // Lấy các files nếu có
        files = message.content
            .where((content) => content.type == 'file')
            .map((content) => content.text.value)
            .toList();
      }

      // Khi có đủ cả query và answer thì thêm vào danh sách ChatHistory
      if (query != null && answer != null) {
        chatHistoryList.add(ChatHistory(
          query: query,
          answer: answer,
          createdAt: createdAt ?? 0,
          files: files,
        ));
        // Reset query và answer để xử lý message tiếp theo
        query = null;
        answer = null;
        files = [];
      }
    }

    return chatHistoryList;
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
                    ? Center(
                        child: LoadingAnimationWidget.inkDrop(
                        color: Colors.blueGrey,
                        size: 20,
                      ))
                    : chatProvider.chatHistory.isEmpty
                        ? (chatProvider.isBOT
                            ? const WelcomeBot()
                            : const WelcomeMessage())
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
                                    : chatProvider.isBOT
                                        ? 'assets/chatbot.png'
                                        : chatProvider
                                                .selectedAiAgent['avatar'] ??
                                            'assets/chatbot.png',
                                // Đường dẫn avatar của bot,
                                isLoading: !isUser &&
                                    _isLoadingBotResponse &&
                                    messageIndex ==
                                        chatProvider.chatHistory.length - 1,
                              );
                            },
                          ),
              ),
              if (_showPromptList)
                Container(
                  color: Colors.grey.shade200, // Change background color here
                  height: 200,
                  child: PromptWidget(
                      messageController: _messageController,
                      onClosePromptList: () {
                        setState(() {
                          _showPromptList = false;
                        });
                      },
                      user: _user),
                ),
              MessageInput(
                  messageController: _messageController,
                  messageFocusNode: _messageFocusNode,
                  onSendMessage: _sendMessage)
            ],
          ),
        ],
      ),
    );
  }
}
