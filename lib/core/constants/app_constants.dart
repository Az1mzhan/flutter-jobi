class AppConstants {
  static const String appName = 'JOBI';
  static const String baseUrl = String.fromEnvironment(
    'JOBI_BASE_URL',
    defaultValue: 'https://api.jobi.kz/v1',
  );
  static const String websocketUrl = String.fromEnvironment(
    'JOBI_WS_URL',
    defaultValue: 'wss://api.jobi.kz/ws',
  );

  // Switch this off when the real backend contracts are wired in.
  static const bool useMockData = bool.fromEnvironment(
    'JOBI_USE_MOCKS',
    defaultValue: true,
  );

  static const Duration mockDelay = Duration(milliseconds: 650);
  static const int defaultPageSize = 10;
}
