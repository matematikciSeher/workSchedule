import 'package:flutter/material.dart';

class YearViewPage extends StatefulWidget {
  const YearViewPage({super.key});

  @override
  State<YearViewPage> createState() => _YearViewPageState();
}

class _YearViewPageState extends State<YearViewPage> {
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_selectedYear Yılı'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Yıl Görünümü'),
      ),
    );
  }
}

