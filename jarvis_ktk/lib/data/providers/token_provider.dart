import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/token_usage.dart';
import 'package:jarvis_ktk/data/network/token_api.dart';
import 'package:jarvis_ktk/services/cache_service.dart';

class TokenProvider with ChangeNotifier {
  final TokenApi _tokenApi;
  TokenUsage? _tokenUsage;
  int _currentToken = 0;

  TokenProvider(this._tokenApi);

  TokenUsage? get tokenUsage => _tokenUsage;
  int get currentToken => _currentToken;

  Future<void> loadTokenUsage({bool forceReload = false}) async {
    _tokenUsage = await CacheService.getCachedTokenUsage(_tokenApi);
    _currentToken = _tokenUsage!.availableTokens;
    notifyListeners();
  }

  void setCurrentToken(int token) {
    _currentToken = token;
    notifyListeners();
  }

  void clearAll() {
    _tokenUsage = null;
    _currentToken = 0;
    notifyListeners();
  }
}
