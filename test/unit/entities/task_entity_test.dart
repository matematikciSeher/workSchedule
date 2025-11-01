import 'package:flutter_test/flutter_test.dart';
import 'package:workschedule/domain/entities/task_entity.dart';
import 'package:workschedule/domain/entities/subtask_entity.dart';

void main() {
  group('TaskEntity', () {
    late TaskEntity testTask;
    final now = DateTime.now();

    setUp(() {
      testTask = TaskEntity(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: now.add(const Duration(days: 1)),
        createdAt: now,
        updatedAt: now,
        isCompleted: false,
        userId: 'test-user-id',
        priority: 2,
      );
    });

    test('should create a TaskEntity with all properties', () {
      expect(testTask.id, 'test-id');
      expect(testTask.title, 'Test Task');
      expect(testTask.description, 'Test Description');
      expect(testTask.dueDate, now.add(const Duration(days: 1)));
      expect(testTask.isCompleted, false);
      expect(testTask.userId, 'test-user-id');
      expect(testTask.priority, 2);
    });

    test('should check if task is on specific date', () {
      final dueDate = DateTime(2024, 1, 15);
      final taskWithDate = testTask.copyWith(dueDate: dueDate);

      expect(taskWithDate.isOnDate(DateTime(2024, 1, 15)), true);
      expect(taskWithDate.isOnDate(DateTime(2024, 1, 16)), false);
      expect(taskWithDate.isOnDate(DateTime(2024, 2, 15)), false);
    });

    test('should return false for isOnDate when dueDate is null', () {
      final taskWithoutDate = testTask.copyWith(dueDate: null);
      expect(taskWithoutDate.isOnDate(DateTime.now()), false);
    });

    test('should calculate subtasks completion percentage', () {
      final subtask1 = SubtaskEntity(
        id: 'sub1',
        title: 'Subtask 1',
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );
      final subtask2 = SubtaskEntity(
        id: 'sub2',
        title: 'Subtask 2',
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );
      final subtask3 = SubtaskEntity(
        id: 'sub3',
        title: 'Subtask 3',
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );

      final taskWithSubtasks = testTask.copyWith(
        subtasks: [subtask1, subtask2, subtask3],
      );

      expect(taskWithSubtasks.subtasksCompletionPercentage, 2 / 3);
    });

    test('should return 0.0 for completion percentage when no subtasks', () {
      expect(testTask.subtasksCompletionPercentage, 0.0);
    });

    test('should check if all subtasks are completed', () {
      final completedSubtask1 = SubtaskEntity(
        id: 'sub1',
        title: 'Subtask 1',
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );
      final completedSubtask2 = SubtaskEntity(
        id: 'sub2',
        title: 'Subtask 2',
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );

      final taskWithCompletedSubtasks = testTask.copyWith(
        subtasks: [completedSubtask1, completedSubtask2],
      );

      expect(taskWithCompletedSubtasks.allSubtasksCompleted, true);

      final incompleteSubtask = SubtaskEntity(
        id: 'sub3',
        title: 'Subtask 3',
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final taskWithIncompleteSubtasks = testTask.copyWith(
        subtasks: [completedSubtask1, incompleteSubtask],
      );

      expect(taskWithIncompleteSubtasks.allSubtasksCompleted, false);
    });

    test('should return false for allSubtasksCompleted when no subtasks', () {
      expect(testTask.allSubtasksCompleted, false);
    });

    test('should create copy with modified properties', () {
      final copied = testTask.copyWith(
        title: 'Modified Title',
        isCompleted: true,
        priority: 3,
      );

      expect(copied.title, 'Modified Title');
      expect(copied.isCompleted, true);
      expect(copied.priority, 3);
      expect(copied.id, testTask.id); // Unchanged
    });

    test('should convert to and from Firestore map', () {
      final subtask = SubtaskEntity(
        id: 'sub1',
        title: 'Test Subtask',
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final taskWithSubtask = testTask.copyWith(subtasks: [subtask]);
      final map = taskWithSubtask.toFirestore();
      final fromMap = TaskEntity.fromFirestore(map);

      expect(fromMap.id, taskWithSubtask.id);
      expect(fromMap.title, taskWithSubtask.title);
      expect(fromMap.description, taskWithSubtask.description);
      expect(fromMap.dueDate, taskWithSubtask.dueDate);
      expect(fromMap.isCompleted, taskWithSubtask.isCompleted);
      expect(fromMap.priority, taskWithSubtask.priority);
      expect(fromMap.subtasks.length, 1);
      expect(fromMap.subtasks[0].title, 'Test Subtask');
    });

    test('should handle null optional fields', () {
      final minimalTask = TaskEntity(
        id: 'minimal',
        title: 'Minimal Task',
        createdAt: now,
        updatedAt: now,
      );

      expect(minimalTask.description, isNull);
      expect(minimalTask.dueDate, isNull);
      expect(minimalTask.userId, isNull);
      expect(minimalTask.color, isNull);
      expect(minimalTask.priority, isNull);
      expect(minimalTask.subtasks, isEmpty);
    });

    test('should handle recurring tasks', () {
      final recurringTask = testTask.copyWith(
        isRecurring: true,
        recurringPattern: 'daily',
        recurringEndDate: now.add(const Duration(days: 7)),
      );

      expect(recurringTask.isRecurring, true);
      expect(recurringTask.recurringPattern, 'daily');
      expect(recurringTask.recurringEndDate, isNotNull);
    });

    test('should be equal when properties are the same', () {
      final task1 = TaskEntity(
        id: 'same',
        title: 'Same Task',
        createdAt: now,
        updatedAt: now,
      );

      final task2 = TaskEntity(
        id: 'same',
        title: 'Same Task',
        createdAt: now,
        updatedAt: now,
      );

      expect(task1, equals(task2));
    });
  });
}
