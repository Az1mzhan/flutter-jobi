import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/core/errors/app_exception.dart';
import 'package:jobi/features/auth/data/models/auth_models.dart';

class AuthMockDataSource {
  Future<UserSessionModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(AppConstants.mockDelay);

    if (password.length < 6) {
      throw const AppException('Use at least 6 characters for demo sign-in.');
    }

    return _buildSession(
      email: email,
      phone: '+7 700 123 45 67',
      fullName: 'Aruzhan Demo',
      roles: const [RoleType.worker, RoleType.employer],
    );
  }

  Future<void> sendOtp({required String phone}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  Future<UserSessionModel> verifyOtp({
    required String phone,
    required String code,
  }) async {
    await Future<void>.delayed(AppConstants.mockDelay);

    if (code != '123456') {
      throw const AppException('Mock OTP code is 123456');
    }

    return _buildSession(
      email: 'worker@jobi.kz',
      phone: phone,
      fullName: 'Aidana Worker',
      roles: const [RoleType.worker, RoleType.brigade],
    );
  }

  Future<UserSessionModel> register(RegisterRequestModel request) async {
    await Future<void>.delayed(AppConstants.mockDelay);

    return _buildSession(
      email: request.email,
      phone: request.phone,
      fullName: request.fullName,
      roles: request.roles,
    );
  }

  Future<UserSessionModel> googlePlaceholder() async {
    await Future<void>.delayed(AppConstants.mockDelay);

    return _buildSession(
      email: 'google.user@jobi.kz',
      phone: '+7 707 555 11 22',
      fullName: 'Google Demo User',
      roles: const [RoleType.worker, RoleType.company],
    );
  }

  UserSessionModel _buildSession({
    required String email,
    required String phone,
    required String fullName,
    required List<RoleType> roles,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return UserSessionModel(
      userId: 'user_$timestamp',
      fullName: fullName,
      email: email,
      phone: phone,
      roles: roles,
      accessToken: 'mock-access-token-$timestamp',
      refreshToken: 'mock-refresh-token-$timestamp',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
  }
}
