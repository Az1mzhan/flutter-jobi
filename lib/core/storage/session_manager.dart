import 'dart:convert';

import 'package:jobi/core/storage/secure_storage_service.dart';

class SessionManager {
  SessionManager(this._secureStorage);

  final SecureStorageService _secureStorage;

  static const _sessionKey = 'jobi_session';

  Future<void> saveSessionJson(Map<String, dynamic> sessionJson) async {
    await _secureStorage.write(_sessionKey, jsonEncode(sessionJson));
  }

  Future<Map<String, dynamic>?> readSessionJson() async {
    final raw = await _secureStorage.read(_sessionKey);
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<String?> getAccessToken() async {
    final json = await readSessionJson();
    return json?['accessToken'] as String?;
  }

  Future<String?> getRefreshToken() async {
    final json = await readSessionJson();
    return json?['refreshToken'] as String?;
  }

  Future<bool> hasSession() async => (await readSessionJson()) != null;

  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
    String? expiresAtIso,
  }) async {
    final current = await readSessionJson() ?? <String, dynamic>{};
    current['accessToken'] = accessToken;
    current['refreshToken'] = refreshToken;
    if (expiresAtIso != null) {
      current['expiresAt'] = expiresAtIso;
    }
    await saveSessionJson(current);
  }

  Future<void> clear() => _secureStorage.delete(_sessionKey);
}
