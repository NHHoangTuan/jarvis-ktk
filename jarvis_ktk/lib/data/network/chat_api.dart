import 'package:jarvis_ktk/constants/api_endpoints.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'api_service.dart';

class ChatApi {
  final ApiService _apiService;

  ChatApi(this._apiService);

  Future<List<ChatHistory>> getConversationHistory(String conversationId,
      {String? cursor,
      int? limit,
      AssistantId? assistantId,
      required AssistantModel assistantModel}) async {
    final params = {
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
      if (assistantId != null) 'assistantId': assistantId.name,
      'assistantModel': assistantModel.name,
    };

    final response = await _apiService.get(ApiEndpoints.chatHistory,
        params: params, pathVars: {'conversationId': conversationId});

    if (response.statusCode == 200) {
      return ApiResponse<ChatHistory>.fromJson(
          response.data, (item) => ChatHistory.fromJson(item)).items;
    }

    throw Exception('Failed to get conversations');
  }

  Future<List<Conversation>> getConversations(
      {String? cursor,
      int? limit,
      AssistantId? assistantId,
      required AssistantModel assistantModel}) async {
    final params = {
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
      if (assistantId != null) 'assistantId': assistantId.name,
      'assistantModel': assistantModel.name,
    };

    final response =
        await _apiService.get(ApiEndpoints.chatConversation, params: params);

    if (response.statusCode == 200) {
      return ApiResponse<Conversation>.fromJson(
          response.data, (item) => Conversation.fromJson(item)).items;
    }

    throw Exception('Failed to get conversations');
  }

  Future<MessageResponse> sendMessage(Map<String, dynamic> assistant,
      String content, List<String>? files, dynamic metadata) async {
    final response = await _apiService.post(ApiEndpoints.chatSend, data: {
      'assistant': assistant,
      'content': content,
      'metadata': metadata,
    });

    if (response.statusCode == 200) {
      return MessageResponse.fromJson(response.data);
    }

    throw Exception('Failed to send message');
  }

  //List<ChatHistory> _messages = [];

  // Future<List<ChatHistory>> loadConversationHistory(String conversationId,
  //     AssistantId assistantId, AssistantModel assistantModel) async {
  //   final response = await getConversationHistory(conversationId,
  //       assistantId: assistantId.name, assistantModel: assistantModel.name);
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to load conversation history');
  //   }
  //   final data = response.data['items'] as List;
  //   _messages = data.map((item) => ChatHistory.fromJson(item)).toList();
  //   return _messages;
  // }

  // Future<List<Conversation>> fetchConversations(
  //     AssistantId assistantId, AssistantModel assistantModel) async {
  //   final response = await getConversations(
  //       assistantId: assistantId.name, assistantModel: assistantModel.name);
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to load conversations');
  //   }
  //   final data = response.data['items'] as List;
  //   return data.map((item) => Conversation.fromJson(item)).toList();
  // }
}
