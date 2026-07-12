import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/extensions/locale_extensions.dart';
import '../../l10n/app_localizations.dart';

/// GitHub contributions graph benzeri ısı haritası widget'ı
/// Yıllık etkinlik yoğunluğunu görselleştirir
class HeatmapWidget extends StatelessWidget {
  final int year;
  final Map<DateTime, int> eventCounts;
  final Function(DateTime)? onDayTap;
  final double cellSize;
  final double spacing;

  const HeatmapWidget({
    super.key,
    required this.year,
    required this.eventCounts,
    this.onDayTap,
    this.cellSize = 12.0,
    this.spacing = 3.0,
  });

  Color _getIntensityColor(int count, int maxCount) {
    if (count == 0) return Colors.grey[200]!;
    
    final intensity = (count / (maxCount / 4)).clamp(0.0, 4.0).floor();
    
    switch (intensity) {
      case 0:
        return Colors.blue[100]!;
      case 1:
        return Colors.blue[300]!;
      case 2:
        return Colors.blue[500]!;
      case 3:
        return Colors.blue[700]!;
      default:
        return Colors.blue[900]!;
    }
  }

  List<List<DateTime?>> _generateYearDays() {
    final days = <List<DateTime?>>[];
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);
    
    int firstDayOfWeek = startDate.weekday % 7;
    
    final firstWeek = <DateTime?>[];
    for (int i = 0; i < firstDayOfWeek; i++) {
      firstWeek.add(null);
    }
    
    DateTime currentDate = startDate;
    
    while (currentDate.isBefore(endDate) || 
           currentDate.isAtSameMomentAs(endDate)) {
      if (firstWeek.length == 7) {
        days.add(List.from(firstWeek));
        firstWeek.clear();
      }
      
      firstWeek.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    while (firstWeek.length < 7) {
      firstWeek.add(null);
    }
    if (firstWeek.any((day) => day != null)) {
      days.add(firstWeek);
    }
    
    return days;
  }

  Map<int, int> _getMonthPositions() {
    final monthPositions = <int, int>{};
    final startDate = DateTime(year, 1, 1);
    
    for (int month = 1; month <= 12; month++) {
      final monthStart = DateTime(year, month, 1);
      final daysDiff = monthStart.difference(startDate).inDays;
      final firstDayOfWeek = startDate.weekday % 7;
      final weekPosition = ((daysDiff + firstDayOfWeek) / 7).floor();
      
      if (!monthPositions.containsKey(month)) {
        monthPositions[month] = weekPosition;
      }
    }
    
    return monthPositions;
  }

  String _dayLabel(int weekdayMon0, String localeStr) {
    final date = DateTime(2024, 1, 1 + weekdayMon0);
    return DateFormat('EEE', localeStr).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeStr = context.dateFormatLocale;
    final yearDays = _generateYearDays();
    final maxCount = eventCounts.values.isEmpty 
        ? 1 
        : eventCounts.values.reduce((a, b) => a > b ? a : b);
    final monthPositions = _getMonthPositions();
    const dayLabelRows = [0, 2, 4, 6];
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yearEventDensity(year),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.heatmapSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    ...dayLabelRows.map((rowIndex) {
                      return Container(
                        width: 40,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          _dayLabel(rowIndex, localeStr),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(width: 8),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      width: (cellSize + spacing) * yearDays.length.toDouble(),
                      child: Stack(
                        children: List.generate(12, (index) {
                          final month = index + 1;
                          final position = monthPositions[month] ?? 0;
                          final monthLabel = DateFormat('MMM', localeStr)
                              .format(DateTime(year, month, 1));
                          return Positioned(
                            left: position * (cellSize + spacing),
                            child: Text(
                              monthLabel,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    ...yearDays.map((week) {
                      return Row(
                        children: week.map((day) {
                          if (day == null) {
                            return SizedBox(
                              width: cellSize,
                              height: cellSize,
                            );
                          }
                          
                          final normalizedDate = DateTime(day.year, day.month, day.day);
                          final count = eventCounts[normalizedDate] ?? 0;
                          final color = _getIntensityColor(count, maxCount);
                          final dateLabel = DateFormat('d/M/yyyy', localeStr).format(day);
                          
                          return GestureDetector(
                            onTap: onDayTap != null 
                                ? () => onDayTap!(normalizedDate)
                                : null,
                            child: Tooltip(
                              message: '$dateLabel\n${l10n.eventsCount(count)}',
                              child: Container(
                                width: cellSize,
                                height: cellSize,
                                margin: EdgeInsets.all(spacing / 2),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Text(
                l10n.heatmapLegendLess,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              _buildLegendItem(Colors.blue[100]!),
              _buildLegendItem(Colors.blue[300]!),
              _buildLegendItem(Colors.blue[500]!),
              _buildLegendItem(Colors.blue[700]!),
              _buildLegendItem(Colors.blue[900]!),
              const SizedBox(width: 8),
              Text(
                l10n.heatmapLegendMore,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color) {
    return Container(
      width: cellSize,
      height: cellSize,
      margin: EdgeInsets.all(spacing / 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 0.5,
        ),
      ),
    );
  }
}
