class AuthService {
  static String? _nama;
  static String? _kelas;

  static bool get isLoggedIn => _nama != null;

  static String get nama => _nama ?? '';
  static String get kelas => _kelas ?? '';

  static Future<bool> login(
    String nama,
    String kelas,
    String password,
  ) async {
    if (nama.isEmpty || password.isEmpty) return false;

    _nama = nama;
    _kelas = kelas;
    return true;
  }

  static void logout() {
    _nama = null;
    _kelas = null;
  }
}
