import 'package:flutter/material.dart';

class DayViewPage extends StatefulWidget {
  const DayViewPage({super.key});

  @override
  State<DayViewPage> createState() => _DayViewPageState();
}

class _DayViewPageState extends State<DayViewPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Gün Görünümü'),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return months[month - 1];
  }
}

