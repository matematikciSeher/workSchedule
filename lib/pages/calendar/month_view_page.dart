import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/extensions/locale_extensions.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final localeStr = context.dateFormatLocale;
    final title = DateFormat('MMMM yyyy', localeStr).format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
            l10n.monthView,
            style: theme.textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
