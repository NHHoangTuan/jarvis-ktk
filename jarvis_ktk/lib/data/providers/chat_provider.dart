import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/network/chat_api.dart';
import 'package:jarvis_ktk/services/cache_service.dart';

import '../models/bot.dart';

class ChatProvider with ChangeNotifier {
  final ChatApi _chatApi;
  List<Conversation> _conversations = [];
  List<ChatHistory> _chatHistory = [];
  String _selectedConversationId = '';
  bool _isShowWelcomeMessage = true;
  bool _isTapHistory = false;
  bool _isBOT = false;
  final List<Map<String, String>> _aiAgents = [
    {
      'id': AssistantId.CLAUDE_3_HAIKU_20240307.name,
      'name': 'Claude 3 Haiku',
      'avatar': 'assets/claude-3-haiku.png',
      'tokens': '1'
    },
    {
      'id': AssistantId.CLAUDE_3_5_SONNET_20240620.name,
      'name': 'Claude 3.5 Sonnet',
      'avatar': 'assets/claude-3-5-sonnet.webp',
      'tokens': '3'
    },
    {
      'id': AssistantId.GEMINI_1_5_FLASH_LATEST.name,
      'name': 'Gemini 1.5 Flash',
      'avatar': 'assets/gemini.png',
      'tokens': '1'
    },
    {
      'id': AssistantId.GEMINI_1_5_PRO_LATEST.name,
      'name': 'Gemini 1.5 Pro',
      'avatar': 'assets/gemini.png',
      'tokens': '5'
    },
    {
      'id': AssistantId.GPT_4O.name,
      'name': 'GPT 4o',
      'avatar': 'assets/gpt-4o.webp',
      'tokens': '5'
    },
    {
      'id': AssistantId.GPT_4O_MINI.name,
      'name': 'GPT 4o Mini',
      'avatar': 'assets/gpt-4o-mini.webp',
      'tokens': '1'
    },
  ];
  Map<String, String> _selectedAiAgent = {
    'id': AssistantId.CLAUDE_3_HAIKU_20240307.name,
    'name': 'Claude 3 Haiku',
    'avatar': 'assets/claude-3-haiku.png',
    'tokens': '1'
  };

  MessageResponse? _currentResponse;

  ChatProvider(this._chatApi);

  List<Conversation> get conversations => _conversations;
  List<ChatHistory> get chatHistory => _chatHistory;
  List<Map<String, String>> get aiAgents => _aiAgents;
  Map<String, String> get selectedAiAgent => _selectedAiAgent;
  MessageResponse? get currentResponse => _currentResponse;
  String get selectedConversationId => _selectedConversationId;
  bool get isShowWelcomeMessage => _isShowWelcomeMessage;
  bool get isTapHistory => _isTapHistory;
  bool get isBOT => _isBOT;

  Future<void> loadConversations(AssistantId? assistantId) async {
    _conversations =
        await CacheService.getCachedConversations(assistantId, _chatApi);
    notifyListeners();
  }

  Future<void> loadConversationHistory(
      String conversationId, AssistantId? assistantId,
      {bool isRefresh = false}) async {
    _chatHistory = await _chatApi.getConversationHistory(conversationId,
        assistantId: assistantId, assistantModel: AssistantModel.DIFY);
    notifyListeners();
  }

  Future<void> sendMessage(String content, List<String>? files) async {
    final Map<String, dynamic> assistant = {
      'id': _selectedAiAgent['id'],
      'model': AssistantModel.DIFY.name,
    };
    final List<Map<String, dynamic>> messages = [];
    for (final history in _chatHistory) {
      // Thêm query của user
      messages.add({
        'assistant': assistant,
        'role': 'user',
        'content': history.query, // Nội dung câu hỏi từ người dùng
        'files': [], // Giả định không có file đính kèm với query
      });

      // Thêm answer của assistant
      messages.add({
        'assistant': assistant,
        'role': 'assistant',
        'content': history.answer, // Nội dung trả lời từ AI assistant
        'files': history.files, // Các file đính kèm trong lịch sử
      });
    }

    final Map<String, dynamic> metadata = {
      'conversation': {
        'messages': [],
        'id': _selectedConversationId,
      },
    };
    _currentResponse =
        await _chatApi.sendMessage(assistant, content, files, metadata);
  }

  void addBotToAiAgents(Bot bot) {
    _aiAgents.add({
      'id': bot.id,
      'name': bot.assistantName,
      'avatar': 'assets/chatbot.png',
      'tokens': '0'
    });
    notifyListeners();
  }

  void deleteBotFromAiAgents(String botId) {
    _aiAgents.removeWhere((element) => element['id'] == botId);
    notifyListeners();
  }

  void selectAiAgentId(String aiAgentId) {
    _selectedAiAgent['id'] = aiAgentId;
    notifyListeners();
  }

  void selectAiAgent(Map<String, String> aiAgent) {
    _selectedAiAgent = aiAgent;
  }

  void selectConversationId(String conversationId) {
    _selectedConversationId = conversationId;
    notifyListeners();
  }

  void setShowWelcomeMessage(bool isShow) {
    _isShowWelcomeMessage = isShow;
    notifyListeners();
  }

  void setTapHistory(bool isTap) {
    _isTapHistory = isTap;
    notifyListeners();
  }

  void setBOT(bool isBOT) {
    _isBOT = isBOT;
    notifyListeners();
  }

  void setChatHistory(List<ChatHistory> chatHistory) {
    _chatHistory = chatHistory;
    notifyListeners();
  }

  void setConversations(List<Conversation> conversations) {
    _conversations = conversations;
    notifyListeners();
  }

  void clearChatHistory() {
    _chatHistory = [];
    notifyListeners();
  }

  void clearConversations() {
    _conversations = [];
    notifyListeners();
  }

  void addAiAgent(Map<String, String> aiAgent) {
    _aiAgents.add(aiAgent);
    notifyListeners();
  }

  void clearAll() {
    _conversations = [];
    _chatHistory = [];
    _selectedConversationId = '';
    _isShowWelcomeMessage = true;
    _isTapHistory = false;
    _selectedAiAgent = {
      'id': AssistantId.CLAUDE_3_HAIKU_20240307.name,
      'name': 'Claude 3 Haiku',
      'avatar': 'assets/claude-3-haiku.png',
      'tokens': '1'
    };
    _currentResponse = null;
    _isBOT = false;
    notifyListeners();
  }
}
