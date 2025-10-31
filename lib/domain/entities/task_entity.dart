import 'package:equatable/equatable.dart';

/// Task entity - Domain katmanında kullanılacak görev entity'si
class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;
  final String? userId; // Firebase için
  final String? color;
  final int? priority; // 1: Low, 2: Medium, 3: High

  const TaskEntity({
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

  /// Firebase Map'ten entity oluştur
  factory TaskEntity.fromFirestore(Map<String, dynamic> map) {
    return TaskEntity(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : DateTime.now(),
      isCompleted: map['isCompleted'] as bool? ?? false,
      userId: map['userId'] as String?,
      color: map['color'] as String?,
      priority: map['priority'] as int?,
    );
  }

  /// Entity'yi Firebase Map'e çevir
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'userId': userId,
      'color': color,
      'priority': priority,
    };
  }

  /// Görevin kopyasını oluştur (immutability için)
  TaskEntity copyWith({
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
    return TaskEntity(
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

  /// Görevin tarihini kontrol et
  bool isOnDate(DateTime date) {
    if (dueDate == null) return false;
    return dueDate!.year == date.year &&
        dueDate!.month == date.month &&
        dueDate!.day == date.day;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        createdAt,
        updatedAt,
        isCompleted,
        userId,
        color,
        priority,
      ];
}

