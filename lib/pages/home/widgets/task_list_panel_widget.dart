import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../shared/models/task_model.dart';

/// Material 3 prensiplerine göre görev listesi panel widget'ı
class TaskListPanelWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final List<TaskModel> tasks;
  final Function(TaskModel) onTaskTap;
  final Function(TaskModel) onTaskToggle;
  final Function(TaskModel)? onTaskDelete;
  final Locale? locale;
  final bool neverScroll;

  const TaskListPanelWidget({
    super.key,
    this.selectedDate,
    this.tasks = const [],
    required this.onTaskTap,
    required this.onTaskToggle,
    this.onTaskDelete,
    this.locale,
    this.neverScroll = false,
  });

  List<TaskModel> _getTasksForDate() {
    if (selectedDate == null) return [];
    return tasks
        .where((task) => task.isOnDate(selectedDate!))
        .toList()
      ..sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        }
        return 0;
      });
  }

  String _getDateTitle() {
    if (selectedDate == null) return 'Bir gün seçin';
    final date = selectedDate!;
    final localeStr = locale?.toString() ?? 'tr_TR';

    if (date.isToday) return 'Bugün';
    if (date.isTomorrow) return 'Yarın';
    if (date.isYesterday) return 'Dün';
    return DateFormat('EEEE, d MMMM', localeStr).format(date);
  }

  String? _getDateSubtitle(int totalTasks, int completedTasks) {
    if (selectedDate == null) return null;
    if (totalTasks > 0) {
      final pending = totalTasks - completedTasks;
      if (pending == 0) return 'Tüm görevler tamamlandı';
      return '$pending bekleyen • $completedTasks tamamlandı';
    }
    final localeStr = locale?.toString() ?? 'tr_TR';
    return DateFormat('d MMMM yyyy', localeStr).format(selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateTasks = _getTasksForDate();
    final completedTasks = dateTasks.where((t) => t.isCompleted).length;
    final totalTasks = dateTasks.length;

    if (neverScroll) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            theme: theme,
            title: _getDateTitle(),
            subtitle: _getDateSubtitle(totalTasks, completedTasks),
            totalTasks: totalTasks,
            completedTasks: completedTasks,
            selectedDate: selectedDate,
          ),
          const SizedBox(height: 12),
          _buildTaskContent(
            context,
            theme,
            dateTasks,
            neverScroll: true,
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHandle(theme: theme),
          _PanelHeader(
            theme: theme,
            title: _getDateTitle(),
            subtitle: _getDateSubtitle(totalTasks, completedTasks),
            totalTasks: totalTasks,
            completedTasks: completedTasks,
            selectedDate: selectedDate,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildScrollableContent(context, theme, dateTasks),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContent(
    BuildContext context,
    ThemeData theme,
    List<TaskModel> dateTasks,
  ) {
    if (selectedDate == null) {
      return _EmptyState(
        theme: theme,
        icon: Icons.touch_app_outlined,
        title: 'Bir gün seçin',
        subtitle: 'Takvimden bir tarihe dokunarak görevlerinizi görüntüleyin',
      );
    }

    if (dateTasks.isEmpty) {
      return _EmptyState(
        theme: theme,
        icon: Icons.event_available_outlined,
        title: 'Bu güne ait görev yok',
        subtitle: 'Yeni görev eklemek için + butonuna dokunun',
      );
    }

    return _TaskListView(
      dateTasks: dateTasks,
      theme: theme,
      selectedDate: selectedDate!,
      onTaskTap: onTaskTap,
      onTaskToggle: onTaskToggle,
      onTaskDelete: onTaskDelete,
    );
  }

  Widget _buildTaskContent(
    BuildContext context,
    ThemeData theme,
    List<TaskModel> dateTasks, {
    required bool neverScroll,
  }) {
    if (selectedDate == null) {
      return _EmptyState(
        theme: theme,
        icon: Icons.touch_app_outlined,
        title: 'Bir gün seçin',
        subtitle: 'Takvimden bir tarihe dokunarak görevlerinizi görüntüleyin',
      );
    }

    if (dateTasks.isEmpty) {
      return _EmptyState(
        theme: theme,
        icon: Icons.event_available_outlined,
        title: 'Bu güne ait görev yok',
        subtitle: 'Yeni görev eklemek için + butonuna dokunun',
      );
    }

    if (neverScroll) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: dateTasks.asMap().entries.expand((entry) {
            final index = entry.key;
            final task = entry.value;
            return [
              if (index > 0)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 36,
                  color: theme.colorScheme.outlineVariant
                      .withValues(alpha: 0.35),
                ),
              _TaskListItem(
                task: task,
                selectedDate: selectedDate,
                onTap: () => onTaskTap(task),
                onToggle: () => onTaskToggle(task),
                onDelete:
                    onTaskDelete != null ? () => onTaskDelete!(task) : null,
                theme: theme,
              ),
            ];
          }).toList(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _PanelHandle extends StatelessWidget {
  const _PanelHandle({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 6),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.totalTasks,
    required this.completedTasks,
    required this.selectedDate,
  });

  final ThemeData theme;
  final String title;
  final String? subtitle;
  final int totalTasks;
  final int completedTasks;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    final isToday = selectedDate?.isToday ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (selectedDate != null) ...[
            _DateBadge(date: selectedDate!, theme: theme, isToday: isToday),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Bugün',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (totalTasks > 0) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            backgroundColor: theme.colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.8),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress == 1.0
                                  ? theme.colorScheme.tertiary
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$completedTasks/$totalTasks',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({
    required this.date,
    required this.theme,
    required this.isToday,
  });

  final DateTime date;
  final ThemeData theme;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final localeStr = 'tr_TR';
    final dayName = DateFormat('EEE', localeStr).format(date).toUpperCase();

    return Container(
      width: 52,
      height: 58,
      decoration: BoxDecoration(
        gradient: isToday
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
              )
            : null,
        color: isToday
            ? null
            : theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: isToday
            ? null
            : Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isToday
                  ? theme.colorScheme.onPrimary.withValues(alpha: 0.85)
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '${date.day}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: isToday
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final ThemeData theme;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 34,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskListView extends StatelessWidget {
  const _TaskListView({
    required this.dateTasks,
    required this.theme,
    required this.selectedDate,
    required this.onTaskTap,
    required this.onTaskToggle,
    this.onTaskDelete,
  });

  final List<TaskModel> dateTasks;
  final ThemeData theme;
  final DateTime selectedDate;
  final Function(TaskModel) onTaskTap;
  final Function(TaskModel) onTaskToggle;
  final Function(TaskModel)? onTaskDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 12, 16),
      physics: const BouncingScrollPhysics(),
      itemCount: dateTasks.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 0.5,
        indent: 36,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
      ),
      itemBuilder: (context, index) {
        final task = dateTasks[index];
        return _TaskListItem(
          task: task,
          selectedDate: selectedDate,
          onTap: () => onTaskTap(task),
          onToggle: () => onTaskToggle(task),
          onDelete: onTaskDelete != null ? () => onTaskDelete!(task) : null,
          theme: theme,
        );
      },
    );
  }
}

