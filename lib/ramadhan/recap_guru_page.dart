import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecapGuruPage extends StatefulWidget {
  const RecapGuruPage({super.key});

  @override
  State<RecapGuruPage> createState() => _RecapGuruPageState();
}

class _RecapGuruPageState extends State<RecapGuruPage> {
  String selectedKelas = '';
  DateTime? selectedTanggal;

  @override
  Widget build(BuildContext context) {
    String? tanggalFilter =
        selectedTanggal?.toString().substring(0, 10);

    Query query =
        FirebaseFirestore.instance.collection('ramadhan_checklist');

    if (selectedKelas.isNotEmpty) {
      query = query.where('kelas', isEqualTo: selectedKelas);
    }
    if (tanggalFilter != null) {
      query = query.where('tanggal', isEqualTo: tanggalFilter);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rekap Ibadah Siswa"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ================= FILTER CARD =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 3, // ✅ ELEVATION BENAR
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Filter Kelas",
                        border: OutlineInputBorder(),
                      ),
                      items: ['1A', '1B', '2A', '2B']
                          .map(
                            (k) => DropdownMenuItem(
                              value: k,
                              child: Text(k),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedKelas = v ?? ''),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          selectedTanggal == null
                              ? "Pilih Tanggal"
                              : tanggalFilter!,
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2030),
                            initialDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedTanggal = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= DATA LIST =================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("Data tidak ditemukan"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i];

                    return Card(
                      elevation: 2, // ✅ ELEVATION PER ITEM
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          "${d['nama']} (${d['kelas']})",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Puasa: ${d['puasa'] ? 'Ya' : 'Tidak'} | "
                            "Sholat: ${d['sholat'] ? 'Ya' : 'Tidak'} | "
                            "Tarawih: ${d['tarawih'] ? 'Ya' : 'Tidak'}",
                          ),
                        ),
                        trailing: Text(
                          d['tanggal'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
