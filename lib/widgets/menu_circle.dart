import 'package:flutter/material.dart';

class MenuCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuCircle({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.green.shade100,
            child: Icon(icon, size: 30, color: Colors.green.shade800),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
