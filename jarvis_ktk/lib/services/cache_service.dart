import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/models/token_usage.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import '../data/models/knowledge.dart';
import '../data/network/api_service.dart';
import '../data/network/chat_api.dart';
import '../data/network/knowledge_api.dart';
import '../data/network/token_api.dart';

class CacheService {
  static final Map<String, List<Conversation>> _conversationsCache = {};
  static final Map<String, TokenUsage> _tokenCache = {};
  static final Map<String, List<Knowledge>> _knowledgeCache = {};
  static final Map<String, List<ChatHistory>> _chatHistoryCache = {};
  static DateTime? _lastKnowledgeFetch;
  static DateTime? _lastFetch;
  static DateTime? _lastTokenFetch;
  static const Duration _cacheValidity =
      Duration(minutes: 30); // Thời gian cache hiệu lực
  static const Duration _knowledgesCacheValidity = Duration(minutes: 5);

  static int _historyLength = 0;
  static int _currentHistoryLength = 0;

  // Add token usage cache methods
  static Future<TokenUsage> getCachedTokenUsage(TokenApi tokenApi) async {
    final apiService = getIt<ApiService>();
    final user = await apiService.getStoredUser();
    if (user == null)
      return TokenUsage(availableTokens: 0, totalTokens: 0, unlimited: false);

    // Check if cache exists and is valid
    if (_tokenCache.containsKey('tokenUsage') && _lastTokenFetch != null) {
      final difference = DateTime.now().difference(_lastTokenFetch!);
      if (difference < _cacheValidity) {
        return _tokenCache['tokenUsage']!;
      }
    }

    // If cache doesn't exist or expired, fetch from API
    final tokenUsage = await tokenApi.fetchTokenUsage();
    _tokenCache['tokenUsage'] = tokenUsage;
    _lastTokenFetch = DateTime.now();
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

  static Future<List<Conversation>> getCachedConversations(
    AssistantId? assistantId,
    ChatApi chatApi,
  ) async {
    // Nếu không tồn tại user thì trả về rỗng, dùng hàm getStoredUser() từ ApiService
    final apiService = getIt<ApiService>();
    final user = await apiService.getStoredUser();
    if (user == null) return [];

    // Kiểm tra xem cache có tồn tại và còn hiệu lực không
    if (_conversationsCache.containsKey('conversations') &&
        _lastFetch != null &&
        _currentHistoryLength == _historyLength) {
      final difference = DateTime.now().difference(_lastFetch!);
      if (difference < _cacheValidity) {
        return _conversationsCache['conversations']!;
      }
    }

    // Nếu cache không tồn tại hoặc hết hạn, gọi API mới
    final conversations = await chatApi.getConversations(
        assistantId: AssistantId.GPT_4O_MINI,
        assistantModel: AssistantModel.DIFY);
    _conversationsCache['conversations'] = conversations;
    _lastFetch = DateTime.now();
    _historyLength = conversations.length;
    _currentHistoryLength = _historyLength;
    return conversations;
  }

  static Future<List<ChatHistory>> getCachedChatHistory(
      String conversationId, ChatApi chatApi,
      {bool isRefresh = false}) async {
    // Nếu không tồn tại user thì trả về rỗng, dùng hàm getStoredUser() từ ApiService
    final apiService = getIt<ApiService>();
    final user = await apiService.getStoredUser();
    if (user == null) return [];

    // Kiểm tra xem cache có tồn tại và còn hiệu lực không
    if (_chatHistoryCache.containsKey('chatHistory') &&
        _lastFetch != null &&
        _currentHistoryLength == _historyLength &&
        !isRefresh) {
      final difference = DateTime.now().difference(_lastFetch!);
      if (difference < _cacheValidity) {
        return _chatHistoryCache['chatHistory']!;
      }
    }

    // Nếu cache không tồn tại hoặc hết hạn, gọi API mới
    final chatHistory = await chatApi.getConversationHistory(conversationId,
        assistantId: AssistantId.GPT_4O_MINI,
        assistantModel: AssistantModel.DIFY);
    _chatHistoryCache['chatHistory'] = chatHistory;
    _lastFetch = DateTime.now();
    _historyLength = chatHistory.length;
    _currentHistoryLength = _historyLength;
    return chatHistory;
  }

  static void clearChatHistoryCache() {
    _chatHistoryCache.remove('chatHistory');
    _lastFetch = null;
  }

  // lấy currentHistoryLength
  static int getCurrentHistoryLength() {
    return _currentHistoryLength;
  }

  static void setCurrentHistoryLength(int length) {
    _currentHistoryLength = length;
  }

  static Future<List<Knowledge>> getCachedKnowledges(
      KnowledgeApi knowledgeApi) async {
    // Check cache
    if (_knowledgeCache.containsKey('knowledges') &&
        _lastKnowledgeFetch != null) {
      final difference = DateTime.now().difference(_lastKnowledgeFetch!);

      if (difference < _knowledgesCacheValidity) {
        return _knowledgeCache['knowledges']!;
      }
    }

    // Nếu cache không tồn tại hoặc hết hạn, gọi API
    final knowledges = await knowledgeApi.getKnowledgeList(
        order: 'DESC', orderField: 'createdAt', limit: 20);

    // Cập nhật cache
    _knowledgeCache['knowledges'] = knowledges;
    _lastKnowledgeFetch = DateTime.now();

    return knowledges;
  }

  static void invalidateKnowledgeCache() {
    _knowledgeCache.remove('knowledges');
    _lastKnowledgeFetch = null;
  }

  static void clearAllCache() {
    _conversationsCache.clear();
    _tokenCache.clear();
    _knowledgeCache.clear();
    _chatHistoryCache.clear();
    _lastFetch = null;
    _lastTokenFetch = null;
  }
}
