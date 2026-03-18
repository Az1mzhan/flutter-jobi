import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/core/errors/app_exception.dart';
import 'package:jobi/features/profile/domain/entities/user_profile.dart';
import 'package:jobi/features/profile/domain/repositories/profile_repository.dart';

enum ProfileStatus { initial, loading, loaded, saving, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.message,
  });

  final ProfileStatus status;
  final UserProfile? profile;
  final String? message;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? message,
    bool clearMessage = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, profile, message];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileState());

  final ProfileRepository _repository;

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearMessage: true));
    try {
      final profile = await _repository.getMyProfile();
      emit(ProfileState(status: ProfileStatus.loaded, profile: profile));
    } on AppException catch (error) {
      emit(state.copyWith(status: ProfileStatus.error, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          message: 'Сейчас не удается загрузить профиль.',
        ),
      );
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    emit(state.copyWith(status: ProfileStatus.saving, clearMessage: true));
    try {
      final updated = await _repository.updateProfile(profile);
      emit(ProfileState(status: ProfileStatus.loaded, profile: updated));
    } on AppException catch (error) {
      emit(state.copyWith(status: ProfileStatus.error, message: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          message: 'Не удалось сохранить изменения профиля.',
        ),
      );
    }
  }

  Future<void> toggleAvailability(bool value) async {
    emit(state.copyWith(status: ProfileStatus.saving, clearMessage: true));
    try {
      final updated = await _repository.setAvailability(value);
      emit(ProfileState(status: ProfileStatus.loaded, profile: updated));
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          message: 'Не удалось обновить статус доступности.',
        ),
      );
    }
  }

  Future<void> toggleTravelReady(bool value) async {
    emit(state.copyWith(status: ProfileStatus.saving, clearMessage: true));
    try {
      final updated = await _repository.setTravelReady(value);
      emit(ProfileState(status: ProfileStatus.loaded, profile: updated));
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          message: 'Не удалось обновить готовность к выезду.',
        ),
      );
    }
  }
}
