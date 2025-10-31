import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Material 3 prensiplerine göre ay seçici widget'ı
class MonthSelectorWidget extends StatelessWidget {
  final DateTime selectedMonth;
  final Function(DateTime) onMonthChanged;
  final Locale? locale;

  const MonthSelectorWidget({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
    this.locale,
  });

  void _previousMonth() {
    final previousMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month - 1,
      1,
    );
    onMonthChanged(previousMonth);
  }

  void _nextMonth() {
    final nextMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      1,
    );
    onMonthChanged(nextMonth);
  }

  void _showMonthPicker(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, 1, 1);
    final lastDate = DateTime(now.year + 1, 12, 31);
    final initialDate = selectedMonth;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: DatePickerMode.year,
      locale: locale,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onMonthChanged(DateTime(picked.year, picked.month, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthName = DateFormat('MMMM yyyy', locale?.toString() ?? 'tr_TR')
        .format(selectedMonth);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Önceki ay butonu
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              foregroundColor: theme.colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
            ),
          ),

          // Ay ve yıl gösterimi (tıklanabilir)
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () => _showMonthPicker(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        monthName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sonraki ay butonu
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              foregroundColor: theme.colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}

