import 'package:jarvis_ktk/constants/api_endpoints.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';

import 'api_service.dart';

class PromptApi{
  final ApiService _apiService;

  PromptApi(this._apiService);

  Future<List<Prompt>> getPrompts({
    String? string,
    int? offset,
    int? limit,
    String? category,
    bool? isFavorite,
    bool? isPublic,
  }) async {
    final params = {
      if (string != null) 'string': string,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
      if (category != null) 'category': category,
      if (isFavorite != null) 'isFavorite': isFavorite,
      if (isPublic != null) 'isPublic': isPublic,
    };

    // Make the API request with the filtered params
    final response = await _apiService.get(ApiEndpoints.prompts, params: params);

    List<Prompt> prompts = [];

    if (response.statusCode == 200) {
      for (var prompt in response.data['items']) {
        if (prompt['isPublic'] == true) {
          prompts.add(PublicPrompt.fromJson(prompt));
        } else {
          prompts.add(MyPrompt.fromJson(prompt));
        }
      }
    }

    return prompts;
  }

  Future<Prompt> createPrompt(Prompt prompt) async {
    final body = prompt is PublicPrompt
        ? prompt.toJson()
        : {...prompt.toJson(), 'isPublic': false};
    final response = await _apiService.post(ApiEndpoints.prompts, data: body);
    if (response.statusCode == 201) {
      return response.data['isPublic'] == true
          ? PublicPrompt.fromJson(response.data)
          : MyPrompt.fromJson(response.data);
    }
    throw Exception('Failed to create prompt');
  }

  Future<Prompt> updatePrompt(String promptId, Prompt prompt) async {
    final body = prompt is PublicPrompt
        ? prompt.toJson()
        : {...prompt.toJson()};
    final response = await _apiService.patch(ApiEndpoints.promptById, pathVars: {'id': promptId}, data: body);
    if (response.statusCode == 200) {
      return response.data['isPublic'] == true
          ? PublicPrompt.fromJson(response.data)
          : MyPrompt.fromJson(response.data);
    }
    throw Exception('Failed to update prompt');
  }

  Future<String> deletePrompt(String promptId) async {
    final response = await _apiService.delete(ApiEndpoints.promptById, pathVars: {'id': promptId});
    if (response.statusCode != 200) {
      throw Exception('Failed to delete prompt');
    }
    return "Prompt deleted";
  }

  Future<String> addPromptToFavorite(String promptId) async {
    final response = await _apiService.post(ApiEndpoints.promptFavorite, pathVars: {'id': promptId});
    if (response.statusCode != 201) {
      throw Exception('Failed to favorite prompt');
    }
    return "Prompt added to favorite";
  }

  Future<String> removePromptFromFavorite(String promptId) async {
    final response = await _apiService.delete(ApiEndpoints.promptFavorite, pathVars: {'id': promptId});
    if (response.statusCode != 200) {
      throw Exception('Failed to remove prompt from favorite');
    }
    return "Prompt removed from favorite";
  }

}