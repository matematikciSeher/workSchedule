import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

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

