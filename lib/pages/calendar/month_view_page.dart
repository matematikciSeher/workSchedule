import 'package:flutter/material.dart';
import '../../shared/widgets/decorative_background.dart';

class MonthViewPage extends StatefulWidget {
  const MonthViewPage({super.key});

  @override
  State<MonthViewPage> createState() => _MonthViewPageState();
}

class _MonthViewPageState extends State<MonthViewPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_selectedDate.year} ${_getMonthName(_selectedDate.month)}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: DecorativeBackground(
        style: BackgroundStyle.vibrant,
        child: Center(
          child: Text(
            'Ay Görünümü',
            style: theme.textTheme.headlineMedium,
          ),
        ),
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

