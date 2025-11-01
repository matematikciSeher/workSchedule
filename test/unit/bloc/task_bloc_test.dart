import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workschedule/domain/entities/subtask_entity.dart';
import 'package:workschedule/features/task/bloc/task_bloc.dart';
import 'package:workschedule/features/task/bloc/task_event.dart';
import 'package:workschedule/features/task/bloc/task_state.dart';
import '../../helpers/mock_helpers.dart';

void main() {
  late MockTaskRepository mockRepository;
  late TaskBloc taskBloc;

  setUp(() {
    mockRepository = MockTaskRepository();
    taskBloc = TaskBloc(mockRepository);
  });

  tearDown(() {
    taskBloc.close();
  });

  group('TaskBloc', () {
    test('initial state should be TaskInitial', () {
      expect(taskBloc.state, equals(const TaskInitial()));
    });

    group('LoadTasksEvent', () {
      final testTasks = TestHelpers.createTestTaskList(3);

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskLoaded] when LoadTasksEvent is added successfully',
        build: () {
          when(() => mockRepository.getAllTasks(userId: any(named: 'userId')))
              .thenAnswer((_) async => testTasks);
          return taskBloc;
        },
        act: (bloc) => bloc.add(const LoadTasksEvent()),
        expect: () => [
          const TaskLoading(),
          TaskLoaded(testTasks),
        ],
        verify: (_) {
          verify(() => mockRepository.getAllTasks(userId: null)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when LoadTasksEvent fails',
        build: () {
          when(() => mockRepository.getAllTasks(userId: any(named: 'userId')))
              .thenThrow(Exception('Failed to load tasks'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const LoadTasksEvent()),
        expect: () => [
          const TaskLoading(),
          TaskError('Exception: Failed to load tasks'),
        ],
      );

      blocTest<TaskBloc, TaskState>(
        'loads tasks with userId filter',
        build: () {
          when(() => mockRepository.getAllTasks(userId: any(named: 'userId')))
              .thenAnswer((_) async => testTasks);
          return taskBloc;
        },
        act: (bloc) => bloc.add(const LoadTasksEvent(userId: 'user-123')),
        expect: () => [
          const TaskLoading(),
          TaskLoaded(testTasks),
        ],
        verify: (_) {
          verify(() => mockRepository.getAllTasks(userId: 'user-123')).called(1);
        },
      );
    });

    group('CreateTaskEvent', () {
      final newTask = TestHelpers.createTestTask(
        id: 'new-task',
        title: 'New Task',
      );
      final allTasks = [newTask, ...TestHelpers.createTestTaskList(2)];

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskCreated, TaskLoaded] when task is created successfully',
        build: () {
          when(() => mockRepository.createTask(any()))
              .thenAnswer((_) async => newTask);
          when(() => mockRepository.getAllTasks(userId: any(named: 'userId')))
              .thenAnswer((_) async => allTasks);
          return taskBloc;
        },
        act: (bloc) => bloc.add(CreateTaskEvent(newTask)),
        expect: () => [
          const TaskLoading(),
          const TaskCreated(),
          TaskLoaded(allTasks),
        ],
        verify: (_) {
          verify(() => mockRepository.createTask(newTask)).called(1);
          verify(() => mockRepository.getAllTasks(userId: newTask.userId))
              .called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when CreateTaskEvent fails',
        build: () {
          when(() => mockRepository.createTask(any()))
              .thenThrow(Exception('Failed to create task'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(CreateTaskEvent(newTask)),
        expect: () => [
          const TaskLoading(),
          TaskError('Exception: Failed to create task'),
        ],
      );
    });

    group('UpdateTaskEvent', () {
      final updatedTask = TestHelpers.createTestTask(
        id: 'task-1',
        title: 'Updated Task',
      );
      final allTasks = [updatedTask, ...TestHelpers.createTestTaskList(2)];

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskUpdated, TaskLoaded] when task is updated successfully',
        build: () {
          when(() => mockRepository.updateTask(any()))
              .thenAnswer((_) async => updatedTask);
          when(() => mockRepository.getAllTasks(userId: any(named: 'userId')))
              .thenAnswer((_) async => allTasks);
          return taskBloc;
        },
        act: (bloc) => bloc.add(UpdateTaskEvent(updatedTask)),
        expect: () => [
          const TaskLoading(),
          const TaskUpdated(),
          TaskLoaded(allTasks),
        ],
        verify: (_) {
          verify(() => mockRepository.updateTask(updatedTask)).called(1);
          verify(() => mockRepository.getAllTasks(userId: updatedTask.userId))
              .called(1);
        },
      );
    });

    group('DeleteTaskEvent', () {
      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskDeleted] when task is deleted successfully',
        build: () {
          when(() => mockRepository.deleteTask(any()))
              .thenAnswer((_) async => Future.value());
          return taskBloc;
        },
        act: (bloc) => bloc.add(const DeleteTaskEvent('task-1')),
        expect: () => [
          const TaskLoading(),
          const TaskDeleted(),
        ],
        verify: (_) {
          verify(() => mockRepository.deleteTask('task-1')).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when DeleteTaskEvent fails',
        build: () {
          when(() => mockRepository.deleteTask(any()))
              .thenThrow(Exception('Failed to delete task'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const DeleteTaskEvent('task-1')),
        expect: () => [
          const TaskLoading(),
          TaskError('Exception: Failed to delete task'),
        ],
      );
    });

    group('CompleteTaskEvent', () {
      final task = TestHelpers.createTestTask(
        id: 'task-1',
        isCompleted: false,
      );
      final completedTask = task.copyWith(isCompleted: true);
      final allTasks = [completedTask];

      blocTest<TaskBloc, TaskState>(
        'emits [TaskCompleted, TaskLoaded] when task is completed successfully',
        build: () {
          when(() => mockRepository.getTaskById(any()))
              .thenAnswer((_) async => task);
          when(() => mockRepository.updateTask(any()))
              .thenAnswer((_) async => completedTask);
          when(() => mockRepository.getAllTasks(userId: any(named: 'userId')))
              .thenAnswer((_) async => allTasks);
          return taskBloc;
        },
        act: (bloc) => bloc.add(const CompleteTaskEvent('task-1')),
        expect: () => [
          const TaskCompleted(),
          TaskLoaded(allTasks),
        ],
        verify: (_) {
          verify(() => mockRepository.getTaskById('task-1')).called(1);
          verify(() => mockRepository.updateTask(any())).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskError] when task is not found',
        build: () {
          when(() => mockRepository.getTaskById(any()))
              .thenAnswer((_) async => null);
          return taskBloc;
        },
        act: (bloc) => bloc.add(const CompleteTaskEvent('non-existent')),
        expect: () => [],
      );
    });

    group('SearchTasksEvent', () {
      final allTasks = TestHelpers.createTestTaskList(5);
      final searchQuery = 'Task 2';

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoaded] with filtered tasks when search succeeds',
        build: () {
          when(() => mockRepository.getAllTasks())
              .thenAnswer((_) async => allTasks);
          return taskBloc;
        },
        act: (bloc) => bloc.add(SearchTasksEvent(searchQuery)),
        expect: () => [
          TaskLoaded([allTasks[2]]), // Should match "Task 2"
        ],
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskError] when search fails',
        build: () {
          when(() => mockRepository.getAllTasks())
              .thenThrow(Exception('Search failed'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(SearchTasksEvent(searchQuery)),
        expect: () => [
          TaskError('Exception: Search failed'),
        ],
      );
    });

    group('AddSubtaskEvent', () {
      final task = TestHelpers.createTestTask(id: 'task-1');
      final subtask = SubtaskEntity(
        id: 'subtask-1',
        title: 'New Subtask',
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final updatedTask = task.copyWith(subtasks: [subtask]);
      final allTasks = [updatedTask];

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskUpdated, TaskLoaded] when subtask is added successfully',
        build: () {
          when(() => mockRepository.getTaskById(any()))
              .thenAnswer((_) async => task);
          when(() => mockRepository.updateTask(any()))
              .thenAnswer((_) async => updatedTask);
          when(() => mockRepository.getAllTasks(userId: any(named: 'userId')))
              .thenAnswer((_) async => allTasks);
          return taskBloc;
        },
        act: (bloc) => bloc.add(AddSubtaskEvent(
          taskId: 'task-1',
          subtask: subtask,
        )),
        expect: () => [
          const TaskLoading(),
          const TaskUpdated(),
          TaskLoaded(allTasks),
        ],
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when task is not found',
        build: () {
          when(() => mockRepository.getTaskById(any()))
              .thenAnswer((_) async => null);
          return taskBloc;
        },
        act: (bloc) => bloc.add(AddSubtaskEvent(
          taskId: 'non-existent',
          subtask: subtask,
        )),
        expect: () => [
          const TaskLoading(),
          const TaskError('Görev bulunamadı'),
        ],
      );
    });
  });
}
