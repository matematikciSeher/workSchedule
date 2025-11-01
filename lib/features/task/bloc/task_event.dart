import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/entities/subtask_entity.dart';

/// Base class for task events
abstract class TaskEvent extends Equatable {
  const TaskEvent();
  
  @override
  List<Object?> get props => [];
}

/// Load all tasks event
class LoadTasksEvent extends TaskEvent {
  final String? userId;
  
  const LoadTasksEvent({this.userId});
  
  @override
  List<Object?> get props => [userId];
}

/// Create task event
class CreateTaskEvent extends TaskEvent {
  final TaskEntity task;
  
  const CreateTaskEvent(this.task);
  
  @override
  List<Object?> get props => [task];
}

/// Update task event
class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  
  const UpdateTaskEvent(this.task);
  
  @override
  List<Object?> get props => [task];
}

/// Delete task event
class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  
  const DeleteTaskEvent(this.taskId);
  
  @override
  List<Object?> get props => [taskId];
}

/// Mark task as complete event
class CompleteTaskEvent extends TaskEvent {
  final String taskId;
  
  const CompleteTaskEvent(this.taskId);
  
  @override
  List<Object?> get props => [taskId];
}

/// Search tasks event
class SearchTasksEvent extends TaskEvent {
  final String query;
  
  const SearchTasksEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}

/// Add subtask event
class AddSubtaskEvent extends TaskEvent {
  final String taskId;
  final SubtaskEntity subtask;
  
  const AddSubtaskEvent({
    required this.taskId,
    required this.subtask,
  });
  
  @override
  List<Object?> get props => [taskId, subtask];
}

/// Update subtask event
class UpdateSubtaskEvent extends TaskEvent {
  final String taskId;
  final SubtaskEntity subtask;
  
  const UpdateSubtaskEvent({
    required this.taskId,
    required this.subtask,
  });
  
  @override
  List<Object?> get props => [taskId, subtask];
}

/// Delete subtask event
class DeleteSubtaskEvent extends TaskEvent {
  final String taskId;
  final String subtaskId;
  
  const DeleteSubtaskEvent({
    required this.taskId,
    required this.subtaskId,
  });
  
  @override
  List<Object?> get props => [taskId, subtaskId];
}

/// Complete subtask event
class CompleteSubtaskEvent extends TaskEvent {
  final String taskId;
  final String subtaskId;
  
  const CompleteSubtaskEvent({
    required this.taskId,
    required this.subtaskId,
  });
  
  @override
  List<Object?> get props => [taskId, subtaskId];
}

/// Set recurrence event
class SetRecurrenceEvent extends TaskEvent {
  final String taskId;
  final bool isRecurring;
  final String? recurringPattern; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime? recurringEndDate;
  
  const SetRecurrenceEvent({
    required this.taskId,
    required this.isRecurring,
    this.recurringPattern,
    this.recurringEndDate,
  });
  
  @override
  List<Object?> get props => [taskId, isRecurring, recurringPattern, recurringEndDate];
}

