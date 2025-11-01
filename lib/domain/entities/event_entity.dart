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
  final String? reminder; // Eski format için geriye dönük uyumluluk
  final int?
      reminderBeforeMinutes; // Etkinlikten kaç dakika önce hatırlatılacak
  final bool isRecurring; // Tekrar eden hatırlatma mı?
  final String? recurringPattern; // 'daily', 'weekly', 'monthly', null
  final String? color;
  final String? userId; // Firebase için
  final List<String>? attachmentPaths; // Dosya/fotoğraf path'leri
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
    this.reminderBeforeMinutes,
    this.isRecurring = false,
    this.recurringPattern,
    this.color,
    this.userId,
    this.attachmentPaths,
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
      reminderBeforeMinutes: map['reminderBeforeMinutes'] != null
          ? map['reminderBeforeMinutes'] as int?
          : null,
      isRecurring: map['isRecurring'] as bool? ?? false,
      recurringPattern: map['recurringPattern'] as String?,
      color: map['color'] as String?,
      userId: map['userId'] as String?,
      attachmentPaths: map['attachmentPaths'] != null
          ? List<String>.from(map['attachmentPaths'] as List)
          : null,
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
      'reminderBeforeMinutes': reminderBeforeMinutes,
      'isRecurring': isRecurring,
      'recurringPattern': recurringPattern,
      'color': color,
      'userId': userId,
      'attachmentPaths': attachmentPaths,
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
    int? reminderBeforeMinutes,
    bool? isRecurring,
    String? recurringPattern,
    String? color,
    String? userId,
    List<String>? attachmentPaths,
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
      reminderBeforeMinutes:
          reminderBeforeMinutes ?? this.reminderBeforeMinutes,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      color: color ?? this.color,
      userId: userId ?? this.userId,
      attachmentPaths: attachmentPaths ?? this.attachmentPaths,
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
        reminderBeforeMinutes,
        isRecurring,
        recurringPattern,
        color,
        userId,
        attachmentPaths,
        createdAt,
        updatedAt,
      ];
}
