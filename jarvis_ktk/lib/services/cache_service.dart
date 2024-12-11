import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/models/token_usage.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import '../data/network/api_service.dart';
import '../data/network/chat_api.dart';
import '../data/network/token_api.dart';

class CacheService {
  static Map<String, List<Conversation>> _cache = {};
  static Map<String, TokenUsage> _tokenCache = {};
  static DateTime? _lastFetch;
  static DateTime? _lastTokenFetch;
  static const Duration _cacheValidity =
      Duration(minutes: 30); // Thời gian cache hiệu lực

  static int _historyLength = 0;
  static int _currentHistoryLength = 0;

  // Add token usage cache methods
  static Future<TokenUsage?> getCachedTokenUsage(TokenApi tokenApi) async {
    final apiService = getIt<ApiService>();
    final user = await apiService.getStoredUser();
    if (user == null) return null;

    // Check if cache exists and is valid
    if (_tokenCache.containsKey('tokenUsage') && _lastTokenFetch != null) {
      final difference = DateTime.now().difference(_lastTokenFetch!);
      if (difference < _cacheValidity) {
        return _tokenCache['tokenUsage'];
      }
    }

    // If cache doesn't exist or expired, fetch from API
    final tokenUsage = await tokenApi.fetchTokenUsage();
    if (tokenUsage != null) {
      _tokenCache['tokenUsage'] = tokenUsage;
      _lastTokenFetch = DateTime.now();
    }
    return tokenUsage;
  }

  static void updateTokenCache(TokenUsage tokenUsage) {
    _tokenCache['tokenUsage'] = tokenUsage;
    _lastTokenFetch = DateTime.now();
  }

  static void updateAvailableTokenUsage(int currentToken) {
    if (_tokenCache['tokenUsage'] == null) {
      return;
    }

    final updatedTokenUsage = _tokenCache['tokenUsage']!.copyWith(
      availableTokens: currentToken,
    );
    updateTokenCache(updatedTokenUsage);
  }

  static void clearTokenCache() {
    _tokenCache.remove('tokenUsage');
    _lastTokenFetch = null;
  }

  static Future<List<Conversation>?> getCachedConversations(
      ChatApi chatApi) async {
    // Nếu không tồn tại user thì trả về rỗng, dùng hàm getStoredUser() từ ApiService
    final apiService = getIt<ApiService>();
    final user = await apiService.getStoredUser();
    if (user == null) return null;

    // Kiểm tra xem cache có tồn tại và còn hiệu lực không
    if (_cache.containsKey('conversations') &&
        _lastFetch != null &&
        _currentHistoryLength == _historyLength) {
      final difference = DateTime.now().difference(_lastFetch!);
      if (difference < _cacheValidity) {
        return _cache['conversations']!;
      }
    }

    // Nếu cache không tồn tại hoặc hết hạn, gọi API mới
    final conversations = await chatApi.fetchConversations(
        AssistantId.GPT_4O_MINI, AssistantModel.DIFY);
    _cache['conversations'] = conversations;
    _lastFetch = DateTime.now();
    _historyLength = conversations.length;
    _currentHistoryLength = _historyLength;
    return conversations;
  }

  // lấy currentHistoryLength
  static int getCurrentHistoryLength() {
    return _currentHistoryLength;
  }

  static void setCurrentHistoryLength(int length) {
    _currentHistoryLength = length;
  }

  static void clearAllCache() {
    _cache.clear();
    _tokenCache.clear();
    _lastFetch = null;
    _lastTokenFetch = null;
  }
}
