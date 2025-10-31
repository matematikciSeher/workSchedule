import '../../../../domain/entities/event_entity.dart';
import '../../../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';

/// Event repository implementasyonu
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<EventEntity>> getAllEvents({String? userId}) async {
    return await remoteDataSource.getAllEvents(userId: userId);
  }

  @override
  Future<EventEntity?> getEventById(String eventId) async {
    return await remoteDataSource.getEventById(eventId);
  }

  @override
  Future<EventEntity> createEvent(EventEntity event) async {
    return await remoteDataSource.createEvent(event);
  }

  @override
  Future<EventEntity> updateEvent(EventEntity event) async {
    return await remoteDataSource.updateEvent(event);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
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
  Stream<List<EventEntity>> listenEvents({String? userId}) {
    return remoteDataSource.listenEvents(userId: userId);
  }
}

