import 'package:equatable/equatable.dart';

/// Event entity - Domain katmanında kullanılacak etkinlik entity'si
class EventEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final String? location;
  final List<String> attendees;
  final String? reminder;
  final String? color;
  final String? userId; // Firebase için
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventEntity({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    this.isAllDay = false,
    this.location,
    this.attendees = const [],
    this.reminder,
    this.color,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Firebase Map'ten entity oluştur
  factory EventEntity.fromFirestore(Map<String, dynamic> map) {
    return EventEntity(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : DateTime.now(),
      isAllDay: map['isAllDay'] as bool? ?? false,
      location: map['location'] as String?,
      attendees: List<String>.from(map['attendees'] as List? ?? []),
      reminder: map['reminder'] as String?,
      color: map['color'] as String?,
      userId: map['userId'] as String?,
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
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'isAllDay': isAllDay,
      'location': location,
      'attendees': attendees,
      'reminder': reminder,
      'color': color,
      'userId': userId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Etkinliğin kopyasını oluştur (immutability için)
  EventEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAllDay,
    String? location,
    List<String>? attendees,
    String? reminder,
    String? color,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAllDay: isAllDay ?? this.isAllDay,
      location: location ?? this.location,
      attendees: attendees ?? this.attendees,
      reminder: reminder ?? this.reminder,
      color: color ?? this.color,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Etkinliğin süresini dakika cinsinden hesapla
  int get durationInMinutes {
    return endDate.difference(startDate).inMinutes;
  }

  /// Etkinlik başladı mı?
  bool get hasStarted => DateTime.now().isAfter(startDate);

  /// Etkinlik bitti mi?
  bool get hasEnded => DateTime.now().isAfter(endDate);

  /// Etkinlik devam ediyor mu?
  bool get isOngoing => hasStarted && !hasEnded;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startDate,
        endDate,
        isAllDay,
        location,
        attendees,
        reminder,
        color,
        userId,
        createdAt,
        updatedAt,
      ];
}

