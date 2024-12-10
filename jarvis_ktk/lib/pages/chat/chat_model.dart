import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/chat.dart';

class ChatModel extends ChangeNotifier {
  String _selectedAgent = AssistantId.GPT_4O_MINI.name;
  int _tokenCount = 1000;
  final List<Map<String, dynamic>> _messages = [];
  bool _showWelcomeMessage = true;
  String _conversationId = '';

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

  String get selectedAgent => _selectedAgent;
  int get tokenCount => _tokenCount;
  List<Map<String, dynamic>> get messages => _messages;
  bool get showWelcomeMessage => _showWelcomeMessage;
  List<Map<String, String>> get aiAgents => _aiAgents;
  String get conversationId => _conversationId;

  void setSelectedAgent(String agent) {
    _selectedAgent = agent;
    notifyListeners();
  }

  void setTokenCount(int count) {
    _tokenCount = count;
    notifyListeners();
  }

  void addMessage(Map<String, dynamic> message) {
    _messages.add(message);
    notifyListeners();
  }

  void updateMessage(int index, Map<String, dynamic> message) {
    _messages[index] = message;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    _showWelcomeMessage = true;
    _conversationId = '';
    notifyListeners();
  }

  void hideWelcomeMessage() {
    _showWelcomeMessage = false;
    notifyListeners();
  }

  void setConversationId(String conversationId) {
    _conversationId = conversationId;
    notifyListeners();
  }

  void resetConversationId() {
    _conversationId = '';
    notifyListeners();
  }
}
