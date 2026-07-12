import 'package:flutter/material.dart';
import '../../domain/repositories/event_repository.dart';
import '../../shared/widgets/heatmap_widget.dart';
import '../../core/routes/route_generator.dart';
import '../../l10n/app_localizations.dart';

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
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _errorMessage = l10n.eventRepositoryNotFound;
            _isLoading = false;
          });
        }
        return;
      }

      final startDate = DateTime(year, 1, 1);
      final endDate = DateTime(year, 12, 31, 23, 59, 59);

      final events = await repository.getEventsByDateRange(
        startDate,
        endDate,
      );

      final counts = <DateTime, int>{};
      for (final event in events) {
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
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = l10n.eventsLoadError(e.toString());
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
    final l10n = AppLocalizations.of(context)!;
    final normalizedDate = DateTime(date.year, date.month, date.day);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${date.day}/${date.month}/${date.year}'),
        content: Text(
          l10n.eventsOnDate(_eventCounts[normalizedDate] ?? 0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yearTitle(_selectedYear)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeYear(-1),
            tooltip: l10n.previousYear,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeYear(1),
            tooltip: l10n.nextYear,
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
                        child: Text(l10n.retry),
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
