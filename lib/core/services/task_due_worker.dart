import 'package:flutter/widgets.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:workmanager/workmanager.dart';
import '../../data/local/database_helper.dart';
import '../../features/task/data/datasources/task_local_datasource.dart';
import '../../features/task/data/repositories/task_repository_impl.dart';
import 'notification_service.dart';

/// Görev vadesi geldiğinde tamamlanma durumunu kontrol eder
class TaskDueWorker {
  static const String taskName = 'taskDueCheck';

  static Future<void> schedule(String taskId, DateTime dueDate) async {
    final delay = dueDate.difference(DateTime.now());
    if (delay.isNegative) {
      await execute({'taskId': taskId});
      return;
    }

    await Workmanager().cancelByUniqueName(_uniqueName(taskId));
    await Workmanager().registerOneOffTask(
      _uniqueName(taskId),
      taskName,
      inputData: {'taskId': taskId},
      initialDelay: delay,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );
  }

  static Future<void> cancel(String taskId) async {
    await Workmanager().cancelByUniqueName(_uniqueName(taskId));
  }

  static String _uniqueName(String taskId) => 'due_$taskId';

  static Future<bool> execute(Map<String, dynamic>? inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();

    final taskId = inputData?['taskId'] as String?;
    if (taskId == null) return false;

    try {
      final repository = TaskRepositoryImpl(
        TaskLocalDataSource(DatabaseHelper.instance),
      );
      final task = await repository.getTaskById(taskId);
      if (task == null) return true;

      final notificationService = NotificationService();
      await notificationService.initialize();
      await notificationService.showTaskDueStatusNotification(task: task);
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Vade kontrolü hatası: $e');
      return false;
    }
  }
}

@pragma('vm:entry-point')
void taskDueCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == TaskDueWorker.taskName) {
      return TaskDueWorker.execute(inputData);
    }
    return false;
  });
}
