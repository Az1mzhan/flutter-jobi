import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobi/core/storage/preferences_service.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._preferences) : super(const Locale('ru'));

  static const _localeKey = 'jobi_locale_code';

  final PreferencesService _preferences;

  Future<void> loadSavedLocale() async {
    final savedCode = _preferences.getString(_localeKey);
    if (savedCode == null || savedCode.isEmpty) return;
    emit(Locale(savedCode));
  }

  Future<void> changeLocale(String languageCode) async {
    if (state.languageCode == languageCode) return;
    await _preferences.setString(_localeKey, languageCode);
    emit(Locale(languageCode));
  }
}
