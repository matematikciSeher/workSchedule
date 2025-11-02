import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/models/task_model.dart';
import '../../shared/widgets/decorative_background.dart';
import '../../features/task/bloc/task_bloc.dart';
import '../../features/task/bloc/task_event.dart';
import '../../features/task/bloc/task_state.dart';
import 'widgets/month_selector_widget.dart';
import 'widgets/weekly_calendar_widget.dart';
import 'widgets/task_list_panel_widget.dart';

/// Modern takvim ana ekranı - Material 3 tasarım prensipleriyle
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;
  late AnimationController _panelAnimationController;
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _panelAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _panelAnimationController.forward();

    // BLoC'tan görevleri yükle
    context.read<TaskBloc>().add(const LoadTasksEvent());
  }

  @override
  void dispose() {
    _panelAnimationController.dispose();
    super.dispose();
  }

  void _handleMonthChanged(DateTime newMonth) {
    setState(() {
      _selectedMonth = newMonth;
    });
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      // Panel animasyonu
      _panelAnimationController.forward(from: 0);
    });
  }

  void _handleTaskTap(TaskModel task) {
    // Görev detayına git veya düzenleme sayfasını aç
    Navigator.pushNamed(
      context,
      AppRoutes.taskEdit,
      arguments: task.id,
    ).then((_) {
      // Görev düzenlendikten sonra listeyi yenile
      context.read<TaskBloc>().add(const LoadTasksEvent());
    });
  }

  void _handleTaskDelete(TaskModel task) {
    // Silme onayı göster
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görevi Sil'),
        content: Text('${task.title} görevini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _handleTaskToggle(TaskModel task) {
    // BLoC üzerinden tamamlanma durumunu güncelle
    context.read<TaskBloc>().add(CompleteTaskEvent(task.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskLoaded) {
          // TaskEntity'leri TaskModel'e dönüştür
          setState(() {
            _tasks = state.tasks.map((entity) => TaskModel.fromEntity(entity)).toList();
          });
        } else if (state is TaskDeleted || state is TaskCompleted || state is TaskCreated || state is TaskUpdated) {
          // Görev silindikten, tamamlandıktan, oluşturulduktan veya güncellendikten sonra listeyi yenile
          context.read<TaskBloc>().add(const LoadTasksEvent());
        }
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          // State değiştiğinde görevleri güncelle (sadece UI güncellemesi için)
          List<TaskModel> currentTasks = _tasks;
          if (state is TaskLoaded) {
            currentTasks = state.tasks.map((entity) => TaskModel.fromEntity(entity)).toList();
          }
          
          return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      body: DecorativeBackground(
        style: BackgroundStyle.elegant,
        child: Column(
          children: [
            // AppBar
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AppBar(
                title: Text(
                  'Çalışma Takvimi',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.tertiaryContainer,
                          theme.colorScheme.primaryContainer,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.smart_toy_outlined),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.aiAssistant);
                      },
                      tooltip: 'AI Asistan',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.surfaceContainerHighest,
                          theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.settings);
                      },
                      tooltip: 'Ayarlar',
                    ),
                  ),
                ],
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  // 1. Ay Seçici (Üstte)
                  MonthSelectorWidget(
                    selectedMonth: _selectedMonth,
                    onMonthChanged: _handleMonthChanged,
                  ),

                  // 2. Haftalık Takvim Grid (Ortada)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: WeeklyCalendarWidget(
                        selectedMonth: _selectedMonth,
                        selectedDate: _selectedDate,
                        onDateSelected: _handleDateSelected,
                        tasks: currentTasks,
                      ),
                    ),
                  ),

                  // 3. Görev Listesi Paneli (Altta)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _panelAnimationController,
                      curve: Curves.easeOutCubic,
                    )),
                    child: FadeTransition(
                      opacity: _panelAnimationController,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: TaskListPanelWidget(
                          selectedDate: _selectedDate,
                          tasks: currentTasks,
                          onTaskTap: _handleTaskTap,
                          onTaskToggle: _handleTaskToggle,
                          onTaskDelete: _handleTaskDelete,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.taskForm).then((_) {
              // Yeni görev eklendikten sonra listeyi yenile
              context.read<TaskBloc>().add(const LoadTasksEvent());
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add),
          label: const Text('Yeni Görev'),
          tooltip: 'Yeni görev ekle',
        ),
      ),
          );
        },
      ),
    );
  }
}
