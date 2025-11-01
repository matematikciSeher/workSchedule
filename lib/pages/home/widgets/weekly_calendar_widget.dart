import 'package:flutter/material.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../shared/models/task_model.dart';

/// Material 3 prensiplerine göre haftalık takvim grid widget'ı
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
  late DateTime _displayedWeekStart;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _updateDisplayedWeek();
    _animationController.forward();
  }

  @override
  void didUpdateWidget(WeeklyCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth ||
        oldWidget.selectedDate != widget.selectedDate) {
      _updateDisplayedWeek();
      _animationController.forward(from: 0);
    }
  }

  void _updateDisplayedWeek() {
    final selected = widget.selectedDate ?? DateTime.now();
    _displayedWeekStart = selected.startOfWeek;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<DateTime> _getWeekDays() {
    final days = <DateTime>[];
    for (int i = 0; i < 7; i++) {
      days.add(_displayedWeekStart.add(Duration(days: i)));
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

  bool _isToday(DateTime date) {
    return date.isToday;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekDays = _getWeekDays();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Hafta günleri başlıkları
          Row(
            children: ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'].map((dayName) => Expanded(
                      child: Center(
                        child: Text(
                          dayName,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),

          // Haftalık takvim grid
          FadeTransition(
            opacity: _animationController,
            child: Row(
              children: weekDays.asMap().entries.map((entry) {
                final date = entry.value;
                final dayNumber = date.day;
                final isSelected = _isSelectedDate(date);
                final isToday = _isToday(date);
                final taskCount = _getTaskCountForDate(date);
                final isCurrentMonth = date.month == widget.selectedMonth.month &&
                    date.year == widget.selectedMonth.year;

                return Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 200 + (entry.key * 30)),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      // Opacity değerini 0.0-1.0 aralığına sabitle
                      final clampedOpacity = value.clamp(0.0, 1.0);
                      final clampedScale = (0.8 + (value * 0.2)).clamp(0.0, 1.0);
                      return Transform.scale(
                        scale: clampedScale,
                        child: Opacity(
                          opacity: clampedOpacity,
                          child: child,
                        ),
                      );
                    },
                    child: _CalendarDayCell(
                      dayNumber: dayNumber,
                      isSelected: isSelected,
                      isToday: isToday,
                      taskCount: taskCount,
                      isCurrentMonth: isCurrentMonth,
                      onTap: () => widget.onDateSelected(date),
                      theme: theme,
                    ),
                  ),
                );
              }).toList(),
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
  final bool isSelected;
  final bool isToday;
  final int taskCount;
  final bool isCurrentMonth;
  final VoidCallback onTap;
  final ThemeData theme;

  const _CalendarDayCell({
    required this.dayNumber,
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            // Gün numarası
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: 52,
              height: 52,
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
                        : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.5,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  dayNumber.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected || isToday
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : isToday
                            ? theme.colorScheme.onPrimaryContainer
                            : isCurrentMonth
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant
                                    .withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Görev göstergeleri
            if (taskCount > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  taskCount > 3 ? 3 : taskCount,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

