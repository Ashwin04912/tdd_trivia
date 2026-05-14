/// Central place for all app-wide constants.
/// Change the base URL here and every datasource picks it up automatically.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── API ──────────────────────────────────────────────────────────────────
  static const String baseUrl =
      'https://trivia-number-joy.lovable.app/api/trivia';

  static String concreteNumberUrl(int number) => '$baseUrl/$number';
  static const String randomNumberUrl = '$baseUrl/random';

  // ── HTTP headers ─────────────────────────────────────────────────────────
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };
}
