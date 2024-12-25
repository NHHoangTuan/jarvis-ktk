import 'package:jarvis_ktk/data/models/bot.dart';
import 'package:jarvis_ktk/data/network/knowledge_api_service.dart';

import '../../constants/api_endpoints.dart';

class BotApi {
  final KnowledgeApiService _knowledgeApiService;

  BotApi(this._knowledgeApiService);

  Future<List<Bot>> getBotList({
    String? query,
    String? order,
    String? orderField,
    int? offset,
    int? limit,
    bool? isFavorite,
    bool? isPublished,
  }) async {
    final params = {
      if (query != null) 'query': query,
      if (order != null) 'order': order,
      if (orderField != null) 'orderField': orderField,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
      if (isFavorite != null) 'isFavorite': isFavorite,
      if (isPublished != null) 'isPublished': isPublished,
    };

    final response = await _knowledgeApiService.get(ApiEndpoints.getAssistants,
        params: params);

    List<Bot> botList = [];

    if (response.statusCode == 200) {
      for (var bot in response.data['data']) {
        botList.add(Bot.fromJson(bot));
      }
    }

    return botList;
  }

  Future<Bot> createBot(String botName, String botDescription) async {
    final response = await _knowledgeApiService.post(
      ApiEndpoints.createAssistant,
      data: {'assistantName': botName, 'description': botDescription},
    );

    if (response.statusCode == 201) {
      return Bot.fromJson(response.data);
    }

    throw Exception('Failed to create knowledge');
  }
}
