import '../entities/event_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Event repository interface - Domain katmanı
abstract class EventRepository {
  /// Tüm etkinlikleri getir
  Future<List<EventEntity>> getAllEvents({
    String? userId,
    int? limit,
    bool ascending = true,
  });

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

  /// Tarih aralığına göre etkinlikleri sayfalama ile getir
  Future<List<EventEntity>> getEventsByDateRangePaginated({
    required DateTime startDate,
    required DateTime endDate,
    String? userId,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  });

  /// Etkinlikler için realtime listener
  Stream<List<EventEntity>> listenEvents({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });
}

