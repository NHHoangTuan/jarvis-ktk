import 'package:flutter/material.dart';

class ChatModel extends ChangeNotifier {
  String _selectedAgent = '001';
  int _tokenCount = 1000;
  List<Map<String, dynamic>> _messages = [];
  bool _showWelcomeMessage = true;

  final List<Map<String, String>> _aiAgents = [
    {
      'id': '001',
      'name': 'GPT - 3.5',
      'avatar': 'assets/gpt-35.webp',
      'tokens': '10'
    },
    {
      'id': '002',
      'name': 'GPT - 4',
      'avatar': 'assets/gpt-4.webp',
      'tokens': '100'
    },
    {
      'id': '003',
      'name': 'Claude',
      'avatar': 'assets/claude.webp',
      'tokens': '30'
    },
    {
      'id': '004',
      'name': 'Gemini',
      'avatar': 'assets/gemini.png',
      'tokens': '20'
    },
  ];

  String get selectedAgent => _selectedAgent;
  int get tokenCount => _tokenCount;
  List<Map<String, dynamic>> get messages => _messages;
  bool get showWelcomeMessage => _showWelcomeMessage;
  List<Map<String, String>> get aiAgents => _aiAgents;

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

  void clearMessages() {
    _messages.clear();
    _showWelcomeMessage = true;
    notifyListeners();
  }

  void hideWelcomeMessage() {
    _showWelcomeMessage = false;
    notifyListeners();
  }
}
