import '../entities/event_entity.dart';

/// Event repository interface - Domain katmanı
abstract class EventRepository {
  /// Tüm etkinlikleri getir
  Future<List<EventEntity>> getAllEvents({String? userId});

  /// ID'ye göre etkinlik getir
  Future<EventEntity?> getEventById(String eventId);

  /// Yeni etkinlik oluştur
  Future<EventEntity> createEvent(EventEntity event);

  /// Etkinlik güncelle
  Future<EventEntity> updateEvent(EventEntity event);

  /// Etkinlik sil
  Future<void> deleteEvent(String eventId);

  /// Tarih aralığına göre etkinlikleri getir
  Future<List<EventEntity>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  });

  /// Etkinlikler için realtime listener
  Stream<List<EventEntity>> listenEvents({String? userId});
}

