import '../entities/task_entity.dart';

/// Task repository interface - Domain katmanı
abstract class TaskRepository {
  /// Tüm görevleri getir
  Future<List<TaskEntity>> getAllTasks({String? userId});

  /// ID'ye göre görev getir
  Future<TaskEntity?> getTaskById(String taskId);

  /// Yeni görev oluştur
  Future<TaskEntity> createTask(TaskEntity task);

  /// Görev güncelle
  Future<TaskEntity> updateTask(TaskEntity task);

  /// Görev sil
  Future<void> deleteTask(String taskId);

  /// Tarihe göre görevleri getir
  Future<List<TaskEntity>> getTasksByDate(DateTime date, {String? userId});

  /// Görevler için realtime listener
  Stream<List<TaskEntity>> listenTasks({String? userId});
}

