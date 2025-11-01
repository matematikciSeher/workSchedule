import '../../../../data/local/database_helper.dart';
import '../models/task_model.dart';

/// Task Local DataSource - SQLite veritabanı işlemleri
class TaskLocalDataSource {
  final DatabaseHelper _databaseHelper;

  TaskLocalDataSource(this._databaseHelper);

  /// Tüm görevleri getir
  Future<List<TaskModel>> getAllTasks({String? userId}) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps;

    if (userId != null) {
      maps = await db.query(
        'tasks',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'createdAt DESC',
      );
    } else {
      maps = await db.query(
        'tasks',
        orderBy: 'createdAt DESC',
      );
    }

    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  /// ID'ye göre görev getir
  Future<TaskModel?> getTaskById(String taskId) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  /// Yeni görev oluştur
  Future<TaskModel> createTask(TaskModel task) async {
    final db = await _databaseHelper.database;
    await db.insert('tasks', task.toMap());
    return task;
  }

  /// Görev güncelle
  Future<TaskModel> updateTask(TaskModel task) async {
    final db = await _databaseHelper.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    return task;
  }

  /// Görev sil
  Future<void> deleteTask(String taskId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  /// Tarihe göre görevleri getir
  Future<List<TaskModel>> getTasksByDate(DateTime date, {String? userId}) async {
    final db = await _databaseHelper.database;
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;

    final List<Map<String, dynamic>> maps;

    if (userId != null) {
      maps = await db.query(
        'tasks',
        where: 'dueDate >= ? AND dueDate <= ? AND userId = ?',
        whereArgs: [startOfDay, endOfDay, userId],
        orderBy: 'createdAt DESC',
      );
    } else {
      maps = await db.query(
        'tasks',
        where: 'dueDate >= ? AND dueDate <= ?',
        whereArgs: [startOfDay, endOfDay],
        orderBy: 'createdAt DESC',
      );
    }

    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  /// Görevler için stream (realtime güncellemeler için)
  Stream<List<TaskModel>> listenTasks({String? userId}) async* {
    while (true) {
      final tasks = await getAllTasks(userId: userId);
      yield tasks;
      // Basit bir polling mekanizması (gerçek uygulamalarda daha iyi bir yaklaşım kullanılabilir)
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}

