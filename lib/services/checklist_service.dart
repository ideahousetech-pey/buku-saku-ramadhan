import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistService {
  static final _db = FirebaseFirestore.instance;

  /// 🔍 Cek apakah siswa sudah isi hari ini
  static Future<bool> sudahIsiHariIni({
    required String userId,
    required String tanggal,
  }) async {
    final query = await _db
        .collection('ramadhan_checklist')
        .where('userId', isEqualTo: userId)
        .where('tanggal', isEqualTo: tanggal)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  /// 💾 Simpan checklist
  static Future<void> simpanChecklist({
    required String userId,
    required String nama,
    required String kelas,
    required bool puasa,
    required bool sholat,
    required bool tarawih,
    required String tanggal,
  }) async {
    await _db.collection('ramadhan_checklist').add({
      'userId': userId,
      'nama': nama,
      'kelas': kelas,
      'puasa': puasa,
      'sholat': sholat,
      'tarawih': tarawih,
      'tanggal': tanggal, // format: YYYY-MM-DD
      'isLocked': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
