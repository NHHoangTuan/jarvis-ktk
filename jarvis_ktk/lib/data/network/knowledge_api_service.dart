import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import '../../constants/api_endpoints.dart';
import 'knowledge_api.dart';

class KnowledgeApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  KnowledgeApiService() {
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
    String? token = await _storage.read(key: 'kbAccessToken');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _handleError(
      DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      final newAccessToken = await _refreshAccessToken();
      if (newAccessToken != null) {
        error.requestOptions.headers['Authorization'] =
        'Bearer $newAccessToken';
        await saveAccessToken(newAccessToken);
        final newResponse = await _retryRequest(error.requestOptions);
        return handler.resolve(newResponse);
      }
      else {
        final response = await getIt<KnowledgeApi>().signIn();
        if (response.statusCode == 200) {
          final newAccessToken = response.data['token']['accessToken'];
          error.requestOptions.headers['Authorization'] =
          'Bearer $newAccessToken';
          await saveAccessToken(newAccessToken);
          final newResponse = await _retryRequest(error.requestOptions);
          return handler.resolve(newResponse);
        }
      }
    }
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

  Future<String?> _refreshAccessToken() async {
    try {
      String? refreshToken = await _storage.read(key: 'kbRefreshToken');
      if (refreshToken == null) return null;

      final Dio dio = Dio();
      final response = await dio.get(
        ApiEndpoints.refreshToken,
        queryParameters: {'kbRefreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        return response.data['token']['kbAccessToken'];
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
    return '${ApiEndpoints.knowledgeBaseUrl}/$endpoint';
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(key: 'kbAccessToken', value: accessToken);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'kbAccessToken', value: accessToken);
    await _storage.write(key: 'kbRefreshToken', value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'kbAccessToken');
    await _storage.delete(key: 'kbRefreshToken');
  }
}
