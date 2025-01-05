import 'package:jarvis_ktk/data/network/api_service.dart';

import '../../constants/api_endpoints.dart';
import '../models/token_usage.dart';

class TokenApi {
  final ApiService _apiService;

  TokenApi(this._apiService);

  Future<TokenUsage> fetchTokenUsage() async {
    final response = await _apiService.get(ApiEndpoints.tokenUsage);
    if (response.statusCode != 200) {
      throw Exception('Failed to get token usage');
    }
    return TokenUsage.fromJson(response.data);
  }

  // Future<TokenUsage?> getTokenUsage() async {
  //   return await CacheService.getCachedTokenUsage(this);
  // }

  // Future<void> updateAvailableTokenUsage(int availableTokens) async {
  //   final storedTokenUsage = await getStoredTokenUsage();
  //   if (storedTokenUsage == null) {
  //     await fetchTokenUsage();
  //     return;
  //   }

  //   final updatedTokenUsage = storedTokenUsage.copyWith(
  //     availableTokens: availableTokens,
  //   );
  //   await saveTokenUsage(updatedTokenUsage);
  //   CacheService.updateTokenCache(updatedTokenUsage);
  // }
}
