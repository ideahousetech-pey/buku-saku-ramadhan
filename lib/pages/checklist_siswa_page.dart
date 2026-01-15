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
  final today =
      DateTime.now().toIso8601String().substring(0, 10);

  final Map<String, bool> checklist = {
    'puasa': false,
    'shubuh': false,
    'dzuhur': false,
    'ashar': false,
    'maghrib': false,
    'isya': false,
    'tarawih': false,
  };

  Future<void> saveChecklist() async {
    await FirebaseFirestore.instance
        .collection('checklists')
        .doc(widget.siswaId)
        .collection('harian')
        .doc(today)
        .set(checklist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checklist ${widget.nama}')),
      body: ListView(
        children: checklist.keys.map((key) {
          return CheckboxListTile(
            title: Text(key.toUpperCase()),
            value: checklist[key],
            onChanged: (val) {
              setState(() => checklist[key] = val!);
              saveChecklist();
            },
          );
        }).toList(),
      ),
    );
  }
}
