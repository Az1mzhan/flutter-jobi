import 'package:jobi/core/constants/api_endpoints.dart';
import 'package:jobi/core/network/api_client.dart';
import 'package:jobi/features/auth/data/models/auth_models.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<UserSessionModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.authLogin,
      data: {
        'email': email,
        'password': password,
      },
      extra: {'skipAuthRefresh': true},
    );

    return UserSessionModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> sendOtp({required String phone}) async {
    await _apiClient.post(
      ApiEndpoints.authOtpSend,
      data: {'phone': phone},
      extra: {'skipAuthRefresh': true},
    );
  }

  Future<UserSessionModel> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.authOtpVerify,
      data: {
        'phone': phone,
        'code': code,
      },
      extra: {'skipAuthRefresh': true},
    );

    return UserSessionModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserSessionModel> register(RegisterRequestModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.authRegister,
      data: request.toJson(),
      extra: {'skipAuthRefresh': true},
    );

    return UserSessionModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserSessionModel> googlePlaceholder() async {
    final response = await _apiClient.post(
      ApiEndpoints.authGoogle,
      data: {'provider': 'google'},
      extra: {'skipAuthRefresh': true},
    );

    return UserSessionModel.fromJson(response.data as Map<String, dynamic>);
  }
}
