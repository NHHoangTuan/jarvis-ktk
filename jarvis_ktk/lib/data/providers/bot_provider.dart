import 'package:flutter/material.dart';

import '../models/bot.dart';
import '../network/bot_api.dart';

class BotProvider with ChangeNotifier {
  final BotApi _botApi;
  List<Bot> _bots = [];
  List<Map<String, dynamic>> _importedKnowledges = [];
  Bot? _selectedBot;

  BotProvider(this._botApi);

  List<Bot> get bots => _bots;
  List<Map<String, dynamic>> get importedKnowledges => _importedKnowledges;
  Bot? get selectedBot => _selectedBot;

  Future<void> loadBots() async {
    _bots = await _botApi.getBotList(
        order: 'DESC', orderField: 'createdAt', limit: 20);
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

  Future<void> updateBot(String botId, dynamic data) async {
    final updatedBot = await _botApi.updateBot(botId, data);
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

  void selectBot(Bot bot) {
    _selectedBot = bot;
    notifyListeners();
  }
}
