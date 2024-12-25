import 'package:flutter/material.dart';

import '../models/bot.dart';
import '../network/bot_api.dart';

class BotProvider with ChangeNotifier {
  final BotApi _botApi;
  List<Bot> _bots = [];
  Bot? _selectedBot;

  BotProvider(this._botApi);

  List<Bot> get bots => _bots;
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

  void selectBot(Bot bot) {
    _selectedBot = bot;
    notifyListeners();
  }
}
