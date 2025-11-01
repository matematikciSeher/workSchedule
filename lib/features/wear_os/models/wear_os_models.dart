import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/task_entity.dart';

/// Wear OS için hafifletilmiş veri modelleri
/// Saat ekranında gösterilmek üzere optimize edilmiş

/// Wear OS için uyarlanmış Event modeli
class WearOsEvent {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final String? location;
  final String? color;

  const WearOsEvent({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.isAllDay = false,
    this.location,
    this.color,
  });

  factory WearOsEvent.fromEntity(EventEntity entity) {
    return WearOsEvent(
      id: entity.id,
      title: entity.title,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isAllDay: entity.isAllDay,
      location: entity.location,
      color: entity.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'isAllDay': isAllDay,
      'location': location,
      'color': color,
    };
  }

  factory WearOsEvent.fromJson(Map<String, dynamic> json) {
    return WearOsEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate'] as int),
      isAllDay: json['isAllDay'] as bool? ?? false,
      location: json['location'] as String?,
      color: json['color'] as String?,
    );
  }
}

/// Wear OS için uyarlanmış Task modeli
class WearOsTask {
  final String id;
  final String title;
  final DateTime? dueDate;
  final bool isCompleted;
  final String? color;
  final int? priority;

  const WearOsTask({
    required this.id,
    required this.title,
    this.dueDate,
    this.isCompleted = false,
    this.color,
    this.priority,
  });

  factory WearOsTask.fromEntity(TaskEntity entity) {
    return WearOsTask(
      id: entity.id,
      title: entity.title,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      color: entity.color,
      priority: entity.priority,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'color': color,
      'priority': priority,
    };
  }

  factory WearOsTask.fromJson(Map<String, dynamic> json) {
    return WearOsTask(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate'] as int)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
      color: json['color'] as String?,
      priority: json['priority'] as int?,
    );
  }

  /// Görev aciliyet seviyesi
  String get urgencyLevel {
    if (dueDate == null) return 'normal';
    final now = DateTime.now();
    final daysUntilDue = dueDate!.difference(now).inDays;
    
    if (daysUntilDue < 0) return 'overdue';
    if (daysUntilDue == 0) return 'urgent';
    if (daysUntilDue <= 3) return 'soon';
    return 'normal';
  }
}

/// Wear OS için günlük özet modeli
class WearOsDailySummary {
  final DateTime date;
  final List<WearOsEvent> events;
  final List<WearOsTask> tasks;
  final int completedTasksCount;
  final int totalTasksCount;

  const WearOsDailySummary({
    required this.date,
    required this.events,
    required this.tasks,
    required this.completedTasksCount,
    required this.totalTasksCount,
  });

  double get completionPercentage {
    if (totalTasksCount == 0) return 0.0;
    return completedTasksCount / totalTasksCount;
  }

  /// Yaklaşan sonraki etkinlik
  WearOsEvent? get nextEvent {
    final now = DateTime.now();
    final upcomingEvents = events
        .where((e) => e.startDate.isAfter(now))
        .toList();
    if (upcomingEvents.isEmpty) return null;
    
    upcomingEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
    return upcomingEvents.first;
  }

  /// Acil görevler
  List<WearOsTask> get urgentTasks {
    return tasks
        .where((t) => !t.isCompleted && t.urgencyLevel == 'urgent')
        .toList();
  }
}

