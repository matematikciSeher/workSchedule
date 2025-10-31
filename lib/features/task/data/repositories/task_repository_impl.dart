import '../../../../domain/entities/task_entity.dart';
import '../../../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';

/// Task repository implementasyonu
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TaskEntity>> getAllTasks({String? userId}) async {
    return await remoteDataSource.getAllTasks(userId: userId);
  }

  @override
  Future<TaskEntity?> getTaskById(String taskId) async {
    return await remoteDataSource.getTaskById(taskId);
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    return await remoteDataSource.createTask(task);
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    return await remoteDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await remoteDataSource.deleteTask(taskId);
  }

  @override
  Future<List<TaskEntity>> getTasksByDate(DateTime date, {String? userId}) async {
    return await remoteDataSource.getTasksByDate(date, userId: userId);
  }

  @override
  Stream<List<TaskEntity>> listenTasks({String? userId}) {
    return remoteDataSource.listenTasks(userId: userId);
  }
}

