class RamadhanEvent {
  final int hijriDay;
  final int hijriMonth;
  final String title;

  RamadhanEvent({
    required this.hijriDay,
    required this.hijriMonth,
    required this.title,
  });
}

final List<RamadhanEvent> ramadhanEvents = [
  RamadhanEvent(hijriDay: 1, hijriMonth: 9, title: "Awal Ramadhan"),
  RamadhanEvent(hijriDay: 17, hijriMonth: 9, title: "Nuzulul Qur'an"),
  RamadhanEvent(hijriDay: 27, hijriMonth: 9, title: "Lailatul Qadar"),
  RamadhanEvent(hijriDay: 1, hijriMonth: 10, title: "Idul Fitri"),
];
