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
      fullName: 'Aidana Worker',
      city: 'Almaty',
      region: 'Almaty Region',
      latitude: 43.238949,
      longitude: 76.889709,
      about:
          'Reliable finishing specialist with brigade coordination experience and fast response for urgent tasks.',
      avatarUrl: '',
      roles: const [RoleType.worker, RoleType.employer, RoleType.brigade],
      professions: const ['Painter', 'Finisher', 'Brigade leader'],
      experience: const [
        ProfessionExperience(profession: 'Painter', months: 42),
        ProfessionExperience(profession: 'Finisher', months: 30),
        ProfessionExperience(profession: 'Brigade leader', months: 18),
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
          title: 'Office repainting',
          counterparty: 'Khan Stroy LLP',
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: 'Completed',
          amount: 85000,
        ),
        WorkHistoryEntry(
          id: 'hist_2',
          title: 'Urgent tiling support',
          counterparty: 'Private employer',
          date: DateTime.now().subtract(const Duration(days: 10)),
          status: 'Completed',
          amount: 45000,
        ),
        WorkHistoryEntry(
          id: 'hist_3',
          title: 'Warehouse clean-up crew',
          counterparty: 'Logistics Hub',
          date: DateTime.now().subtract(const Duration(days: 18)),
          status: 'Cancelled',
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
