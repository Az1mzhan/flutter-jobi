import 'dart:convert';

import 'package:jobi/core/constants/app_constants.dart';
import 'package:jobi/core/constants/user_roles.dart';
import 'package:jobi/core/storage/preferences_service.dart';
import 'package:jobi/features/profile/data/models/user_profile_model.dart';
import 'package:jobi/features/profile/domain/entities/user_profile.dart';

class ProfileMockDataSource {
  ProfileMockDataSource(this._preferences);

  final PreferencesService _preferences;
  static const _storageKey = 'jobi_profile_cache_v2';

  Future<UserProfileModel> getMyProfile() async {
    await Future<void>.delayed(AppConstants.mockDelay);

    final cached = _preferences.getString(_storageKey);
    if (cached != null && cached.isNotEmpty) {
      return UserProfileModel.fromJson(jsonDecode(cached) as Map<String, dynamic>);
    }

    final profile = UserProfileModel(
      id: 'profile_ip_elyubaeva',
      fullName: 'ИП ЕЛЮБАЕВА',
      city: 'Астана',
      region: 'Астана',
      latitude: 51.169392,
      longitude: 71.449074,
      about:
          'Индивидуальный предприниматель в Астане.\n'
          'Адрес: ул. Нурмухамбет Кожахметов, дом 32.\n'
          'ИИН/БИН: 780529402169.\n'
          'Банк: АО "Kaspi Bank".\n'
          'КБе: 19.\n'
          'БИК: CASPKZKA.\n'
          'Счет: KZ59722S000029076373.',
      avatarUrl: 'assets/images/ip_elyubaeva_avatar.jpeg',
      roles: const [RoleType.entrepreneur, RoleType.employer],
      professions: const ['Грузоперевозки', 'Логистика', 'Экспедирование'],
      experience: const [
        ProfessionExperience(profession: 'Грузоперевозки', months: 48),
        ProfessionExperience(profession: 'Логистика', months: 42),
        ProfessionExperience(profession: 'Экспедирование', months: 36),
      ],
      totalTasks: 128,
      successfulTasks: 123,
      cancellations: 2,
      rating: 4.9,
      availableNow: true,
      readyToTravel: true,
      firstJobDate: DateTime(2021, 3, 1),
      workHistory: [
        WorkHistoryEntry(
          id: 'hist_ip_1',
          title: 'Доставка строительных материалов по Астане',
          counterparty: 'ТОО Capital Build',
          date: DateTime.now().subtract(const Duration(days: 4)),
          status: 'Завершено',
          amount: 185000,
        ),
        WorkHistoryEntry(
          id: 'hist_ip_2',
          title: 'Экспедирование груза на склад заказчика',
          counterparty: 'Kaspi Logistics Partner',
          date: DateTime.now().subtract(const Duration(days: 11)),
          status: 'Завершено',
          amount: 142000,
        ),
        WorkHistoryEntry(
          id: 'hist_ip_3',
          title: 'Срочная перевозка коммерческого груза',
          counterparty: 'Частный заказчик',
          date: DateTime.now().subtract(const Duration(days: 19)),
          status: 'Завершено',
          amount: 96000,
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
