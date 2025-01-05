import 'package:jarvis_ktk/constants/api_endpoints.dart';
import 'package:jarvis_ktk/data/models/email_reply.dart';
import 'package:jarvis_ktk/data/models/email_reply_response.dart';
import 'package:jarvis_ktk/data/models/email_suggest_idea_response.dart';

import 'api_service.dart';

class EmailApi{
  final ApiService _apiService;

  EmailApi(this._apiService);

  Future<EmailReplyResponse> responseEmail(EmailReply emailReply, Map<String, String> aiAgent) async {

    final response = await _apiService.post(ApiEndpoints.responseEmail, data: {
      ...emailReply.toJson(),
      'assistant': aiAgent,
    });

    if (response.statusCode == 200) {
      return EmailReplyResponse.fromJson(response.data);
    }
    throw Exception('Failed to response email');
  }

  Future<EmailSuggestIdeaResponse> suggestReplyIdeas(EmailReply emailReply) async {
    final response = await _apiService.post(ApiEndpoints.suggestEmailIdeas, data: emailReply.toJson());

    if (response.statusCode == 200) {
      return EmailSuggestIdeaResponse.fromJson(response.data);
    }
    throw Exception('Failed to suggest reply ideas');
  }
}