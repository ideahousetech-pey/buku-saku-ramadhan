import 'package:flutter/material.dart';

class SholatPage extends StatelessWidget {
  final Map<String, String> times;
  const SholatPage({super.key, required this.times});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Sholat")),
      body: ListView(
        children: times.entries.map((e) {
          return ListTile(
            title: Text(e.key),
            trailing: Text(
              e.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }
}
