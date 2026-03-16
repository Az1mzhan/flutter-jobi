import 'package:dio/dio.dart';
import 'package:jobi/core/network/auth_interceptor.dart';
import 'package:jobi/core/storage/session_manager.dart';

class ApiClient {
  ApiClient({
    required String baseUrl,
    required SessionManager sessionManager,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
            headers: {'Accept': 'application/json'},
          ),
        ) {
    _dio.interceptors.addAll([
      AuthInterceptor(sessionManager: sessionManager, baseUrl: baseUrl),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) {
    return _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: Options(extra: extra),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) {
    return _dio.post<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(extra: extra),
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) {
    return _dio.put<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(extra: extra),
    );
  }
}
