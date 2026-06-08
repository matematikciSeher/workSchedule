import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
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
  }) {
    if (dueDate == null || isCompleted) {
      return const NotificationScheduleResult(
        success: false,
        errorMessage: 'Tarih seçilmediği için bildirim planlanmaz.',
      );
    }

    final resolvedDue = _resolveDueDateStatic(dueDate);
    final now = DateTime.now();

    if (resolvedDue.isBefore(now.subtract(const Duration(minutes: 5)))) {
      return const NotificationScheduleResult(
        success: false,
        errorMessage: 'Geçmiş bir görev için bildirim planlanmaz.',
      );
    }

    final reminders = _buildReminderTimes(resolvedDue, now);

    final dueStr = DateFormat('dd MMMM HH:mm', 'tr_TR').format(resolvedDue);
    final reminderLines = reminders.isEmpty
        ? '• Hatırlatıcı yok (görev çok yakın)'
        : reminders
            .map(
              (r) =>
                  '• ${r.label} kala: ${DateFormat('dd MMMM HH:mm', 'tr_TR').format(r.at)}',
            )
            .join('\n');

    return NotificationScheduleResult(
      success: true,
      reminderAt: reminders.isNotEmpty ? reminders.first.at : resolvedDue,
      dueAt: resolvedDue,
      infoMessage:
          'Görev saati: $dueStr\nHatırlatıcılar:\n$reminderLines\n\nVade anında tamamlanma durumu bildirilecek.',
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
  ) {
    final candidates = [
      (at: dueDate.subtract(oneHourOffset), label: '1 saat'),
      (at: dueDate.subtract(halfHourOffset), label: '30 dakika'),
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
      final reminders = _buildReminderTimes(dueDate, now);

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
            ? 'Kesin alarm izni kapalı. Ayarlar > İzinler > Saat ve Alarm bölümünden açın.'
            : needsNotif
                ? 'Bildirim izni kapalı. Ayarlar > Bildirimler bölümünden açın.'
                : 'Bildirim zamanlanamadı: $e',
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
    final dueTimeStr = DateFormat('HH:mm').format(dueDate);
    final dueDateStr = DateFormat('dd MMMM', 'tr_TR').format(dueDate);

    final title = 'Görev Hatırlatıcısı';
    final body = StringBuffer()
      ..writeln(task.title)
      ..write('$dueDateStr saat $dueTimeStr — $label kaldı');
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
