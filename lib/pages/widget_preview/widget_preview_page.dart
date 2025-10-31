import 'package:flutter/material.dart';
import '../../core/extensions/date_extensions.dart';
import '../../shared/models/task_model.dart';
import '../home/widgets/weekly_calendar_widget.dart';
import '../home/widgets/task_list_panel_widget.dart';

/// Widget önizleme ve tema ayarları sayfası
class WidgetPreviewPage extends StatefulWidget {
  const WidgetPreviewPage({super.key});

  @override
  State<WidgetPreviewPage> createState() => _WidgetPreviewPageState();
}

class _WidgetPreviewPageState extends State<WidgetPreviewPage> {
  // Tema ayarları
  int _selectedPrimaryColorIndex = 0;
  bool _useDarkMode = false;
  double _fontScale = 1.0;
  
  // Önizleme verileri
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate = DateTime.now();
  late List<TaskModel> _previewTasks;

  // Renk şemaları
  final List<ColorScheme> _colorSchemes = [
    // Mavi (varsayılan)
    const ColorScheme.light(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF00BCD4),
      tertiary: Color(0xFFFF5722),
    ),
    // Mor
    const ColorScheme.light(
      primary: Color(0xFF9C27B0),
      secondary: Color(0xFFBA68C8),
      tertiary: Color(0xFFE91E63),
    ),
    // Yeşil
    const ColorScheme.light(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFF81C784),
      tertiary: Color(0xFFFF9800),
    ),
    // Turuncu
    const ColorScheme.light(
      primary: Color(0xFFFF5722),
      secondary: Color(0xFFFF8A65),
      tertiary: Color(0xFFE91E63),
    ),
    // Kırmızı
    const ColorScheme.light(
      primary: Color(0xFFE91E63),
      secondary: Color(0xFFF06292),
      tertiary: Color(0xFFFF9800),
    ),
  ];

  final List<ColorScheme> _darkColorSchemes = [
    const ColorScheme.dark(
      primary: Color(0xFF64B5F6),
      secondary: Color(0xFF4DD0E1),
      tertiary: Color(0xFFFF7043),
    ),
    const ColorScheme.dark(
      primary: Color(0xFFBA68C8),
      secondary: Color(0xFFAB47BC),
      tertiary: Color(0xFFEC407A),
    ),
    const ColorScheme.dark(
      primary: Color(0xFF66BB6A),
      secondary: Color(0xFF81C784),
      tertiary: Color(0xFFFFB74D),
    ),
    const ColorScheme.dark(
      primary: Color(0xFFFF7043),
      secondary: Color(0xFFFF8A65),
      tertiary: Color(0xFFEC407A),
    ),
    const ColorScheme.dark(
      primary: Color(0xFFEC407A),
      secondary: Color(0xFFF48FB1),
      tertiary: Color(0xFFFFB74D),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPreviewTasks();
  }

  void _loadPreviewTasks() {
    final now = DateTime.now();
    _previewTasks = [
      TaskModel(
        id: '1',
        title: 'Toplantı hazırlığı',
        description: 'Sunum materyallerini hazırla',
        dueDate: now,
        isCompleted: false,
      ),
      TaskModel(
        id: '2',
        title: 'Rapor yazma',
        description: 'Aylık raporu tamamla',
        dueDate: now,
        isCompleted: true,
      ),
      TaskModel(
        id: '3',
        title: 'Müşteri görüşmesi',
        dueDate: now.add(const Duration(days: 1)),
        isCompleted: false,
      ),
      TaskModel(
        id: '4',
        title: 'Proje sunumu',
        description: 'Yeni proje sunumunu hazırla',
        dueDate: now.add(const Duration(days: 2)),
        isCompleted: false,
      ),
      TaskModel(
        id: '5',
        title: 'Ekip toplantısı',
        dueDate: now.add(const Duration(days: 3)),
        isCompleted: false,
      ),
    ];
  }

  ThemeData _getPreviewTheme() {
    final baseScheme = _useDarkMode
        ? _darkColorSchemes[_selectedPrimaryColorIndex]
        : _colorSchemes[_selectedPrimaryColorIndex];

    final colorScheme = ColorScheme(
      brightness: _useDarkMode ? Brightness.dark : Brightness.light,
      primary: baseScheme.primary,
      onPrimary: baseScheme.onPrimary,
      secondary: baseScheme.secondary,
      onSecondary: baseScheme.onSecondary,
      tertiary: baseScheme.tertiary,
      onTertiary: baseScheme.onTertiary,
      error: _useDarkMode ? const Color(0xFFEF5350) : const Color(0xFFD32F2F),
      onError: _useDarkMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      surface: _useDarkMode 
          ? const Color(0xFF1E1E1E) 
          : const Color(0xFFFFFFFF),
      onSurface: _useDarkMode 
          ? const Color(0xFFFFFFFF) 
          : const Color(0xFF212121),
      surfaceContainerHighest: _useDarkMode
          ? const Color(0xFF2C2C2C)
          : const Color(0xFFE8E8E8),
      onSurfaceVariant: _useDarkMode
          ? const Color(0xFFB0B0B0)
          : const Color(0xFF757575),
      outline: _useDarkMode
          ? const Color(0xFF424242)
          : const Color(0xFFE0E0E0),
      outlineVariant: _useDarkMode
          ? const Color(0xFF2C2C2C)
          : const Color(0xFFF5F5F5),
      primaryContainer: baseScheme.primary.withOpacity(0.1),
      onPrimaryContainer: baseScheme.primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: _useDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: _useDarkMode 
          ? const Color(0xFF121212) 
          : const Color(0xFFF5F5F5),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 57 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        displayMedium: TextStyle(
          fontSize: 45 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: 36 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: 32 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 28 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: 24 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 22 * _fontScale,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16 * _fontScale,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 14 * _fontScale,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 12 * _fontScale,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: 14 * _fontScale,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: 12 * _fontScale,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
        labelSmall: TextStyle(
          fontSize: 11 * _fontScale,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _handleTaskTap(TaskModel task) {
    // Önizleme için boş
  }

  void _handleTaskToggle(TaskModel task) {
    setState(() {
      final index = _previewTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _previewTasks[index] = TaskModel(
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widget Önizleme'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_today), text: 'Takvim'),
              Tab(icon: Icon(Icons.task), text: 'Görevler'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Ayarlar paneli
            _buildSettingsPanel(),
            
            // Önizleme alanı
            Expanded(
              child: Theme(
                data: _getPreviewTheme(),
                child: Container(
                  color: _useDarkMode 
                      ? const Color(0xFF121212) 
                      : const Color(0xFFF5F5F5),
                  child: TabBarView(
                    children: [
                      // Takvim önizleme
                      _buildCalendarPreview(),
                      
                      // Görev önizleme
                      _buildTaskPreview(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Renk şeması seçici
            _buildColorSchemeSelector(),
            const SizedBox(width: 16),
            
            // Dark mode toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _useDarkMode ? Icons.dark_mode : Icons.light_mode,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _useDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _useDarkMode = value;
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _useDarkMode ? 'Koyu' : 'Açık',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Font boyutu ayarı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.text_fields, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Font: ${(_fontScale * 100).toInt()}%',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(width: 8),
                  Slider(
                    value: _fontScale,
                    min: 0.8,
                    max: 1.5,
                    divisions: 14,
                    label: '${(_fontScale * 100).toInt()}%',
                    onChanged: (value) {
                      setState(() {
                        _fontScale = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSchemeSelector() {
    final schemes = _useDarkMode ? _darkColorSchemes : _colorSchemes;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.palette, size: 20),
          const SizedBox(width: 8),
          Text(
            'Tema:',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(width: 8),
          ...List.generate(schemes.length, (index) {
            final isSelected = _selectedPrimaryColorIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPrimaryColorIndex = index;
                });
              },
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: schemes[index].primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: schemes[index].primary.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCalendarPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Text(
            'Takvim Widget Önizlemesi',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Haftalık takvim widget\'ının canlı önizlemesi',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          
          // Widget önizleme kartı
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  WeeklyCalendarWidget(
                    selectedMonth: _selectedMonth,
                    selectedDate: _selectedDate,
                    onDateSelected: _handleDateSelected,
                    tasks: _previewTasks,
                  ),
                  const SizedBox(height: 16),
                  Divider(),
                  const SizedBox(height: 16),
                  
                  // Navigasyon kontrolleri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                              _selectedMonth.year,
                              _selectedMonth.month - 1,
                            );
                          });
                        },
                        tooltip: 'Önceki ay',
                      ),
                      Text(
                        '${_selectedMonth.month}/${_selectedMonth.year}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                              _selectedMonth.year,
                              _selectedMonth.month + 1,
                            );
                          });
                        },
                        tooltip: 'Sonraki ay',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Text(
            'Görev Widget Önizlemesi',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Görev listesi widget\'ının canlı önizlemesi',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          
          // Widget önizleme kartı
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarih seçici
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Önizleme Tarihi:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _selectedDate != null
                              ? _selectedDate!.toDateString()
                              : 'Tarih seç',
                        ),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(),
                  const SizedBox(height: 24),
                  
                  // Widget önizleme
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 500,
                      minHeight: 300,
                    ),
                    child: TaskListPanelWidget(
                      selectedDate: _selectedDate,
                      tasks: _previewTasks,
                      onTaskTap: _handleTaskTap,
                      onTaskToggle: _handleTaskToggle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
