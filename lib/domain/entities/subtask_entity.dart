import 'package:equatable/equatable.dart';

/// Subtask entity - Alt görev entity'si
class SubtaskEntity extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubtaskEntity({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Firebase Map'ten entity oluştur
  factory SubtaskEntity.fromFirestore(Map<String, dynamic> map) {
    return SubtaskEntity(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : DateTime.now(),
    );
  }

  /// Entity'yi Firebase Map'e çevir
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Alt görevin kopyasını oluştur (immutability için)
  SubtaskEntity copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubtaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        isCompleted,
        createdAt,
        updatedAt,
      ];
}

