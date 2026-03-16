import 'package:dio/dio.dart';
import 'package:jobi/core/constants/api_endpoints.dart';
import 'package:jobi/core/storage/session_manager.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.sessionManager,
    required this.baseUrl,
  }) : _refreshDio = Dio(BaseOptions(baseUrl: baseUrl));

  final SessionManager sessionManager;
  final String baseUrl;
  final Dio _refreshDio;

  bool _refreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await sessionManager.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRefresh = err.response?.statusCode == 401 &&
        err.requestOptions.extra['skipAuthRefresh'] != true &&
        !_refreshing;

    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    _refreshing = true;
    final refreshed = await _tryRefresh();
    _refreshing = false;

    if (!refreshed) {
      await sessionManager.clear();
      handler.next(err);
      return;
    }

    final newToken = await sessionManager.getAccessToken();
    if (newToken == null) {
      handler.next(err);
      return;
    }

    final requestOptions = err.requestOptions;
    requestOptions.headers['Authorization'] = 'Bearer $newToken';

    try {
      final response = await _refreshDio.fetch<dynamic>(requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _tryRefresh() async {
    final refreshToken = await sessionManager.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipAuthRefresh': true}),
      );

      final data = response.data ?? <String, dynamic>{};
      final accessToken = data['accessToken'] as String?;
      final nextRefreshToken = data['refreshToken'] as String? ?? refreshToken;

      if (accessToken == null || accessToken.isEmpty) return false;

      await sessionManager.updateTokens(
        accessToken: accessToken,
        refreshToken: nextRefreshToken,
        expiresAtIso: data['expiresAt'] as String?,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
