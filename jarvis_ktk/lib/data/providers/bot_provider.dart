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
    _bots = await _botApi.getBotList();
    notifyListeners();
  }

  // Future<void> createBot(Bot bot) async {
  //   final newBot = await _botApi.createBot(bot);
  //   _bots.add(newBot);
  //   notifyListeners();
  // }

  void selectBot(Bot bot) {
    _selectedBot = bot;
    notifyListeners();
  }
}
