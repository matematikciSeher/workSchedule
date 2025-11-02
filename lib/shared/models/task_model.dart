import '../../domain/entities/task_entity.dart';

/// Basit görev modeli (tam implementasyon için domain entities kullanılmalı)
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final DateTime createdAt;
  final bool isCompleted;
  final String? color;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    DateTime? createdAt,
    this.isCompleted = false,
    this.color,
  }) : createdAt = createdAt ?? DateTime.now();

  /// TaskEntity'den TaskModel oluştur
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      createdAt: entity.createdAt,
      isCompleted: entity.isCompleted,
      color: entity.color,
    );
  }

  /// Görevin tarihini kontrol et
  bool isOnDate(DateTime date) {
    if (dueDate == null) return false;
    return dueDate!.year == date.year &&
        dueDate!.month == date.month &&
        dueDate!.day == date.day;
  }
}

