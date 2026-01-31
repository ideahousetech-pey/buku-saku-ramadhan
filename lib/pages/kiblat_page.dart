import 'package:flutter/material.dart';

class KiblatPage extends StatelessWidget {
  const KiblatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kiblat")),
      body: const Center(child: Text("Arah Kiblat")),
    );
  }
}
