import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
import '../../l10n/app_localizations.dart';
import '../locale/app_localizations_helper.dart';
import '../locale/app_locale.dart';
import 'notification_schedule_result.dart';
import 'notification_service.dart';
import 'task_due_worker.dart';
import 'task_notification_ids.dart';

/// Görev bildirimlerini yöneten yardımcı sınıf
class TaskNotificationHelper {
  final NotificationService _notificationService = NotificationService();

  static const Duration oneHourOffset = Duration(hours: 1);
  static const Duration halfHourOffset = Duration(minutes: 30);

  /// Bildirimin ne zaman geleceğini hesapla (kaydetmeden önce gösterim için)
  static NotificationScheduleResult previewSchedule({
    required DateTime? dueDate,
    bool isCompleted = false,
    AppLocalizations? l10n,
  }) {
    final strings = l10n ?? systemL10n;
    final dateLocale = l10n != null
        ? AppLocale.dateFormatLocale(
            strings.localeName.startsWith('tr')
                ? AppLocale.turkish
                : AppLocale.english,
          )
        : systemDateFormatLocale();

    if (dueDate == null || isCompleted) {
      return NotificationScheduleResult(
        success: false,
        errorMessage: strings.noNotificationNoDate,
      );
    }

    final resolvedDue = _resolveDueDateStatic(dueDate);
    final now = DateTime.now();

    if (resolvedDue.isBefore(now.subtract(const Duration(minutes: 5)))) {
      return NotificationScheduleResult(
        success: false,
        errorMessage: strings.noNotificationPastTask,
      );
    }

    final reminders = _buildReminderTimes(resolvedDue, now, strings);

    final dueStr = DateFormat('dd MMMM HH:mm', dateLocale).format(resolvedDue);
    final reminderLines = reminders.isEmpty
        ? strings.noRemindersTaskTooSoon
        : reminders
            .map(
              (r) => strings.reminderBefore(
                r.label,
                DateFormat('dd MMMM HH:mm', dateLocale).format(r.at),
              ),
            )
            .join('\n');

    return NotificationScheduleResult(
      success: true,
      reminderAt: reminders.isNotEmpty ? reminders.first.at : resolvedDue,
      dueAt: resolvedDue,
      infoMessage: '$dueStr\n$reminderLines',
    );
  }

  static DateTime _resolveDueDateStatic(DateTime dueDate) {
    if (dueDate.hour == 0 &&
        dueDate.minute == 0 &&
        dueDate.second == 0 &&
        dueDate.millisecond == 0) {
      return DateTime(dueDate.year, dueDate.month, dueDate.day, 9, 0);
    }
    return dueDate;
  }

  static List<({DateTime at, String label})> _buildReminderTimes(
    DateTime dueDate,
    DateTime now,
    AppLocalizations l10n,
  ) {
    final candidates = [
      (at: dueDate.subtract(oneHourOffset), label: l10n.oneHour),
      (at: dueDate.subtract(halfHourOffset), label: l10n.thirtyMinutes),
    ];

    final reminders = <({DateTime at, String label})>[];
    for (final candidate in candidates) {
      if (candidate.at.isAfter(now.subtract(const Duration(minutes: 5)))) {
        final at = candidate.at.isBefore(now)
            ? now.add(const Duration(seconds: 30))
            : candidate.at;
        reminders.add((at: at, label: candidate.label));
      }
    }
    return reminders;
  }

  /// Görev için bildirim zamanla (1 saat ve 30 dakika önce + vade kontrolü)
  Future<NotificationScheduleResult> scheduleTaskNotification(
    TaskEntity task,
  ) async {
    final preview = previewSchedule(
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
    );
    if (!preview.success || preview.dueAt == null) {
      return preview;
    }

    try {
      final dueDate = preview.dueAt!;
      final now = DateTime.now();
      final reminders = _buildReminderTimes(dueDate, now, systemL10n);

      DateTime? firstScheduled;
      for (var i = 0; i < reminders.length; i++) {
        final reminder = reminders[i];
        final slot = i == 0
            ? TaskNotificationSlot.oneHour
            : TaskNotificationSlot.halfHour;

        final scheduledAt = await _scheduleReminderNotification(
          task: task,
          dueDate: dueDate,
          scheduledDate: reminder.at,
          slot: slot,
          label: reminder.label,
        );
        firstScheduled ??= scheduledAt;
      }

      await TaskDueWorker.schedule(task.id, dueDate);

      return NotificationScheduleResult(
        success: true,
        reminderAt: firstScheduled,
        dueAt: dueDate,
        infoMessage: preview.infoMessage,
      );
    } catch (e) {
      final needsExact = !await _notificationService.canScheduleExactAlarms();
      final needsNotif = !await _notificationService.hasPermission();

      return NotificationScheduleResult(
        success: false,
        reminderAt: preview.reminderAt,
        dueAt: preview.dueAt,
        needsExactAlarmPermission: needsExact,
        needsNotificationPermission: needsNotif,
        errorMessage: needsExact
            ? systemL10n.exactAlarmPermissionRequired
            : needsNotif
                ? systemL10n.notificationPermissionRequired
                : systemL10n.notificationNotScheduled,
      );
    }
  }

  Future<DateTime> _scheduleReminderNotification({
    required TaskEntity task,
    required DateTime dueDate,
    required DateTime scheduledDate,
    required TaskNotificationSlot slot,
    required String label,
  }) async {
    final l10n = systemL10n;
    final dateLocale = systemDateFormatLocale();
    final dueTimeStr = DateFormat('HH:mm', dateLocale).format(dueDate);
    final dueDateStr = DateFormat('dd MMMM', dateLocale).format(dueDate);

    final title = l10n.taskReminderTitle;
    final body = StringBuffer()
      ..writeln(task.title)
      ..write(l10n.taskReminderBody(dueDateStr, dueTimeStr, label));
    if (task.description != null && task.description!.isNotEmpty) {
      body.write('\n${task.description}');
    }

    final notificationId = slot == TaskNotificationSlot.oneHour
        ? TaskNotificationIds.oneHour(task.id)
        : TaskNotificationIds.halfHour(task.id);

    return _notificationService.scheduleTaskReminderNotification(
      id: notificationId,
      title: title,
      body: body.toString(),
      scheduledDate: scheduledDate,
      taskId: task.id,
      slot: slot,
    );
  }

  Future<void> cancelTaskNotifications(TaskEntity task) async {
    await _notificationService.cancelNotification(
      TaskNotificationIds.oneHour(task.id),
    );
    await _notificationService.cancelNotification(
      TaskNotificationIds.halfHour(task.id),
    );
    await _notificationService.cancelNotification(
      TaskNotificationIds.dueStatus(task.id),
    );
    await TaskDueWorker.cancel(task.id);
    await _notificationService.cancelEventNotifications(task.id);
  }

  Future<NotificationScheduleResult> updateTaskNotification(
    TaskEntity task,
  ) async {
    await cancelTaskNotifications(task);
    if (task.isCompleted) {
      return const NotificationScheduleResult(success: true);
    }
    return scheduleTaskNotification(task);
  }
}

enum TaskNotificationSlot { oneHour, halfHour }
