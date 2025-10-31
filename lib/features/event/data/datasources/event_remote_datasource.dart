import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/entities/event_entity.dart';

/// Event remote datasource - Firebase Firestore işlemleri
class EventRemoteDataSource {
  final FirebaseFirestore _firestore;

  EventRemoteDataSource(this._firestore);

  /// Firestore collection referansı
  CollectionReference get _eventsCollection => _firestore.collection('events');

  /// Tüm etkinlikleri getir
  Future<List<EventEntity>> getAllEvents({String? userId}) async {
    try {
      Query query = _eventsCollection;
      
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return EventEntity.fromFirestore(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to get events: $e');
    }
  }

  /// ID'ye göre etkinlik getir
  Future<EventEntity?> getEventById(String eventId) async {
    try {
      final doc = await _eventsCollection.doc(eventId).get();
      
      if (!doc.exists) {
        return null;
      }
      
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return EventEntity.fromFirestore(data);
    } catch (e) {
      throw Exception('Failed to get event: $e');
    }
  }

  /// Yeni etkinlik oluştur
  Future<EventEntity> createEvent(EventEntity event) async {
    try {
      final eventData = event.toFirestore();
      final docRef = await _eventsCollection.add(eventData);
      
      // ID'yi güncelle
      await docRef.update({'id': docRef.id});
      
      return event.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  /// Etkinlik güncelle
  Future<EventEntity> updateEvent(EventEntity event) async {
    try {
      final eventData = event.toFirestore();
      // ID'yi kaldır çünkü zaten document ID olarak kullanılıyor
      eventData.remove('id');
      
      await _eventsCollection.doc(event.id).update(eventData);
      
      return event;
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  /// Etkinlik sil
  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventsCollection.doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  /// Tarih aralığına göre etkinlikleri getir
  Future<List<EventEntity>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    try {
      Query query = _eventsCollection.where(
        'startDate',
        isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch,
      ).where(
        'startDate',
        isLessThanOrEqualTo: endDate.millisecondsSinceEpoch,
      );

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return EventEntity.fromFirestore(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to get events by date range: $e');
    }
  }

  /// Etkinlikler için realtime listener
  Stream<List<EventEntity>> listenEvents({String? userId}) {
    try {
      Query query = _eventsCollection;
      
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return EventEntity.fromFirestore(data);
            })
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to listen events: $e');
    }
  }
}

