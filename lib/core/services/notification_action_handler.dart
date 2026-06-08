import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/local/database_helper.dart';
import '../../domain/entities/task_entity.dart';
import '../../features/task/data/datasources/task_local_datasource.dart';
import '../../features/task/data/repositories/task_repository_impl.dart';
import 'notification_navigation_service.dart';
import 'notification_service.dart';
import 'task_notification_helper.dart';
import 'task_notification_ids.dart';
import 'task_refresh_notifier.dart';

/// Bildirimden gelen tıklama ve aksiyonları işler
class NotificationActionHandler {
  static Future<void> handleResponse(NotificationResponse response) async {
    WidgetsFlutterBinding.ensureInitialized();

    final payload = response.payload;
    if (payload == null || !payload.startsWith('task:')) return;

    final parts = payload.split(':');
    if (parts.length < 2) return;

    final taskId = parts[1];
    final payloadType = parts.length >= 3 ? parts[2] : null;
    final actionId = response.actionId;

    try {
      final repository = TaskRepositoryImpl(
        TaskLocalDataSource(DatabaseHelper.instance),
      );
      final task = await repository.getTaskById(taskId);
      if (task == null) return;

      final notificationService = NotificationService();
      await notificationService.initialize();

      // Hatırlatma bildirimine dokunma veya Ertele → erteleme sayfası
      if ((actionId == null ||
              actionId == NotificationService.snoozeActionId) &&
          (payloadType == 'reminder' || payloadType == 'due')) {
        NotificationNavigationService.openSnoozePage(taskId);
        return;
      }

      if (actionId == NotificationService.completeActionId) {
        await _completeTask(repository, notificationService, task);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Bildirim aksiyonu hatası: $e');
    }
  }

  static Future<void> snoozeTaskToDateTime(
    TaskEntity task,
    DateTime newDueDate,
  ) async {
    final repository = TaskRepositoryImpl(
      TaskLocalDataSource(DatabaseHelper.instance),
    );
    final notificationService = NotificationService();
    await notificationService.initialize();
    await _snoozeTask(repository, notificationService, task, newDueDate);
  }

  static Future<void> _completeTask(
    TaskRepositoryImpl repository,
    NotificationService notificationService,
    TaskEntity task,
  ) async {
    if (task.isCompleted) return;

    final updated = task.copyWith(
      isCompleted: true,
      updatedAt: DateTime.now(),
    );
    await repository.updateTask(updated);
    await TaskNotificationHelper().cancelTaskNotifications(updated);
    TaskRefreshNotifier.notifyReload();

    await notificationService.showFeedbackNotification(
      id: TaskNotificationIds.feedback(task.id),
      title: 'Görev Tamamlandı',
      body: '"${task.title}" tamamlandı olarak işaretlendi.',
      isSuccess: true,
    );
  }

  static Future<void> _snoozeTask(
    TaskRepositoryImpl repository,
    NotificationService notificationService,
    TaskEntity task,
    DateTime newDueDate,
  ) async {
    if (task.isCompleted) return;

    final updated = task.copyWith(
      dueDate: newDueDate,
      updatedAt: DateTime.now(),
    );
    await repository.updateTask(updated);

    final helper = TaskNotificationHelper();
    await helper.cancelTaskNotifications(task);
    await helper.scheduleTaskNotification(updated);

    TaskRefreshNotifier.notifySnoozed(newDueDate);

    await notificationService.showFeedbackNotification(
      id: TaskNotificationIds.feedback(task.id) + 1,
      title: 'Görev Ertelendi',
      body: '"${task.title}" → ${_formatDateTime(newDueDate)}',
      isSuccess: false,
      isSnooze: true,
    );
  }

  static String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$d.$mo.${dt.year} $h:$m';
  }
}
