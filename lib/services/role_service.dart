import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoleService {
  static Future<bool> isGuru() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return false;

    return doc.data()?['role'] == 'guru';
  }
}
