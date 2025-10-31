import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

/// Base class for task states
abstract class TaskState extends Equatable {
  const TaskState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class TaskInitial extends TaskState {
  const TaskInitial();
}

/// Loading state
class TaskLoading extends TaskState {
  const TaskLoading();
}

/// Loaded state
class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  
  const TaskLoaded(this.tasks);
  
  @override
  List<Object?> get props => [tasks];
}

/// Error state
class TaskError extends TaskState {
  final String message;
  
  const TaskError(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Task created successfully
class TaskCreated extends TaskState {
  const TaskCreated();
}

/// Task updated successfully
class TaskUpdated extends TaskState {
  const TaskUpdated();
}

/// Task deleted successfully
class TaskDeleted extends TaskState {
  const TaskDeleted();
}

/// Task completed successfully
class TaskCompleted extends TaskState {
  const TaskCompleted();
}

