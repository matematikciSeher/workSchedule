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

  /// Görevin tarihini kontrol et
  bool isOnDate(DateTime date) {
    if (dueDate == null) return false;
    return dueDate!.year == date.year &&
        dueDate!.month == date.month &&
        dueDate!.day == date.day;
  }
}

