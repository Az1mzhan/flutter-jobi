import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/features/auth/domain/entities/user_session.dart';
import 'package:jobi/features/auth/domain/repositories/auth_repository.dart';

class RestoreSession {
  const RestoreSession(this.repository);

  final AuthRepository repository;

  Future<UserSession?> call() => repository.restoreSession();
}

class SignInWithEmail {
  const SignInWithEmail(this.repository);

  final AuthRepository repository;

  Future<UserSession> call({
    required String email,
    required String password,
  }) {
    return repository.signInWithEmail(email: email, password: password);
  }
}

class SendOtp {
  const SendOtp(this.repository);

  final AuthRepository repository;

  Future<void> call({required String phone}) => repository.sendOtp(phone: phone);
}

class VerifyOtp {
  const VerifyOtp(this.repository);

  final AuthRepository repository;

  Future<UserSession> call({
    required String phone,
    required String code,
  }) {
    return repository.verifyOtp(phone: phone, code: code);
  }
}

class RegisterUser {
  const RegisterUser(this.repository);

  final AuthRepository repository;

  Future<UserSession> call({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required List<RoleType> roles,
  }) {
    return repository.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      roles: roles,
    );
  }
}

class Logout {
  const Logout(this.repository);

  final AuthRepository repository;

  Future<void> call() => repository.logout();
}
