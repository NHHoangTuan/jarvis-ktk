import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/models/user.dart';
import 'package:jarvis_ktk/main.dart';
import 'package:jarvis_ktk/routes/app_routes.dart';

import '../../constants/api_endpoints.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    _initializeInterceptors();
    _setDioOptions();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _handleRequest,
        onError: _handleError,
      ),
    );
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<void> _handleRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _storage.read(key: 'accessToken');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _handleError(
      DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode != 401) {
      handler.next(error);
      return;
    }

    final newAccessToken = await refreshAccessToken();
    if (newAccessToken != null) {
      error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      await saveAccessToken(newAccessToken);
      final newResponse = await _retryRequest(error.requestOptions);
      return handler.resolve(newResponse);
    }

    Fluttertoast.showToast(
      msg: 'Session expired. Please login again.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
    await clearTokens();
    await clearUser();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
          (route) => false,
    );

    handler.next(error);
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    return _dio.request(
      requestOptions.path,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  void _setDioOptions() {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.validateStatus = (status) {
      return status != 401;
    };
  }

  Future<String?> refreshAccessToken() async {
    try {
      String? refreshToken = await _storage.read(key: 'refreshToken');
      if (refreshToken == null) return null;
      final response = await get(ApiEndpoints.refreshToken,
          params: {'refreshToken': refreshToken});
      if (response.statusCode == 200) {
        String newAccessToken = response.data['token']['accessToken'];
        await _storage.write(key: 'accessToken', value: newAccessToken);
        return newAccessToken;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? pathVars,
  }) async {
    String url = _constructUrl(endpoint, pathVars);
    return _dio.get(url, queryParameters: params);
  }

  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? pathVars,
  }) async {
    String url = _constructUrl(endpoint, pathVars);
    return _dio.post(url, data: data, queryParameters: params);
  }

  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? pathVars,
  }) async {
    String url = _constructUrl(endpoint, pathVars);
    return _dio.put(url, data: data, queryParameters: params);
  }

  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? pathVars,
  }) async {
    String url = _constructUrl(endpoint, pathVars);
    return _dio.patch(url, data: data, queryParameters: params);
  }

  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? pathVars,
  }) async {
    String url = _constructUrl(endpoint, pathVars);
    return _dio.delete(url, data: data, queryParameters: params);
  }

  String _constructUrl(String endpoint, Map<String, dynamic>? pathVars) {
    pathVars?.forEach((key, value) {
      endpoint = endpoint.replaceAll('{$key}', value.toString());
    });
    return '${ApiEndpoints.baseUrl}/$endpoint';
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: 'user', value: userJson);
  }

  Future<void> clearUser() async {
    await _storage.delete(key: 'user');
  }

  Future<User?> getStoredUser() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }
}
