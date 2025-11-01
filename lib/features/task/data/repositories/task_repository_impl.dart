import '../../../../domain/entities/task_entity.dart';
import '../../../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

/// Task repository implementasyonu - SQLite kullanıyor
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<TaskEntity>> getAllTasks({String? userId}) async {
    final tasks = await localDataSource.getAllTasks(userId: userId);
    return tasks.map((task) => task.toEntity()).toList();
  }

  @override
  Future<TaskEntity?> getTaskById(String taskId) async {
    final task = await localDataSource.getTaskById(taskId);
    return task?.toEntity();
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    final createdTask = await localDataSource.createTask(taskModel);
    return createdTask.toEntity();
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    final updatedTask = await localDataSource.updateTask(taskModel);
    return updatedTask.toEntity();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await localDataSource.deleteTask(taskId);
  }

  @override
  Future<List<TaskEntity>> getTasksByDate(DateTime date, {String? userId}) async {
    final tasks = await localDataSource.getTasksByDate(date, userId: userId);
    return tasks.map((task) => task.toEntity()).toList();
  }

  @override
  Stream<List<TaskEntity>> listenTasks({String? userId}) {
    return localDataSource
        .listenTasks(userId: userId)
        .map((tasks) => tasks.map((task) => task.toEntity()).toList());
  }
}

