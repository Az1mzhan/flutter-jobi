import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/core/errors/app_exception.dart';
import 'package:jobi/features/auth/domain/entities/user_session.dart';
import 'package:jobi/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  authenticating,
  otpSent,
  authenticated,
  failure,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.session,
    this.activeRole,
    this.pendingPhone,
    this.message,
  });

  final AuthStatus status;
  final UserSession? session;
  final RoleType? activeRole;
  final String? pendingPhone;
  final String? message;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && session != null;

  List<RoleType> get availableRoles => session?.roles ?? const [];

  AuthState copyWith({
    AuthStatus? status,
    UserSession? session,
    RoleType? activeRole,
    String? pendingPhone,
    String? message,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      activeRole: activeRole ?? this.activeRole,
      pendingPhone: pendingPhone ?? this.pendingPhone,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, session, activeRole, pendingPhone, message];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    final session = await _repository.restoreSession();
    if (session == null) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }

    emit(
      AuthState(
        status: AuthStatus.authenticated,
        session: session,
        activeRole: session.roles.isNotEmpty ? session.roles.first : RoleType.worker,
      ),
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearMessage: true));
    try {
      final session =
          await _repository.signInWithEmail(email: email, password: password);
      emit(
        AuthState(
          status: AuthStatus.authenticated,
          session: session,
          activeRole: session.roles.isNotEmpty ? session.roles.first : RoleType.worker,
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: 'Сейчас не удается выполнить вход.',
        ),
      );
    }
  }

  Future<void> sendOtp(String phone) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearMessage: true));
    try {
      await _repository.sendOtp(phone: phone);
      emit(
        state.copyWith(
          status: AuthStatus.otpSent,
          pendingPhone: phone,
          message: 'Код подтверждения отправлен',
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: 'Сейчас не удается отправить OTP.',
        ),
      );
    }
  }

  Future<void> verifyOtp({
    required String phone,
    required String code,
  }) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearMessage: true));
    try {
      final session = await _repository.verifyOtp(phone: phone, code: code);
      emit(
        AuthState(
          status: AuthStatus.authenticated,
          session: session,
          activeRole: session.roles.isNotEmpty ? session.roles.first : RoleType.worker,
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: 'Проверка кода не удалась. Попробуйте снова.',
        ),
      );
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required List<RoleType> roles,
  }) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearMessage: true));
    try {
      final session = await _repository.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        roles: roles,
      );
      emit(
        AuthState(
          status: AuthStatus.authenticated,
          session: session,
          activeRole: session.roles.isNotEmpty ? session.roles.first : RoleType.worker,
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: 'Регистрация не удалась. Попробуйте снова.',
        ),
      );
    }
  }

  Future<void> signInWithGooglePlaceholder() async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearMessage: true));
    try {
      final session = await _repository.signInWithGooglePlaceholder();
      emit(
        AuthState(
          status: AuthStatus.authenticated,
          session: session,
          activeRole: session.roles.isNotEmpty ? session.roles.first : RoleType.worker,
        ),
      );
    } on AppException catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: 'Не удалось выполнить демо-вход через Google.',
        ),
      );
    }
  }

  void switchRole(RoleType role) {
    emit(state.copyWith(activeRole: role));
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
