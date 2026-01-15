import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RekapGuruPage extends StatelessWidget {
  final String kelas;

  const RekapGuruPage({super.key, required this.kelas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rekap Kelas $kelas')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('kelas', isEqualTo: kelas)
            .where('role', isEqualTo: 'siswa')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final siswa = snapshot.data!.docs;

          return ListView.builder(
            itemCount: siswa.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(siswa[i]['nama']),
                subtitle: Text('Checklist hari ini'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // detail checklist (opsional)
                },
              );
            },
          );
        },
      ),
    );
  }
}
