import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/message.dart';
import 'package:jarvis_ktk/data/models/thread.dart';

import '../models/bot.dart';
import '../network/bot_api.dart';

class BotProvider with ChangeNotifier {
  final BotApi _botApi;
  List<Bot> _bots = [];
  List<Bot> _filterBots = [];
  List<Thread> _threads = [];
  List<Map<String, dynamic>> _importedKnowledges = [];
  Bot? _selectedBot;
  String? _currentMessageResponse;
  List<MessageData>? _messages = [];
  String _newThreadId = '';
  String _filterValue = 'All';
  String _searchValue = '';

  BotProvider(this._botApi);

  List<Bot> get bots => _bots;
  List<Bot> get filterBots => _filterBots;
  List<Thread> get threads => _threads;
  List<Map<String, dynamic>> get importedKnowledges => _importedKnowledges;
  Bot? get selectedBot => _selectedBot;
  String? get currentMessageResponse => _currentMessageResponse;
  List<MessageData>? get messages => _messages;
  String get newThreadId => _newThreadId;
  String get filterValue => _filterValue;
  String get searchValue => _searchValue;

  Future<void> loadBots() async {
    _bots = await _botApi.getBotList(
        order: 'DESC', orderField: 'createdAt', limit: 20);
    _filterBots = _bots.toList();
    notifyListeners();
  }

  Future<void> loadThreads(String assistantId) async {
    _threads = await _botApi.getThreads(assistantId,
        order: 'DESC', orderField: 'updatedAt', limit: 30);
    notifyListeners();
  }

  Future<void> createBot(String botName, String botDescription) async {
    final newBot = await _botApi.createBot(botName, botDescription);
    _bots.add(newBot);
    // Sắp xếp lại danh sách bot theo thời gian tạo mới nhất
    _bots.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _filterBots = _bots.toList();
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
    _filterBots = _bots.toList();
    notifyListeners();
  }

  Future<void> favoriteBot(String botId) async {
    final updatedBot = await _botApi.favoriteBot(botId);
    final index = _bots.indexWhere((bot) => bot.id == botId);
    _bots[index] = updatedBot;
    _filterBots = _bots.toList();
    notifyListeners();
  }

  Future<void> deleteBot(String botId) async {
    await _botApi.deleteBot(botId);
    _bots.removeWhere((bot) => bot.id == botId);
    _filterBots = _bots.toList();
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
    final instructions = _selectedBot?.instructions ?? '';
    _currentMessageResponse = await _botApi.askAssistant(
        botId, message, openAiThreadId, instructions);
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

  void filterBot() {
    _filterBots = _bots.toList();

    _filterBots = _filterBots
        .where((filterBot) =>
            filterBot.assistantName
                .toLowerCase()
                .contains(_searchValue.toLowerCase()) ||
            (filterBot.description?.toLowerCase() ?? '')
                .contains(_searchValue.toLowerCase()))
        .toList();

    if (_filterValue == 'All') {
      _filterBots = _filterBots.toList();
    } else if (_filterValue == 'Published') {
      _filterBots = _filterBots.where((bot) => bot.isDefault).toList();
    } else if (_filterValue == 'My Favourite') {
      _filterBots = _filterBots.where((bot) => bot.isFavorite).toList();
    }
    notifyListeners();
  }

  // void searchBot(String value) {
  //   if (value.isEmpty) {
  //     _filterBots = _bots.toList();
  //     return;
  //   }

  //   _filterBots = _filterBots
  //       .where((filterBot) =>
  //           filterBot.assistantName
  //               .toLowerCase()
  //               .contains(value.toLowerCase()) ||
  //           (filterBot.description?.toLowerCase() ?? '')
  //               .contains(value.toLowerCase()))
  //       .toList();
  //   notifyListeners();
  // }

  void selectBot(Bot bot) {
    _selectedBot = bot;
    notifyListeners();
  }

  void setFilterValue(String value) {
    _filterValue = value;
    notifyListeners();
  }

  void setSearchValue(String value) {
    _searchValue = value;
    notifyListeners();
  }

  void clearAll() {
    _bots = [];
    _filterBots = [];
    _importedKnowledges = [];
    _selectedBot = null;
    _currentMessageResponse = null;
    _messages = [];
    notifyListeners();
  }
}
