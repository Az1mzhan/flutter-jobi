import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/features/auth/domain/entities/user_session.dart';

abstract class AuthRepository {
  Future<UserSession?> restoreSession();

  Future<UserSession> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> sendOtp({required String phone});

  Future<UserSession> verifyOtp({
    required String phone,
    required String code,
  });

  Future<UserSession> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required List<RoleType> roles,
  });

  Future<UserSession> signInWithGooglePlaceholder();

  Future<void> logout();
}
