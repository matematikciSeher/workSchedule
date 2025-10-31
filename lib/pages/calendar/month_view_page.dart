import 'package:flutter/material.dart';

class MonthViewPage extends StatefulWidget {
  const MonthViewPage({super.key});

  @override
  State<MonthViewPage> createState() => _MonthViewPageState();
}

class _MonthViewPageState extends State<MonthViewPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_selectedDate.year} ${_getMonthName(_selectedDate.month)}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Ay Görünümü'),
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

