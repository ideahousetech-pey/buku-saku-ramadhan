class JurnalService {
  static final Map<String, Map<String, dynamic>> _db = {};

  static void save(
    String siswa,
    String date,
    Map<String, dynamic> data,
  ) {
    _db["$siswa-$date"] = Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic>? get(
    String siswa,
    String date,
  ) {
    return _db["$siswa-$date"];
  }

  static Map<String, Map<String, dynamic>> getAll() {
    return _db;
  }
}
