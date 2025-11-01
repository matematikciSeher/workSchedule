import 'package:mocktail/mocktail.dart';
import 'package:workschedule/domain/entities/event_entity.dart';
import 'package:workschedule/domain/entities/task_entity.dart';
import 'package:workschedule/domain/repositories/event_repository.dart';
import 'package:workschedule/domain/repositories/task_repository.dart';

/// Mock TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

/// Mock EventRepository
class MockEventRepository extends Mock implements EventRepository {}

/// Test helper class for creating test data
class TestHelpers {
  /// Create a test TaskEntity
  static TaskEntity createTestTask({
    String? id,
    String? title,
    bool isCompleted = false,
    String? userId,
  }) {
    final now = DateTime.now();
    return TaskEntity(
      id: id ?? 'test-task-id',
      title: title ?? 'Test Task',
      description: 'Test description',
      dueDate: now.add(const Duration(days: 1)),
      createdAt: now,
      updatedAt: now,
      isCompleted: isCompleted,
      userId: userId ?? 'test-user-id',
    );
  }

  /// Create a test EventEntity
  static EventEntity createTestEvent({
    String? id,
    String? title,
    String? userId,
  }) {
    final now = DateTime.now();
    return EventEntity(
      id: id ?? 'test-event-id',
      title: title ?? 'Test Event',
      description: 'Test event description',
      startDate: now,
      endDate: now.add(const Duration(hours: 2)),
      isAllDay: false,
      createdAt: now,
      updatedAt: now,
      userId: userId ?? 'test-user-id',
    );
  }

  /// Create a list of test tasks
  static List<TaskEntity> createTestTaskList(int count) {
    return List.generate(
      count,
      (index) => createTestTask(
        id: 'task-$index',
        title: 'Test Task $index',
      ),
    );
  }

  /// Create a list of test events
  static List<EventEntity> createTestEventList(int count) {
    return List.generate(
      count,
      (index) => createTestEvent(
        id: 'event-$index',
        title: 'Test Event $index',
      ),
    );
  }
}
