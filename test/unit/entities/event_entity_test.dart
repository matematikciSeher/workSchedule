import 'package:flutter_test/flutter_test.dart';
import 'package:workschedule/domain/entities/event_entity.dart';

void main() {
  group('EventEntity', () {
    late EventEntity testEvent;
    final now = DateTime.now();

    setUp(() {
      testEvent = EventEntity(
        id: 'test-id',
        title: 'Test Event',
        description: 'Test Description',
        startDate: now,
        endDate: now.add(const Duration(hours: 2)),
        isAllDay: false,
        location: 'Test Location',
        createdAt: now,
        updatedAt: now,
      );
    });

    test('should create an EventEntity with all properties', () {
      expect(testEvent.id, 'test-id');
      expect(testEvent.title, 'Test Event');
      expect(testEvent.description, 'Test Description');
      expect(testEvent.startDate, now);
      expect(testEvent.endDate, now.add(const Duration(hours: 2)));
      expect(testEvent.isAllDay, false);
      expect(testEvent.location, 'Test Location');
    });

    test('should calculate duration in minutes correctly', () {
      expect(testEvent.durationInMinutes, 120);
    });

    test('should determine if event has started', () {
      final pastEvent = EventEntity(
        id: 'past',
        title: 'Past Event',
        startDate: now.subtract(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );
      expect(pastEvent.hasStarted, true);

      final futureEvent = EventEntity(
        id: 'future',
        title: 'Future Event',
        startDate: now.add(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 3)),
        createdAt: now,
        updatedAt: now,
      );
      expect(futureEvent.hasStarted, false);
    });

    test('should determine if event has ended', () {
      final pastEvent = EventEntity(
        id: 'ended',
        title: 'Ended Event',
        startDate: now.subtract(const Duration(hours: 2)),
        endDate: now.subtract(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );
      expect(pastEvent.hasEnded, true);

      final ongoingEvent = EventEntity(
        id: 'ongoing',
        title: 'Ongoing Event',
        startDate: now.subtract(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );
      expect(ongoingEvent.hasEnded, false);
    });

    test('should determine if event is ongoing', () {
      final ongoingEvent = EventEntity(
        id: 'ongoing',
        title: 'Ongoing Event',
        startDate: now.subtract(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );
      expect(ongoingEvent.isOngoing, true);

      final futureEvent = EventEntity(
        id: 'future',
        title: 'Future Event',
        startDate: now.add(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 3)),
        createdAt: now,
        updatedAt: now,
      );
      expect(futureEvent.isOngoing, false);
    });

    test('should create copy with modified properties', () {
      final copied = testEvent.copyWith(
        title: 'Modified Title',
        isAllDay: true,
      );

      expect(copied.title, 'Modified Title');
      expect(copied.isAllDay, true);
      expect(copied.id, testEvent.id); // Unchanged
      expect(copied.description, testEvent.description); // Unchanged
    });

    test('should convert to and from Firestore map', () {
      final map = testEvent.toFirestore();
      final fromMap = EventEntity.fromFirestore(map);

      expect(fromMap.id, testEvent.id);
      expect(fromMap.title, testEvent.title);
      expect(fromMap.description, testEvent.description);
      expect(fromMap.startDate, testEvent.startDate);
      expect(fromMap.endDate, testEvent.endDate);
      expect(fromMap.isAllDay, testEvent.isAllDay);
      expect(fromMap.location, testEvent.location);
    });

    test('should handle all day events correctly', () {
      final allDayEvent = testEvent.copyWith(isAllDay: true);
      expect(allDayEvent.isAllDay, true);
    });

    test('should handle null optional fields', () {
      final minimalEvent = EventEntity(
        id: 'minimal',
        title: 'Minimal Event',
        startDate: now,
        endDate: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );

      expect(minimalEvent.description, isNull);
      expect(minimalEvent.location, isNull);
      expect(minimalEvent.color, isNull);
      expect(minimalEvent.userId, isNull);
      expect(minimalEvent.attachmentPaths, isNull);
    });

    test('should handle attachment paths', () {
      final eventWithAttachments = testEvent.copyWith(
        attachmentPaths: ['/path/to/file1.jpg', '/path/to/file2.pdf'],
      );

      expect(eventWithAttachments.attachmentPaths, isNotNull);
      expect(eventWithAttachments.attachmentPaths!.length, 2);
    });

    test('should be equal when properties are the same', () {
      final event1 = EventEntity(
        id: 'same',
        title: 'Same Event',
        startDate: now,
        endDate: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );

      final event2 = EventEntity(
        id: 'same',
        title: 'Same Event',
        startDate: now,
        endDate: now.add(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      );

      expect(event1, equals(event2));
    });
  });
}
