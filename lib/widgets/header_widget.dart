import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback onLoginGuru;

  const HeaderWidget({super.key, required this.onLoginGuru});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hijri = HijriCalendar.now();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('EEE, dd MMM yyyy').format(now),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                  "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} AH",
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14)),
            ],
          ),
          ElevatedButton(
            onPressed: onLoginGuru,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Login Guru"),
          )
        ],
      ),
    );
  }
}
