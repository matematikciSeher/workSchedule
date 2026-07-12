import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/task/bloc/task_bloc.dart';
import '../../features/task/bloc/task_event.dart';
import '../../features/task/bloc/task_state.dart';
import '../../domain/entities/task_entity.dart';
import '../../shared/widgets/decorative_background.dart';
import '../../l10n/app_localizations.dart';
import '../../core/locale/theme_localizations.dart';
import 'task_form_page.dart';

/// Görev listesi sayfası
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myTasks),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: DecorativeBackground(
        style: BackgroundStyle.modern,
        child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.errorWithMessage(state.message)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(const LoadTasksEvent());
                    },
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            );
          }

          if (state is TaskLoaded) {
            final tasks = state.tasks;

            if (tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.task_alt, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noTasksYet,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.addTaskTapPlus,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _TaskListItem(task: task);
              },
            );
          }

          // Initial state - Load tasks
          if (state is TaskInitial) {
            context.read<TaskBloc>().add(const LoadTasksEvent());
          }

          return const SizedBox.shrink();
        },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.tertiary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormPage(),
            ),
          ).then((_) {
            // Görev eklendikten sonra listeyi yenile
            context.read<TaskBloc>().add(const LoadTasksEvent());
          });
        },
        child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// Görev listesi öğesi widget'ı
class _TaskListItem extends StatelessWidget {
  final TaskEntity task;

  const _TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            context.read<TaskBloc>().add(CompleteTaskEvent(task.id));
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (task.dueDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            if (task.priority != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _PriorityChip(priority: task.priority!),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(width: 8),
                  Text(l10n.edit),
                ],
              ),
              onTap: () {
                Future.delayed(
                  const Duration(milliseconds: 100),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskFormPage(taskId: task.id),
                      ),
                    ).then((_) {
                      context.read<TaskBloc>().add(const LoadTasksEvent());
                    });
                  },
                );
              },
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                ],
              ),
              onTap: () {
                Future.delayed(
                  const Duration(milliseconds: 100),
                  () {
                    _showDeleteDialog(context, task);
                  },
                );
              },
            ),
          ],
        ),
        onTap: () {
          // Görev detayına git (ileride eklenebilir)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFormPage(taskId: task.id),
            ),
          ).then((_) {
            context.read<TaskBloc>().add(const LoadTasksEvent());
          });
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TaskEntity task) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTaskTitle),
        content: Text(l10n.deleteTaskConfirm(task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.taskDeleted)),
              );
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// Öncelik chip widget'ı
class _PriorityChip extends StatelessWidget {
  final int priority;

  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color color;

    switch (priority) {
      case 1:
        color = Colors.green;
        break;
      case 2:
        color = Colors.orange;
        break;
      case 3:
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        localizedPriority(l10n, priority),
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
