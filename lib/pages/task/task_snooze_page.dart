import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/services/notification_action_handler.dart';
import '../../data/local/database_helper.dart';
import '../../domain/entities/task_entity.dart';
import '../../features/task/data/datasources/task_local_datasource.dart';
import '../../features/task/data/repositories/task_repository_impl.dart';
import '../../shared/widgets/decorative_background.dart';

class TaskSnoozePage extends StatefulWidget {
  final String taskId;

  const TaskSnoozePage({super.key, required this.taskId});

  @override
  State<TaskSnoozePage> createState() => _TaskSnoozePageState();
}

enum _QuickSnooze { min15, min30, hour1, hour3, tomorrow }

class _TaskSnoozePageState extends State<TaskSnoozePage> {
  TaskEntity? _task;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  _QuickSnooze? _selectedQuickOption;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    try {
      final repository = TaskRepositoryImpl(
        TaskLocalDataSource(DatabaseHelper.instance),
      );
      final task = await repository.getTaskById(widget.taskId);
      if (!mounted) return;

      if (task == null) {
        setState(() {
          _isLoading = false;
          _error = 'Görev bulunamadı';
        });
        return;
      }

      final initial = _initialSnoozeDateTime(task);
      setState(() {
        _task = task;
        _selectedDate = DateTime(initial.year, initial.month, initial.day);
        _selectedTime = TimeOfDay(hour: initial.hour, minute: initial.minute);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Görev yüklenemedi';
      });
    }
  }

  DateTime _initialSnoozeDateTime(TaskEntity task) {
    final now = DateTime.now();
    final base = task.dueDate ?? now;
    final candidate = base.isAfter(now)
        ? base.add(const Duration(minutes: 30))
        : now.add(const Duration(minutes: 30));
    return candidate;
  }

  DateTime? _buildSnoozeDateTime() {
    if (_selectedDate == null || _selectedTime == null) return null;
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  void _setSnoozeDateTime(DateTime target, {_QuickSnooze? quickOption}) {
    setState(() {
      _selectedQuickOption = quickOption;
      _selectedDate = DateTime(target.year, target.month, target.day);
      _selectedTime = TimeOfDay(hour: target.hour, minute: target.minute);
    });
  }

  void _applyQuickSnooze(_QuickSnooze option) {
    final now = DateTime.now();
    final DateTime target;

    switch (option) {
      case _QuickSnooze.min15:
        target = now.add(const Duration(minutes: 15));
      case _QuickSnooze.min30:
        target = now.add(const Duration(minutes: 30));
      case _QuickSnooze.hour1:
        target = now.add(const Duration(hours: 1));
      case _QuickSnooze.hour3:
        target = now.add(const Duration(hours: 3));
      case _QuickSnooze.tomorrow:
        final timeSource = _task?.dueDate ?? now;
        final tomorrow = now.add(const Duration(days: 1));
        target = DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
          timeSource.hour,
          timeSource.minute,
        );
    }

    _setSnoozeDateTime(target, quickOption: option);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) {
      final time = _selectedTime ?? TimeOfDay.now();
      _setSnoozeDateTime(
        DateTime(picked.year, picked.month, picked.day, time.hour, time.minute),
      );
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      final date = _selectedDate ?? DateTime.now();
      _setSnoozeDateTime(
        DateTime(date.year, date.month, date.day, picked.hour, picked.minute),
      );
    }
  }

  Widget _quickSnoozeChip(String label, _QuickSnooze option) {
    return FilterChip(
      label: Text(label),
      selected: _selectedQuickOption == option,
      onSelected: _isSaving ? null : (_) => _applyQuickSnooze(option),
    );
  }

  Future<void> _snooze() async {
    final task = _task;
    if (task == null) return;

    final newDueDate = _buildSnoozeDateTime();
    if (newDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tarih ve saat seçin')),
      );
      return;
    }

    if (!newDueDate.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erteleme zamanı gelecekte olmalı')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await NotificationActionHandler.snoozeTaskToDateTime(task, newDueDate);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erteleme başarısız: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMMM yyyy', 'tr_TR');
    final snoozeDateTime = _buildSnoozeDateTime();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ertele'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: DecorativeBackground(
        style: BackgroundStyle.calm,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _task!.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_task!.dueDate != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Mevcut vade: ${DateFormat('d MMM yyyy HH:mm', 'tr_TR').format(_task!.dueDate!)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Hızlı seçenekler',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _quickSnoozeChip('15 dk', _QuickSnooze.min15),
                          _quickSnoozeChip('30 dk', _QuickSnooze.min30),
                          _quickSnoozeChip('1 saat', _QuickSnooze.hour1),
                          _quickSnoozeChip('3 saat', _QuickSnooze.hour3),
                          _quickSnoozeChip('Yarın', _QuickSnooze.tomorrow),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Özel tarih ve saat',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        title: const Text('Tarih'),
                        subtitle: Text(
                          _selectedDate == null
                              ? 'Tarih seçilmedi'
                              : dateFormat.format(_selectedDate!),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _selectDate,
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        title: const Text('Saat'),
                        subtitle: Text(
                          _selectedTime == null
                              ? 'Saat seçilmedi'
                              : _selectedTime!.format(context),
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: _selectTime,
                      ),
                      if (snoozeDateTime != null) ...[
                        const SizedBox(height: 16),
                        Card(
                          color: theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.35),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Yeni hatırlatma: ${DateFormat('d MMM yyyy HH:mm', 'tr_TR').format(snoozeDateTime)}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _isSaving ? null : _snooze,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Ertele'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
