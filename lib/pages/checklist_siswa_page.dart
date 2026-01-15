import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistSiswaPage extends StatefulWidget {
  final String siswaId;
  final String nama;
  final String kelas;

  const ChecklistSiswaPage({
    super.key,
    required this.siswaId,
    required this.nama,
    required this.kelas,
  });

  @override
  State<ChecklistSiswaPage> createState() => _ChecklistSiswaPageState();
}

class _ChecklistSiswaPageState extends State<ChecklistSiswaPage> {
  late final String today;
  bool isLoading = true;
  bool isSaving = false;

  final Map<String, bool> checklist = {
    'puasa': false,
    'shubuh': false,
    'dzuhur': false,
    'ashar': false,
    'maghrib': false,
    'isya': false,
    'tarawih': false,
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    loadChecklist();
  }

  Future<void> loadChecklist() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('checklists')
          .doc(widget.siswaId)
          .collection('harian')
          .doc(today)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        for (final key in checklist.keys) {
          checklist[key] = data[key] ?? false;
        }
      }
    } catch (e) {
      debugPrint('Load checklist error: $e');
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveChecklist() async {
    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('checklists')
          .doc(widget.siswaId)
          .collection('harian')
          .doc(today)
          .set({
        ...checklist,
        'kelas': widget.kelas,
        'nama': widget.nama,
        'tanggal': today,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    }

    if (mounted) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checklist tersimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist ${widget.nama}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...checklist.keys.map((key) {
            return CheckboxListTile(
              title: Text(key.toUpperCase()),
              value: checklist[key],
              onChanged: (val) {
                setState(() => checklist[key] = val ?? false);
              },
            );
          }),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: isSaving ? null : saveChecklist,
            icon: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }
}