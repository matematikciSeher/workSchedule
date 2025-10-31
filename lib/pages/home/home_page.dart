import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/models/task_model.dart';
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
  final List<TaskModel> _tasks = [];

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

    // Örnek görevler (gerçek uygulamada BLoC'tan gelecek)
    _loadSampleTasks();
  }

  void _loadSampleTasks() {
    final now = DateTime.now();
    setState(() {
      _tasks.addAll([
        TaskModel(
          id: '1',
          title: 'Toplantı hazırlığı',
          description: 'Sunum dosyalarını hazırla',
          dueDate: DateTime(now.year, now.month, now.day, 10, 0),
          color: '#2196F3',
        ),
        TaskModel(
          id: '2',
          title: 'E-posta kontrolü',
          dueDate: DateTime(now.year, now.month, now.day, 14, 30),
          color: '#00BCD4',
        ),
        TaskModel(
          id: '3',
          title: 'Proje raporu',
          description: 'Aylık proje raporunu tamamla',
          dueDate: DateTime(now.year, now.month, now.day, 16, 0),
          color: '#FF5722',
        ),
        // Yarın için görevler
        TaskModel(
          id: '4',
          title: 'Müşteri görüşmesi',
          description: 'Yeni müşteri ile ilk görüşme',
          dueDate: DateTime(now.year, now.month, now.day + 1, 11, 0),
          color: '#4CAF50',
        ),
      ]);
    });
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
    );
  }

  void _handleTaskToggle(TaskModel task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          createdAt: task.createdAt,
          isCompleted: !task.isCompleted,
          color: task.color,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Çalışma Takvimi',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
            tooltip: 'Ayarlar',
          ),
        ],
        elevation: 0,
      ),
      body: Column(
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
                tasks: _tasks,
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
                  tasks: _tasks,
                  onTaskTap: _handleTaskTap,
                  onTaskToggle: _handleTaskToggle,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.taskForm);
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Görev'),
        tooltip: 'Yeni görev ekle',
      ),
    );
  }
}
