import 'dart:convert';

import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/core/storage/preferences_service.dart';
import 'package:jobi/features/profile/data/models/user_profile_model.dart';
import 'package:jobi/features/profile/domain/entities/user_profile.dart';

class ProfileMockDataSource {
  ProfileMockDataSource(this._preferences);

  final PreferencesService _preferences;
  static const _storageKey = 'jobi_profile_cache';

  Future<UserProfileModel> getMyProfile() async {
    await Future<void>.delayed(AppConstants.mockDelay);

    final cached = _preferences.getString(_storageKey);
    if (cached != null && cached.isNotEmpty) {
      return UserProfileModel.fromJson(jsonDecode(cached) as Map<String, dynamic>);
    }

    final profile = UserProfileModel(
      id: 'profile_1',
      fullName: 'Айдана У.',
      city: 'Алматы',
      region: 'Алматинская область',
      latitude: 43.238949,
      longitude: 76.889709,
      about:
          'Надежный специалист по отделке с опытом координации бригады и быстрым откликом на срочные задачи.',
      avatarUrl: '',
      roles: const [RoleType.worker, RoleType.employer, RoleType.brigade],
      professions: const ['Маляр', 'Отделочник', 'Бригадир'],
      experience: const [
        ProfessionExperience(profession: 'Маляр', months: 42),
        ProfessionExperience(profession: 'Отделочник', months: 30),
        ProfessionExperience(profession: 'Бригадир', months: 18),
      ],
      totalTasks: 96,
      successfulTasks: 88,
      cancellations: 4,
      rating: 4.8,
      availableNow: true,
      readyToTravel: true,
      firstJobDate: DateTime(2022, 2, 15),
      workHistory: [
        WorkHistoryEntry(
          id: 'hist_1',
          title: 'Покраска офиса',
          counterparty: 'Хан Строй',
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: 'Завершено',
          amount: 85000,
        ),
        WorkHistoryEntry(
          id: 'hist_2',
          title: 'Срочная помощь с плиткой',
          counterparty: 'Частный работодатель',
          date: DateTime.now().subtract(const Duration(days: 10)),
          status: 'Завершено',
          amount: 45000,
        ),
        WorkHistoryEntry(
          id: 'hist_3',
          title: 'Бригада для уборки склада',
          counterparty: 'Логистический хаб',
          date: DateTime.now().subtract(const Duration(days: 18)),
          status: 'Отменено',
          amount: 30000,
        ),
      ],
    );

    await _save(profile);
    return profile;
  }

  Future<UserProfileModel> updateProfile(UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final model = UserProfileModel.fromEntity(profile);
    await _save(model);
    return model;
  }

  Future<void> _save(UserProfileModel profile) {
    return _preferences.setString(_storageKey, jsonEncode(profile.toJson()));
  }
}
