import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/entities/task_entity.dart';

/// Task remote datasource - Firebase Firestore işlemleri
class TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaskRemoteDataSource(this._firestore);

  /// Firestore collection referansı
  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  /// Tüm görevleri getir
  Future<List<TaskEntity>> getAllTasks({String? userId}) async {
    try {
      Query query = _tasksCollection;
      
      // Kullanıcı ID'si varsa filtrele
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return TaskEntity.fromFirestore(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  /// ID'ye göre görev getir
  Future<TaskEntity?> getTaskById(String taskId) async {
    try {
      final doc = await _tasksCollection.doc(taskId).get();
      
      if (!doc.exists) {
        return null;
      }
      
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return TaskEntity.fromFirestore(data);
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  /// Yeni görev oluştur
  Future<TaskEntity> createTask(TaskEntity task) async {
    try {
      final taskData = task.toFirestore();
      final docRef = await _tasksCollection.add(taskData);
      
      // ID'yi güncelle
      await docRef.update({'id': docRef.id});
      
      return task.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  /// Görev güncelle
  Future<TaskEntity> updateTask(TaskEntity task) async {
    try {
      final taskData = task.toFirestore();
      // ID'yi kaldır çünkü zaten document ID olarak kullanılıyor
      taskData.remove('id');
      
      await _tasksCollection.doc(task.id).update(taskData);
      
      return task;
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  /// Görev sil
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// Tarihe göre görevleri getir
  Future<List<TaskEntity>> getTasksByDate(DateTime date, {String? userId}) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      Query query = _tasksCollection.where(
        'dueDate',
        isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch,
      ).where(
        'dueDate',
        isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch,
      );

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return TaskEntity.fromFirestore(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks by date: $e');
    }
  }

  /// Görevler için realtime listener
  Stream<List<TaskEntity>> listenTasks({String? userId}) {
    try {
      Query query = _tasksCollection;
      
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return TaskEntity.fromFirestore(data);
            })
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to listen tasks: $e');
    }
  }
}

