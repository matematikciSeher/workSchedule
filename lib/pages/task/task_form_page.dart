import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/task/bloc/task_bloc.dart';
import '../../features/task/bloc/task_event.dart';
import '../../features/task/bloc/task_state.dart';
import '../../domain/entities/task_entity.dart';
import '../../shared/widgets/decorative_background.dart';
import '../../core/services/task_notification_helper.dart';

class TaskFormPage extends StatefulWidget {
  final String? taskId; // null ise yeni görev, değilse düzenleme

  const TaskFormPage({
    super.key,
    this.taskId,
  });

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedPriority; // 1: Düşük, 2: Orta, 3: Yüksek
  bool _isLoading = false;
  TaskEntity? _existingTask;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _loadTask();
    }
  }

  Future<void> _loadTask() async {
    final task = await context.read<TaskBloc>().taskRepository.getTaskById(widget.taskId!);
    if (task != null && mounted) {
      setState(() {
        _existingTask = task;
        _titleController.text = task.title;
        _descriptionController.text = task.description ?? '';
        _selectedDate = task.dueDate;
        if (task.dueDate != null) {
          _selectedTime = TimeOfDay.fromDateTime(task.dueDate!);
        }
        _selectedPriority = task.priority;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    DateTime? dueDate;
    if (_selectedDate != null) {
      if (_selectedTime != null) {
        dueDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
      } else {
        dueDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
        );
      }
    }

    final now = DateTime.now();
    final task = TaskEntity(
      id: widget.taskId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      dueDate: dueDate,
      createdAt: _existingTask?.createdAt ?? now,
      updatedAt: now,
      isCompleted: _existingTask?.isCompleted ?? false,
      priority: _selectedPriority,
    );

    if (widget.taskId != null) {
      context.read<TaskBloc>().add(UpdateTaskEvent(task));
    } else {
      context.read<TaskBloc>().add(CreateTaskEvent(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskId != null;

    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskCreated || state is TaskUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing ? 'Görev güncellendi' : 'Görev eklendi'),
            ),
          );
          Navigator.pop(context);
        } else if (state is TaskError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hata: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Görevi Düzenle' : 'Yeni Görev'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: false,
        body: DecorativeBackground(
          style: BackgroundStyle.calm,
          child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen başlık girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Tarih'),
                subtitle: Text(
                  _selectedDate == null
                      ? 'Tarih seçilmedi'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              ListTile(
                title: const Text('Saat'),
                subtitle: Text(
                  _selectedTime == null
                      ? 'Saat seçilmedi'
                      : _selectedTime!.format(context),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _selectTime,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveTask,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Güncelle' : 'Kaydet'),
              ),
              // Test butonu (sadece debug için)
              if (!isEditing && _selectedTime != null && _selectedDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // Test için 1 dakika sonra bildirim gönder
                      final testTime = DateTime.now().add(const Duration(minutes: 1));
                      final task = TaskEntity(
                        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
                        title: 'Test Görevi',
                        description: 'Bu bir test görevidir',
                        dueDate: testTime,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      try {
                        await Future.microtask(() async {
                          final helper = TaskNotificationHelper();
                          await helper.scheduleTaskNotification(task);
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Test bildirimi zamanlandı! 1 dakika sonra gelecek.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Test hatası: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.bug_report, size: 16),
                    label: const Text('Test Bildirimi (1 dk)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                  ),
                ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

