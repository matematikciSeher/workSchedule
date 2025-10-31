import 'package:flutter/material.dart';

class WeekViewPage extends StatefulWidget {
  const WeekViewPage({super.key});

  @override
  State<WeekViewPage> createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage> {
  DateTime _selectedWeek = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hafta: ${_getWeekRange(_selectedWeek)}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Hafta Görünümü'),
      ),
    );
  }

  String _getWeekRange(DateTime date) {
    // Haftanın ilk gününü bul (Pazartesi)
    final firstDay = date.subtract(Duration(days: date.weekday - 1));
    final lastDay = firstDay.add(const Duration(days: 6));
    return '${firstDay.day}.${firstDay.month} - ${lastDay.day}.${lastDay.month}.${lastDay.year}';
  }
}

