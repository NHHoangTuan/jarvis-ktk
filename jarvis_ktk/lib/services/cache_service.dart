import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import '../data/network/api_service.dart';
import '../data/network/chat_api.dart';

class CacheService {
  static Map<String, List<Conversation>> _cache = {};
  static DateTime? _lastFetch;
  static const Duration _cacheValidity =
      Duration(minutes: 30); // Thời gian cache hiệu lực

  static int _historyLength = 0;
  static int _currentHistoryLength = 0;

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

  static void clearCache() {
    _cache.clear();
    _lastFetch = null;
  }
}
