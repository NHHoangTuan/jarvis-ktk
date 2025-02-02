import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/models/user.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/data/providers/token_provider.dart';
import 'package:jarvis_ktk/pages/chat/widgets/message_input.dart';
import 'package:jarvis_ktk/pages/chat/widgets/prompt_widget.dart';
import 'package:jarvis_ktk/utils/toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final ScrollController _scrollController = ScrollController();
  late FocusNode _messageFocusNode;
  bool _showPromptList = false;
  User? _user;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  static const String LAST_AD_TIME_KEY = 'last_ad_time';
  static const int MIN_MESSAGES_BEFORE_AD = 3;
  static const Duration MIN_TIME_BETWEEN_ADS = Duration(minutes: 3);
  int _messageCount = 0;

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
    _loadInterstitialAd();
    _checkFirstRun();
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
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastAdTime = prefs.getInt(LAST_AD_TIME_KEY);
    bool shouldShowAd = false;

    if (lastAdTime == null) {
      // First time app launch
      shouldShowAd = true;
    } else {
      final timeSinceLastAd = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(lastAdTime));
      shouldShowAd = timeSinceLastAd > MIN_TIME_BETWEEN_ADS;
    }

    if (shouldShowAd && _isInterstitialAdReady && mounted) {
      await Future.delayed(const Duration(seconds: 2));
      showInterstitialAd();
      await prefs.setInt(
          LAST_AD_TIME_KEY, DateTime.now().millisecondsSinceEpoch);
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-8437579288625202/6032691387',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _isInterstitialAdReady = false;
              ad.dispose();
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isInterstitialAdReady = false;
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
    }
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

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        debugPrint("ScrollController không hoạt động.");
      }
    });
  }

  Future<void> _sendMessage(String? message) async {
    if (_messageController.text.trim().isEmpty && message == null) return;
    if (_messageController.text.trim().isEmpty && message != null) {
      _messageController.text = message;
    }

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

    _scrollToBottom();

    _messageController.clear();
    _messageFocusNode.unfocus();
    chatProvider.setShowWelcomeMessage(false);

    // Gửi tin nhắn qua API và nhận phản hồi
    try {
      if (chatProvider.isBOT) {
        if (chatProvider.selectedConversationId == '') {
          await botProvider.createThread(
              chatProvider.selectedAiAgent['id']!, userMessage);

          // Set selected conversation ID to the last thread ID
          chatProvider.selectConversationId(botProvider.newThreadId);
        }
        await botProvider.askBot(chatProvider.selectedAiAgent['id']!,
            chatProvider.selectedConversationId, userMessage);

        await botProvider.loadThreads(chatProvider.selectedAiAgent['id']!);
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

        _scrollToBottom();

        CacheService.setCurrentHistoryLength(
            CacheService.getCurrentHistoryLength() + 1);

        _messageCount++;
        if (_messageCount >= MIN_MESSAGES_BEFORE_AD) {
          _checkFirstRun();
          _messageCount = 0;
        }
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
      ToastUtils.showToast('Error sending message. Try again later.');
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
    _scrollToBottom();
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
                        ? WelcomeMessage(sendMessage: _sendMessage)
                        : ListView.builder(
                            controller: _scrollController,
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
                  onSendMessage: () => _sendMessage(null))
            ],
          ),
        ],
      ),
    );
  }
}
