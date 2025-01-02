import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/network/chat_api.dart';
import 'package:jarvis_ktk/services/cache_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatApi _chatApi;
  List<Conversation> _conversations = [];
  List<ChatHistory> _chatHistory = [];
  String _selectedConversationId = '';
  bool _isShowWelcomeMessage = true;
  bool _isTapHistory = false;
  final List<Map<String, String>> _aiAgents = [
    {
      'id': AssistantId.CLAUDE_3_HAIKU_20240307.name,
      'name': 'claude-3-haiku',
      'avatar': 'assets/claude-3-haiku.png',
      'tokens': '1'
    },
    {
      'id': AssistantId.CLAUDE_3_5_SONNET_20240620.name,
      'name': 'claude-3-5-sonnet',
      'avatar': 'assets/claude-3-5-sonnet.webp',
      'tokens': '3'
    },
    {
      'id': AssistantId.GEMINI_1_5_FLASH_LATEST.name,
      'name': 'gemini-1.5-flash',
      'avatar': 'assets/gemini.png',
      'tokens': '1'
    },
    {
      'id': AssistantId.GEMINI_1_5_PRO_LATEST.name,
      'name': 'gemini-1.5-pro',
      'avatar': 'assets/gemini.png',
      'tokens': '5'
    },
    {
      'id': AssistantId.GPT_4O.name,
      'name': 'gpt-4o',
      'avatar': 'assets/gpt-4o.webp',
      'tokens': '5'
    },
    {
      'id': AssistantId.GPT_4O_MINI.name,
      'name': 'gpt-4o-mini',
      'avatar': 'assets/gpt-4o-mini.webp',
      'tokens': '1'
    },
  ];
  //Conversation _selectedConversation =
  //Conversation(id: '', title: '', createdAt: -1);
  Map<String, String> _selectedAiAgent = {
    'id': AssistantId.CLAUDE_3_HAIKU_20240307.name,
    'name': 'claude-3-haiku',
    'avatar': 'assets/claude-3-haiku.png',
    'tokens': '1'
  };

  MessageResponse? _currentResponse;

  ChatProvider(this._chatApi);

  List<Conversation> get conversations => _conversations;
  List<ChatHistory> get chatHistory => _chatHistory;
  //Conversation get selectedConversation => _selectedConversation;
  List<Map<String, String>> get aiAgents => _aiAgents;
  Map<String, String> get selectedAiAgent => _selectedAiAgent;
  MessageResponse? get currentResponse => _currentResponse;
  String get selectedConversationId => _selectedConversationId;
  bool get isShowWelcomeMessage => _isShowWelcomeMessage;
  bool get isTapHistory => _isTapHistory;

  Future<void> loadConversations(AssistantId? assistantId) async {
    _conversations =
        await CacheService.getCachedConversations(assistantId, _chatApi);
    notifyListeners();
  }

  Future<void> loadConversationHistory(
      String conversationId, AssistantId? assistantId,
      {bool isRefresh = false}) async {
    // _chatHistory = await CacheService.getCachedChatHistory(
    //     conversationId, _chatApi,
    //     isRefresh: isRefresh);
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

  // void selectConversation(Conversation conversation) {
  //   _selectedConversation = conversation;
  //   notifyListeners();
  // }

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
      'name': 'claude-3-haiku',
      'avatar': 'assets/claude-3-haiku.png',
      'tokens': '1'
    };
    _currentResponse = null;
    notifyListeners();
  }
}
