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

    throw Exception('Failed to create BOT');
  }

  Future<Bot> updateBot(String botId, dynamic data) async {
    final response = await _knowledgeApiService.patch(
      ApiEndpoints.updateAssistant,
      pathVars: {'assistantId': botId},
      data: data,
    );

    if (response.statusCode == 200) {
      return Bot.fromJson(response.data);
    }

    throw Exception('Failed to update BOT');
  }

  Future<void> deleteBot(String botId) async {
    final response = await _knowledgeApiService.delete(
      ApiEndpoints.deleteAssistant,
      pathVars: {'assistantId': botId},
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception('Failed to delete BOT');
  }

  Future<void> importKnowledgeToAssistant(
      String assistantId, String knowledgeId) async {
    final response = await _knowledgeApiService.post(
      ApiEndpoints.importKnowledgeToAssistant,
      pathVars: {'assistantId': assistantId, 'knowledgeId': knowledgeId},
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception('Failed to import knowledge to assistant');
  }

  Future<List<Map<String, String>>> getImportedKnowledges(
    String assistantId, {
    String? query,
    String? order,
    String? orderField,
    int? offset,
    int? limit,
  }) async {
    final params = {
      if (query != null) 'query': query,
      if (order != null) 'order': order,
      if (orderField != null) 'orderField': orderField,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };

    final response = await _knowledgeApiService.get(
      ApiEndpoints.getImportedKnowledge,
      params: params,
      pathVars: {'assistantId': assistantId},
    );

    if (response.statusCode == 200) {
      // Chuyển đổi dữ liệu response thành List<Map<String, String>>
      final List<Map<String, String>> knowledgeList =
          (response.data['data'] as List<dynamic>)
              .map((item) => {
                    'id': item['id'] as String,
                    'knowledgeName': item['knowledgeName'] as String,
                  })
              .toList();
      return knowledgeList;
    }

    throw Exception('Failed to get imported knowledge');
  }

  Future<void> deleteImportedKnowledge(
      String assistantId, String knowledgeId) async {
    final response = await _knowledgeApiService.delete(
      ApiEndpoints.deleteImportKnowledge,
      pathVars: {'assistantId': assistantId, 'knowledgeId': knowledgeId},
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception('Failed to remove imported knowledge');
  }

  // Future<Bot> updatePromptBot(
  //     String botId, String botName, String instructions) async {
  //   final response = await _knowledgeApiService.patch(
  //     ApiEndpoints.updateAssistant,
  //     pathVars: {'assistantId': botId},
  //     data: {'assistantName': botName, 'instructions': instructions},
  //   );

  //   if (response.statusCode == 200) {
  //     return Bot.fromJson(response.data);
  //   }

  //   throw Exception('Failed to update prompt BOT');
  // }
}
