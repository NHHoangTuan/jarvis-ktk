import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/message.dart';
import 'package:jarvis_ktk/data/models/thread.dart';

import '../models/bot.dart';
import '../network/bot_api.dart';

class BotProvider with ChangeNotifier {
  final BotApi _botApi;
  List<Bot> _bots = [];
  List<Thread> _threads = [];
  List<Map<String, dynamic>> _importedKnowledges = [];
  Bot? _selectedBot;
  String? _currentMessageResponse;
  List<MessageData>? _messages = [];
  String _newThreadId = '';

  BotProvider(this._botApi);

  List<Bot> get bots => _bots;
  List<Thread> get threads => _threads;
  List<Map<String, dynamic>> get importedKnowledges => _importedKnowledges;
  Bot? get selectedBot => _selectedBot;
  String? get currentMessageResponse => _currentMessageResponse;
  List<MessageData>? get messages => _messages;
  String get newThreadId => _newThreadId;

  Future<void> loadBots() async {
    _bots = await _botApi.getBotList(
        order: 'DESC', orderField: 'createdAt', limit: 20);
    notifyListeners();
  }

  Future<void> loadThreads() async {
    if (_selectedBot == null) return;
    _threads = await _botApi.getThreads(_selectedBot!.id,
        order: 'DESC', orderField: 'updatedAt', limit: 30);
    notifyListeners();
  }

  Future<void> createBot(String botName, String botDescription) async {
    final newBot = await _botApi.createBot(botName, botDescription);
    _bots.add(newBot);
    // Sắp xếp lại danh sách bot theo thời gian tạo mới nhất
    _bots.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // Chọn bot mới tạo
    _selectedBot = newBot;
    notifyListeners();
  }

  Future<void> createThread(String botId, String? firstMessage) async {
    final newThread = await _botApi.createThread(botId, firstMessage);
    _newThreadId = newThread.openAiThreadId;
    notifyListeners();
  }

  Future<void> updateBot(String botId, dynamic data) async {
    final updatedBot = await _botApi.updateBot(botId, data);
    final index = _bots.indexWhere((bot) => bot.id == botId);
    _bots[index] = updatedBot;
    _selectedBot = updatedBot;
    notifyListeners();
  }

  Future<void> favoriteBot(String botId) async {
    final updatedBot = await _botApi.favoriteBot(botId);
    final index = _bots.indexWhere((bot) => bot.id == botId);
    _bots[index] = updatedBot;
    _selectedBot = updatedBot;
    notifyListeners();
  }

  Future<void> deleteBot(String botId) async {
    await _botApi.deleteBot(botId);
    _bots.removeWhere((bot) => bot.id == botId);
    notifyListeners();
  }

  Future<void> importKnowledgeToBot(String botId, String knowledgeId) async {
    await _botApi.importKnowledgeToAssistant(botId, knowledgeId);
    loadImportedKnowledges(botId);
    notifyListeners();
  }

  Future<void> loadImportedKnowledges(String botId) async {
    _importedKnowledges = await _botApi.getImportedKnowledges(botId);
    notifyListeners();
  }

  Future<void> deleteImportedKnowledge(String botId, String knowledgeId) async {
    await _botApi.deleteImportedKnowledge(botId, knowledgeId);
    _importedKnowledges
        .removeWhere((knowledge) => knowledge['id'] == knowledgeId);
    notifyListeners();
  }

  Future<void> askBot(
      String botId, String openAiThreadId, String message) async {
    _currentMessageResponse = await _botApi.askAssistant(
        botId, message, openAiThreadId, _selectedBot!.instructions);
    notifyListeners();
  }

  Future<void> retrieveMessageOfThread(String openAiThreadId) async {
    _messages = await _botApi.retrieveMessageOfThread(openAiThreadId);
    notifyListeners();
  }

  Future<void> updateAssistantWithNewThreadPlayground(String botId) async {
    final updatedBot =
        await _botApi.updateAssistantWithNewThreadPlayground(botId);
    final index = _bots.indexWhere((bot) => bot.id == botId);
    _bots[index] = updatedBot;
    _selectedBot = updatedBot;
    notifyListeners();
  }

  void selectBot(Bot bot) {
    _selectedBot = bot;
    notifyListeners();
  }

  void clearAll() {
    _bots = [];
    _importedKnowledges = [];
    _selectedBot = null;
    _currentMessageResponse = null;
    _messages = [];
    notifyListeners();
  }
}
