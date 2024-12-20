import 'package:dio/dio.dart';
import 'package:jarvis_ktk/constants/api_endpoints.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthApi {
  final ApiService _apiService;

  AuthApi(this._apiService);

  Future<Response> signIn(String email, String password) async {
    final response = await _apiService.post(
      ApiEndpoints.signIn,
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = response.data['token'];
      final String accessToken = data['accessToken'];
      final String refreshToken = data['refreshToken'];

      // Save tokens using FlutterSecureStorage
      await _apiService.saveTokens(accessToken, refreshToken);
    }

    return response;
  }

  Future<Response> signUp(
      String username, String password, String email) async {
    return _apiService.post(
      ApiEndpoints.signUp,
      data: {'username': username, 'password': password, 'email': email},
    );
  }

  Future<Response> getUserInfo() async {
    final response = await _apiService.get(ApiEndpoints.me);
    if (response.statusCode == 200) {
      _apiService.saveUser(User.fromJson(response.data));
    }
    return response;
  }

  Future<Response> signOut() async {
    final response = await _apiService.get(ApiEndpoints.signOut);
    return response;
  }
}
