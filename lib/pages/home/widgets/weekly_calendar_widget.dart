import 'package:flutter/material.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../shared/models/task_model.dart';

/// Seçili ayın tamamını gösteren kompakt takvim grid widget'ı
class WeeklyCalendarWidget extends StatefulWidget {
  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final List<TaskModel> tasks;
  final Locale? locale;

  const WeeklyCalendarWidget({
    super.key,
    required this.selectedMonth,
    this.selectedDate,
    required this.onDateSelected,
    this.tasks = const [],
    this.locale,
  });

  @override
  State<WeeklyCalendarWidget> createState() => _WeeklyCalendarWidgetState();
}

class _WeeklyCalendarWidgetState extends State<WeeklyCalendarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  static const _dayLabels = ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'];
  static const _cellSize = 34.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(WeeklyCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth ||
        oldWidget.selectedDate != widget.selectedDate) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<DateTime> _getMonthDays() {
    final firstOfMonth = DateTime(
      widget.selectedMonth.year,
      widget.selectedMonth.month,
      1,
    );
    final gridStart = firstOfMonth.startOfWeek;
    final lastOfMonth = DateTime(
      widget.selectedMonth.year,
      widget.selectedMonth.month + 1,
      0,
    );
    final gridEnd = lastOfMonth.endOfWeek;

    final days = <DateTime>[];
    var current = gridStart;
    while (!current.isAfter(gridEnd)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  int _getTaskCountForDate(DateTime date) {
    return widget.tasks
        .where((task) => task.isOnDate(date) && !task.isCompleted)
        .length;
  }

  bool _isSelectedDate(DateTime date) {
    if (widget.selectedDate == null) return false;
    return date.year == widget.selectedDate!.year &&
        date.month == widget.selectedDate!.month &&
        date.day == widget.selectedDate!.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthDays = _getMonthDays();
    final weekCount = monthDays.length ~/ 7;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: _dayLabels
                .map(
                  (dayName) => Expanded(
                    child: Center(
                      child: Text(
                        dayName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 6),
          FadeTransition(
            opacity: _animationController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(weekCount, (weekIndex) {
                return Padding(
                  padding: EdgeInsets.only(bottom: weekIndex < weekCount - 1 ? 2 : 0),
                  child: Row(
                    children: List.generate(7, (dayIndex) {
                      final index = weekIndex * 7 + dayIndex;
                      final date = monthDays[index];
                      final isCurrentMonth =
                          date.month == widget.selectedMonth.month &&
                              date.year == widget.selectedMonth.year;

                      return Expanded(
                        child: _CalendarDayCell(
                          dayNumber: date.day,
                          cellSize: _cellSize,
                          isSelected: _isSelectedDate(date),
                          isToday: date.isToday,
                          taskCount: _getTaskCountForDate(date),
                          isCurrentMonth: isCurrentMonth,
                          onTap: () => widget.onDateSelected(date),
                          theme: theme,
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tek bir takvim günü hücresi
class _CalendarDayCell extends StatelessWidget {
  final int dayNumber;
  final double cellSize;
  final bool isSelected;
  final bool isToday;
  final int taskCount;
  final bool isCurrentMonth;
  final VoidCallback onTap;
  final ThemeData theme;

  const _CalendarDayCell({
    required this.dayNumber,
    required this.cellSize,
    required this.isSelected,
    required this.isToday,
    required this.taskCount,
    required this.isCurrentMonth,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: cellSize + 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.tertiary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected
                    ? null
                    : isToday
                        ? theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.7)
                        : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  dayNumber.toString(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight:
                        isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : isToday
                            ? theme.colorScheme.onPrimaryContainer
                            : isCurrentMonth
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
            if (taskCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    taskCount > 3 ? 3 : taskCount,
                    (_) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
