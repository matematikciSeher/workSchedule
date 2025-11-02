import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../../core/services/task_notification_helper.dart';
import 'task_event.dart';
import 'task_state.dart';

/// Task BLoC for managing task state
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  final TaskNotificationHelper _notificationHelper = TaskNotificationHelper();

  TaskBloc(this.taskRepository) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<CompleteTaskEvent>(_onCompleteTask);
    on<SearchTasksEvent>(_onSearchTasks);
    on<AddSubtaskEvent>(_onAddSubtask);
    on<UpdateSubtaskEvent>(_onUpdateSubtask);
    on<DeleteSubtaskEvent>(_onDeleteSubtask);
    on<CompleteSubtaskEvent>(_onCompleteSubtask);
    on<SetRecurrenceEvent>(_onSetRecurrence);
  }
  
  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final tasks = await taskRepository.getAllTasks(userId: event.userId);
      
      // Mevcut görevler için bildirimleri kontrol et ve gerekirse zamanla
      // (Uygulama yeniden başlatıldığında bildirimlerin yeniden zamanlanması için)
      // Async olarak arka planda yap, görev yüklemesini yavaşlatmasın
      Future.microtask(() async {
        for (final task in tasks) {
          if (!task.isCompleted && task.dueDate != null) {
            // Bildirim zamanlamayı dene (zaten varsa sorun olmaz)
            try {
              await _notificationHelper.scheduleTaskNotification(task);
            } catch (e) {
              // Bildirim hatası görev yüklemesini engellemesin
              // ignore: avoid_print
              print('Bildirim zamanlama hatası (${task.id}): $e');
            }
          }
        }
      });
      
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
  
  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final createdTask = await taskRepository.createTask(event.task);
      
      // Bildirim zamanlamayı arka planda yap (kaydetme hızını etkilemesin)
      _notificationHelper.scheduleTaskNotification(createdTask).catchError((e) {
        print('Bildirim zamanlama hatası (arka plan): $e');
      });
      
      emit(const TaskCreated());
      // Reload tasks after creation
      final tasks = await taskRepository.getAllTasks(userId: event.task.userId);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
  
  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final updatedTask = await taskRepository.updateTask(event.task);
      
      // Bildirimleri güncellemeyi arka planda yap
      _notificationHelper.updateTaskNotification(updatedTask).catchError((e) {
        print('Bildirim güncelleme hatası (arka plan): $e');
      });
      
      emit(const TaskUpdated());
      // Reload tasks after update
      final tasks = await taskRepository.getAllTasks(userId: event.task.userId);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
  
  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      // Önce görevi al (userId ve bildirim iptali için)
      final task = await taskRepository.getTaskById(event.taskId);
      
      // Bildirimleri iptal et
      if (task != null) {
        await _notificationHelper.cancelTaskNotifications(task);
      }
      
      await taskRepository.deleteTask(event.taskId);
      emit(const TaskDeleted());
      // Reload tasks after deletion
      if (task != null) {
        final tasks = await taskRepository.getAllTasks(userId: task.userId);
        emit(TaskLoaded(tasks));
      } else {
        final tasks = await taskRepository.getAllTasks();
        emit(TaskLoaded(tasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
  
  Future<void> _onCompleteTask(
    CompleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        final updatedTask = task.copyWith(
          isCompleted: !task.isCompleted,
          updatedAt: DateTime.now(),
        );
        final savedTask = await taskRepository.updateTask(updatedTask);
        
        // Bildirimleri güncelle (tamamlandıysa iptal edilecek)
        await _notificationHelper.updateTaskNotification(savedTask);
        
        emit(const TaskCompleted());
        // Reload tasks after completion
        final tasks = await taskRepository.getAllTasks(userId: task.userId);
        emit(TaskLoaded(tasks));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
  
  Future<void> _onSearchTasks(
    SearchTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      // Get all tasks and filter locally
      final allTasks = await taskRepository.getAllTasks();
      final filteredTasks = allTasks.where((task) {
        return task.title.toLowerCase().contains(event.query.toLowerCase()) ||
            (task.description?.toLowerCase().contains(event.query.toLowerCase()) ?? false);
      }).toList();
      emit(TaskLoaded(filteredTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// Add subtask handler
  Future<void> _onAddSubtask(
    AddSubtaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        final updatedSubtasks = [...task.subtasks, event.subtask];
        final updatedTask = task.copyWith(
          subtasks: updatedSubtasks,
          updatedAt: DateTime.now(),
        );
        await taskRepository.updateTask(updatedTask);
        emit(const TaskUpdated());
        // Reload tasks
        final tasks = await taskRepository.getAllTasks(userId: task.userId);
        emit(TaskLoaded(tasks));
      } else {
        emit(TaskError('Görev bulunamadı'));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// Update subtask handler
  Future<void> _onUpdateSubtask(
    UpdateSubtaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        final updatedSubtasks = task.subtasks.map((subtask) {
          return subtask.id == event.subtask.id ? event.subtask : subtask;
        }).toList();
        final updatedTask = task.copyWith(
          subtasks: updatedSubtasks,
          updatedAt: DateTime.now(),
        );
        await taskRepository.updateTask(updatedTask);
        emit(const TaskUpdated());
        // Reload tasks
        final tasks = await taskRepository.getAllTasks(userId: task.userId);
        emit(TaskLoaded(tasks));
      } else {
        emit(TaskError('Görev bulunamadı'));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// Delete subtask handler
  Future<void> _onDeleteSubtask(
    DeleteSubtaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        final updatedSubtasks = task.subtasks
            .where((subtask) => subtask.id != event.subtaskId)
            .toList();
        final updatedTask = task.copyWith(
          subtasks: updatedSubtasks,
          updatedAt: DateTime.now(),
        );
        await taskRepository.updateTask(updatedTask);
        emit(const TaskUpdated());
        // Reload tasks
        final tasks = await taskRepository.getAllTasks(userId: task.userId);
        emit(TaskLoaded(tasks));
      } else {
        emit(TaskError('Görev bulunamadı'));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// Complete subtask handler
  Future<void> _onCompleteSubtask(
    CompleteSubtaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        final updatedSubtasks = task.subtasks.map((subtask) {
          if (subtask.id == event.subtaskId) {
            return subtask.copyWith(
              isCompleted: !subtask.isCompleted,
              updatedAt: DateTime.now(),
            );
          }
          return subtask;
        }).toList();
        final updatedTask = task.copyWith(
          subtasks: updatedSubtasks,
          updatedAt: DateTime.now(),
        );
        await taskRepository.updateTask(updatedTask);
        emit(const TaskUpdated());
        // Reload tasks
        final tasks = await taskRepository.getAllTasks(userId: task.userId);
        emit(TaskLoaded(tasks));
      } else {
        emit(TaskError('Görev bulunamadı'));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// Set recurrence handler
  Future<void> _onSetRecurrence(
    SetRecurrenceEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        final updatedTask = task.copyWith(
          isRecurring: event.isRecurring,
          recurringPattern: event.recurringPattern,
          recurringEndDate: event.recurringEndDate,
          updatedAt: DateTime.now(),
        );
        await taskRepository.updateTask(updatedTask);
        emit(const TaskUpdated());
        // Reload tasks
        final tasks = await taskRepository.getAllTasks(userId: task.userId);
        emit(TaskLoaded(tasks));
      } else {
        emit(TaskError('Görev bulunamadı'));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}

