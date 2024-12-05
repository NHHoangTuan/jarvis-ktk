import 'package:dio/dio.dart';
import 'package:jarvis_ktk/constants/api_endpoints.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'api_service.dart';

class ChatApi {
  final ApiService _apiService;

  ChatApi(this._apiService);

  Future<Response> getConversationHistory(String conversationId,
      {String? assistantId, String assistantModel = 'dify'}) async {
    final params = {
      if (assistantId != null) 'assistantId': assistantId,
      'assistantModel': assistantModel,
    };

    final response = _apiService.get(ApiEndpoints.chatHistory,
        params: params, pathVars: {'conversationId': conversationId});

    return response;
  }

  Future<Response> getConversations(
      {String? assistantId, String assistantModel = 'dify'}) async {
    final params = {
      if (assistantId != null) 'assistantId': assistantId,
      'assistantModel': assistantModel,
    };

    final response =
        await _apiService.get(ApiEndpoints.chatConversation, params: params);

    return response;
  }

  Future<Response> sendMessage(Map<String, dynamic> message) async {
    final response = _apiService.post(ApiEndpoints.chatSend, data: message);

    return response;
  }

  List<ChatHistory> _messages = [];

  Future<List<ChatHistory>> loadConversationHistory(String conversationId,
      AssistantId assistantId, AssistantModel assistantModel) async {
    final response = await getConversationHistory(conversationId,
        assistantId: assistantId.name, assistantModel: assistantModel.name);
    if (response.statusCode != 200) {
      throw Exception('Failed to load conversation history');
    }
    final data = response.data['items'] as List;
    _messages = data.map((item) => ChatHistory.fromJson(item)).toList();
    return _messages;
  }

  Future<List<Conversation>> fetchConversations(
      AssistantId assistantId, AssistantModel assistantModel) async {
    final response = await getConversations(
        assistantId: assistantId.name, assistantModel: assistantModel.name);
    if (response.statusCode != 200) {
      throw Exception('Failed to load conversations');
    }
    final data = response.data['items'] as List;
    return data.map((item) => Conversation.fromJson(item)).toList();
  }
}
