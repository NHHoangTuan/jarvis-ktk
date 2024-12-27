import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jarvis_ktk/constants/api_endpoints.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api_service.dart';
import 'package:mime/mime.dart';

class KnowledgeApi {
  final KnowledgeApiService _knowledgeApiService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();


  KnowledgeApi(this._knowledgeApiService);

  Future<Response> signIn() async {
    final response = await _knowledgeApiService.post(
      ApiEndpoints.kbSignIn,
      data: {'token': await _storage.read(key: 'accessToken')},
    );

    if (response.statusCode == 200) {
      final data = response.data['token'];
      final String accessToken = data['accessToken'];
      final String refreshToken = data['refreshToken'];

      // Save tokens using FlutterSecureStorage
      await _knowledgeApiService.saveTokens(accessToken, refreshToken);
    }

    return response;
  }

  Future<Knowledge> createKnowledge(String knowledgeName, String description) async {
    final response = await _knowledgeApiService.post(
      ApiEndpoints.knowledge,
      data: {'knowledgeName': knowledgeName, 'description': description},
    );

    if (response.statusCode == 201) {
      return Knowledge.fromJson(response.data);
    }

    throw Exception('Failed to create knowledge');
  }

  Future<List<Knowledge>> getKnowledgeList({
    String? query,
    String? order,
    String? orderField,
    int? offset,
    int? limit,
  }) async {
    final params = {
      if (query != null) 'q': query,
      if (order != null) 'order': order,
      if (orderField != null) 'orderField': orderField,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };

    final response = await _knowledgeApiService.get(ApiEndpoints.knowledge, params: params);

    List<Knowledge> knowledgeList = [];

    if (response.statusCode == 200) {
      for (var knowledge in response.data['data']) {
        knowledgeList.add(Knowledge.fromJson(knowledge));
      }
    }

    return knowledgeList;
  }

  Future<Knowledge> updateKnowledge(String knowledgeId, String knowledgeName, String description) async {
    final response = await _knowledgeApiService.patch(
      ApiEndpoints.knowledgeById,
      pathVars: {'id': knowledgeId},
      data: {'knowledgeName': knowledgeName, 'description': description},
    );

    if (response.statusCode == 200) {
      return Knowledge.fromJson(response.data);
    }

    throw Exception('Failed to update knowledge');
  }

  Future<void> deleteKnowledge(String knowledgeId) async {
    final response = await _knowledgeApiService.delete(
      ApiEndpoints.knowledgeById,
      pathVars: {'id': knowledgeId},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete knowledge');
    }
  }

  Future<List<Unit>> getUnitList(
      String knowledgeId,
      )
  async {

    final response = await _knowledgeApiService.get(ApiEndpoints.knowledgeUnits, pathVars: {'id': knowledgeId});

    List<Unit> unitList = [];

    if (response.statusCode == 200) {
      for (var unit in response.data['data']) {
        final unitJson = Unit.fromJson(unit);
        unitList.add(unitJson);
      }
    }

    return unitList;
  }

  Future<void> deleteUnit(String knowledgeId, String unitId) async {
    final response = await _knowledgeApiService.delete(
      ApiEndpoints.knowledgeUnitById,
      pathVars: {'id': knowledgeId, 'unitId': unitId},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete unit');
    }

  }

  Future<void> updateUnitStatus(String unitId, bool enabled) async {
    final response = await _knowledgeApiService.patch(
      ApiEndpoints.knowledgeUnitStatus,
      pathVars: {'unitId': unitId},
      data: {'status': enabled},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update unit status');
    }
  }

  Future<void> uploadLocalFile(String knowledgeId, String filePath) async {
    final fileName = filePath.split('/').last;

    final mimeType = lookupMimeType(fileName);
    if (mimeType == null) {
      throw Exception("Failed to get mime type");
    }

    final file = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      contentType: MediaType.parse(mimeType),
    );
    FormData formData = FormData.fromMap({
      'file': file,
    });


    final response = await _knowledgeApiService.post(
      ApiEndpoints.localFileUnit,
      data: formData,
      pathVars: {'id': knowledgeId},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload local file');
    }
  }

  Future<void> uploadFromWebsite(String knowledgeId, String name, String webUrl) async {
    final response = await _knowledgeApiService.post(
      ApiEndpoints.webUnit,
      data: {'unitName': name, 'webUrl': webUrl},
      pathVars: {'id': knowledgeId},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload data from website');
    }
  }

  Future<void> uploadFromGoogleDrive(String knowledgeId, String name, String googleDriveCredential) async {
    final response = await _knowledgeApiService.post(
      ApiEndpoints.googleDriveUnit,
      data: {'name': name, 'googleDriveCredential': googleDriveCredential},
      pathVars: {'id': knowledgeId},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload data from Google Drive');
    }
  }

  Future<void> uploadFromSlack(String knowledgeId, String name, String slackWorkspace, String slackBotToken) async {
    final response = await _knowledgeApiService.post(
      ApiEndpoints.slackUnit,
      data: {'unitName': name, 'slackWorkspace': slackWorkspace, 'slackBotToken': slackBotToken},
      pathVars: {'id': knowledgeId},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload data from Slack');
    }
  }

  Future<void> uploadFromConfluence(
      String knowledgeId,
      String name,
      String wikiPageUrl,
      String confluenceUsername,
      String confluenceAccessToken,
      ) async {
    final response = await _knowledgeApiService.post(
      ApiEndpoints.confluenceUnit,
      data: {
        'unitName': name,
        'wikiPageUrl': wikiPageUrl,
        'confluenceUsername': confluenceUsername,
        'confluenceAccessToken': confluenceAccessToken,
      },
      pathVars: {'id': knowledgeId},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload data from Confluence');
    }
  }


}
