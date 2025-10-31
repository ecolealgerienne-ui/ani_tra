/// Mock d'authentification PIN — toujours activé, PIN = 1234.
/// Aucune dépendance réseau, compatible Flutter Web (pas de sleep).
class MockAuth {
  static const String defaultPin = '1234';

  static Future<bool> verifyPin(String pin) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return pin == defaultPin;
  }
}