/// Görev görsel durumu
enum _TaskVisualStatus {
  completed,
  pending,
  overdue,
}

/// Görev durumuna göre renk belirleme
class _TaskStatusColors {
  static const green = Color(0xFF2E7D32);
  static const red = Color(0xFFD32F2F);
  static const darkYellow = Color(0xFFC79100);

  static _TaskVisualStatus resolve(TaskModel task) {
    if (task.isCompleted) return _TaskVisualStatus.completed;

    final now = DateTime.now();
    if (task.dueDate != null && task.dueDate!.isBefore(now)) {
      return _TaskVisualStatus.overdue;
    }
    return _TaskVisualStatus.pending;
  }

  static Color colorFor(_TaskVisualStatus status) {
    switch (status) {
      case _TaskVisualStatus.completed:
        return green;
      case _TaskVisualStatus.pending:
        return red;
      case _TaskVisualStatus.overdue:
        return darkYellow;
    }
  }
}

class _TaskListItem extends StatelessWidget {
  final TaskModel task;
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;
  final ThemeData theme;

  const _TaskListItem({
    required this.task,
    this.selectedDate,
    required this.onTap,
    required this.onToggle,
    this.onDelete,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final status = _TaskStatusColors.resolve(task);
    final statusColor = _TaskStatusColors.colorFor(status);
    final timeStr = task.dueDate != null
        ? DateFormat('HH:mm', 'tr_TR').format(task.dueDate!)
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              _TaskStatusDot(
                status: status,
                color: statusColor,
                isCompleted: task.isCompleted,
                onToggle: onToggle,
              ),
              const SizedBox(width: 12),
              if (timeStr != null) ...[
                SizedBox(
                  width: 42,
                  child: Text(
                    timeStr,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  task.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: statusColor.withValues(alpha: 0.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.45),
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskStatusDot extends StatelessWidget {
  const _TaskStatusDot({
    required this.status,
    required this.color,
    required this.isCompleted,
    required this.onToggle,
  });

  final _TaskVisualStatus status;
  final Color color;
  final bool isCompleted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
        ),
        child: isCompleted
            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}
