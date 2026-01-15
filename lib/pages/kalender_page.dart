import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  DateTime focusedDay = DateTime.now();

  final Map<DateTime, String> events = {};

  @override
  void initState() {
    super.initState();
    _initRamadhanEvents();
  }

  void _initRamadhanEvents() {
    for (int i = 1; i <= 30; i++) {
      final date = DateTime(DateTime.now().year, 3, i);
      events[date] = "Puasa Ramadhan hari ke-$i";
    }
  }

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.fromDate(focusedDay);

    return Scaffold(
      appBar: AppBar(title: const Text("Kalender Hijriah")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} H",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) => events.containsKey(day)
                ? [events[day]!]
                : [],
            onDaySelected: (selected, focused) {
              setState(() => focusedDay = selected);
              if (events.containsKey(selected)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(events[selected]!)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
