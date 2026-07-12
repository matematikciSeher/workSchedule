import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/extensions/locale_extensions.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/decorative_background.dart';

class WeekViewPage extends StatefulWidget {
  const WeekViewPage({super.key});

  @override
  State<WeekViewPage> createState() => _WeekViewPageState();
}

class _WeekViewPageState extends State<WeekViewPage> {
  DateTime _selectedWeek = DateTime.now();

  String _getWeekRange(DateTime date, String localeStr) {
    final firstDay = date.subtract(Duration(days: date.weekday - 1));
    final lastDay = firstDay.add(const Duration(days: 6));
    final start = DateFormat('d.M', localeStr).format(firstDay);
    final end = DateFormat('d.M.yyyy', localeStr).format(lastDay);
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final localeStr = context.dateFormatLocale;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.weekPrefix}${_getWeekRange(_selectedWeek, localeStr)}'),
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
            l10n.weekView,
            style: theme.textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
