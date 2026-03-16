import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/core/storage/session_manager.dart';
import 'package:jobi/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:jobi/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jobi/features/auth/data/models/auth_models.dart';
import 'package:jobi/features/auth/domain/entities/user_session.dart';
import 'package:jobi/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.sessionManager,
    required this.remoteDataSource,
    required this.mockDataSource,
  });

  final SessionManager sessionManager;
  final AuthRemoteDataSource remoteDataSource;
  final AuthMockDataSource mockDataSource;

  @override
  Future<UserSession?> restoreSession() async {
    final sessionJson = await sessionManager.readSessionJson();
    if (sessionJson == null) return null;
    return UserSessionModel.fromJson(sessionJson);
  }

  @override
  Future<UserSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final session = AppConstants.useMockData
        ? await mockDataSource.signInWithEmail(email: email, password: password)
        : await remoteDataSource.signInWithEmail(email: email, password: password);

    await sessionManager.saveSessionJson(session.toJson());
    return session;
  }

  @override
  Future<void> sendOtp({required String phone}) {
    return AppConstants.useMockData
        ? mockDataSource.sendOtp(phone: phone)
        : remoteDataSource.sendOtp(phone: phone);
  }

  @override
  Future<UserSession> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final session = AppConstants.useMockData
        ? await mockDataSource.verifyOtp(phone: phone, code: code)
        : await remoteDataSource.verifyOtp(phone: phone, code: code);

    await sessionManager.saveSessionJson(session.toJson());
    return session;
  }

  @override
  Future<UserSession> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required List<RoleType> roles,
  }) async {
    final request = RegisterRequestModel(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      roles: roles,
    );

    final session = AppConstants.useMockData
        ? await mockDataSource.register(request)
        : await remoteDataSource.register(request);

    await sessionManager.saveSessionJson(session.toJson());
    return session;
  }

  @override
  Future<UserSession> signInWithGooglePlaceholder() async {
    final session = AppConstants.useMockData
        ? await mockDataSource.googlePlaceholder()
        : await remoteDataSource.googlePlaceholder();

    await sessionManager.saveSessionJson(session.toJson());
    return session;
  }

  @override
  Future<void> logout() => sessionManager.clear();
}
