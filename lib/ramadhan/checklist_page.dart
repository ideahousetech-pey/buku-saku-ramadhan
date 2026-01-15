import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/checklist_service.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final namaController = TextEditingController();
  final kelasController = TextEditingController();

  bool puasa = false;
  bool sholat = false;
  bool tarawih = false;
  bool isLocked = false;
  bool isLoading = false;

  @override
  void dispose() {
    namaController.dispose();
    kelasController.dispose();
    super.dispose();
  }

  Future<void> submitChecklist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now().toString().substring(0, 10);

    if (namaController.text.isEmpty || kelasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan kelas wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    final sudahIsi = await ChecklistService.sudahIsiHariIni(
      userId: user.uid,
      tanggal: today,
    );

    if (sudahIsi) {
      setState(() {
        isLocked = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Checklist hari ini sudah dikirim")),
      );
      return;
    }

    await ChecklistService.simpanChecklist(
      userId: user.uid,
      nama: namaController.text,
      kelas: kelasController.text,
      puasa: puasa,
      sholat: sholat,
      tarawih: tarawih,
      tanggal: today,
    );

    setState(() {
      isLocked = true;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Checklist berhasil disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checklist Ramadhan"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3, // ✅ ELEVATION DI SINI (BENAR)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Identitas Siswa",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: namaController,
                  enabled: !isLocked,
                  decoration: const InputDecoration(
                    labelText: "Nama Siswa",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: kelasController,
                  enabled: !isLocked,
                  decoration: const InputDecoration(
                    labelText: "Kelas",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),

                const Text(
                  "Checklist Ibadah",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                CheckboxListTile(
                  title: const Text("Puasa"),
                  value: puasa,
                  onChanged:
                      isLocked ? null : (v) => setState(() => puasa = v!),
                ),
                CheckboxListTile(
                  title: const Text("Sholat 5 Waktu"),
                  value: sholat,
                  onChanged:
                      isLocked ? null : (v) => setState(() => sholat = v!),
                ),
                CheckboxListTile(
                  title: const Text("Tarawih"),
                  value: tarawih,
                  onChanged:
                      isLocked ? null : (v) => setState(() => tarawih = v!),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        isLocked || isLoading ? null : submitChecklist,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Kirim Checklist",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
