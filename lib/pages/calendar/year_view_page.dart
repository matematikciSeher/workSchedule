import 'package:flutter/material.dart';
import '../../domain/repositories/event_repository.dart';
import '../../shared/widgets/heatmap_widget.dart';
import '../../core/routes/route_generator.dart';

class YearViewPage extends StatefulWidget {
  final EventRepository? eventRepository;

  const YearViewPage({
    super.key,
    this.eventRepository,
  });

  @override
  State<YearViewPage> createState() => _YearViewPageState();
}

class _YearViewPageState extends State<YearViewPage> {
  int _selectedYear = DateTime.now().year;
  Map<DateTime, int> _eventCounts = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEventsForYear(_selectedYear);
  }

  Future<void> _loadEventsForYear(int year) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = widget.eventRepository ?? _getDefaultRepository();
      if (repository == null) {
        setState(() {
          _errorMessage = 'Event repository bulunamadı';
          _isLoading = false;
        });
        return;
      }

      final startDate = DateTime(year, 1, 1);
      final endDate = DateTime(year, 12, 31, 23, 59, 59);

      final events = await repository.getEventsByDateRange(
        startDate,
        endDate,
      );

      // Etkinlikleri tarihe göre grupla ve say
      final counts = <DateTime, int>{};
      for (final event in events) {
        // Etkinliğin tüm günlerini işle
        final start = DateTime(
          event.startDate.year,
          event.startDate.month,
          event.startDate.day,
        );
        final end = DateTime(
          event.endDate.year,
          event.endDate.month,
          event.endDate.day,
        );

        DateTime currentDate = start;
        while (!currentDate.isAfter(end)) {
          final normalizedDate = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
          );
          counts[normalizedDate] = (counts[normalizedDate] ?? 0) + 1;
          currentDate = currentDate.add(const Duration(days: 1));
        }
      }

      if (mounted) {
        setState(() {
          _eventCounts = counts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Etkinlikler yüklenirken hata oluştu: $e';
          _isLoading = false;
        });
      }
    }
  }

  EventRepository? _getDefaultRepository() {
    try {
      return RouteGenerator.createEventRepository();
    } catch (e) {
      return null;
    }
  }

  void _changeYear(int delta) {
    setState(() {
      _selectedYear += delta;
    });
    _loadEventsForYear(_selectedYear);
  }

  void _onDayTap(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${date.day}/${date.month}/${date.year}'),
        content: Text(
          'Bu tarihte ${_eventCounts[date] ?? 0} etkinlik var.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_selectedYear Yılı'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeYear(-1),
            tooltip: 'Önceki yıl',
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeYear(1),
            tooltip: 'Sonraki yıl',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _loadEventsForYear(_selectedYear),
                        child: const Text('Yeniden Dene'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _loadEventsForYear(_selectedYear),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: HeatmapWidget(
                      year: _selectedYear,
                      eventCounts: _eventCounts,
                      onDayTap: _onDayTap,
                    ),
                  ),
                ),
    );
  }
}

