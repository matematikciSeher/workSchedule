import '../../../../domain/entities/event_entity.dart';
import '../../../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';
import '../../../../core/services/event_notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Event repository implementasyonu
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final EventNotificationHelper _notificationHelper = EventNotificationHelper();

  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<EventEntity>> getAllEvents({
    String? userId,
    int? limit,
    bool ascending = true,
  }) async {
    return await remoteDataSource.getAllEvents(
      userId: userId,
      limit: limit,
      ascending: ascending,
    );
  }

  @override
  Future<EventEntity?> getEventById(String eventId) async {
    return await remoteDataSource.getEventById(eventId);
  }

  @override
  Future<EventEntity> createEvent(EventEntity event) async {
    final createdEvent = await remoteDataSource.createEvent(event);
    
    // Bildirim zamanla
    await _notificationHelper.scheduleEventNotification(createdEvent);
    
    return createdEvent;
  }

  @override
  Future<EventEntity> updateEvent(EventEntity event) async {
    final updatedEvent = await remoteDataSource.updateEvent(event);
    
    // Bildirimleri güncelle
    await _notificationHelper.updateEventNotification(updatedEvent);
    
    return updatedEvent;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    // Önce etkinliği al (bildirimleri iptal etmek için)
    final event = await remoteDataSource.getEventById(eventId);
    if (event != null) {
      // Bildirimleri iptal et
      await _notificationHelper.cancelEventNotifications(event);
    }
    
    // Etkinliği sil
    await remoteDataSource.deleteEvent(eventId);
  }

  @override
  Future<List<EventEntity>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    return await remoteDataSource.getEventsByDateRange(
      startDate,
      endDate,
      userId: userId,
    );
  }

  @override
  Future<List<EventEntity>> getEventsByDateRangePaginated({
    required DateTime startDate,
    required DateTime endDate,
    String? userId,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    return await remoteDataSource.getEventsByDateRangePaginated(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
      limit: limit,
      lastDocument: lastDocument,
    );
  }

  @override
  Stream<List<EventEntity>> listenEvents({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    return remoteDataSource.listenEvents(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }
}

