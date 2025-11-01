import '../../../../domain/entities/task_entity.dart';

/// Task Model - SQLite için data katmanı modeli
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;
  final String? userId;
  final String? color;
  final int? priority;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.isCompleted = false,
    this.userId,
    this.color,
    this.priority,
  });

  /// TaskEntity'den TaskModel oluştur
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isCompleted: entity.isCompleted,
      userId: entity.userId,
      color: entity.color,
      priority: entity.priority,
    );
  }

  /// SQLite Map'ten TaskModel oluştur
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      isCompleted: (map['isCompleted'] as int) == 1,
      userId: map['userId'] as String?,
      color: map['color'] as String?,
      priority: map['priority'] as int?,
    );
  }

  /// TaskModel'i SQLite Map'e çevir
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isCompleted': isCompleted ? 1 : 0,
      'userId': userId,
      'color': color,
      'priority': priority,
    };
  }

  /// TaskModel'i TaskEntity'ye çevir
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isCompleted: isCompleted,
      userId: userId,
      color: color,
      priority: priority,
    );
  }

  /// TaskModel'in kopyasını oluştur
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
    String? userId,
    String? color,
    int? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      color: color ?? this.color,
      priority: priority ?? this.priority,
    );
  }
}

