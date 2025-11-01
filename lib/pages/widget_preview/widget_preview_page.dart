import 'package:flutter/material.dart';
import '../../shared/models/task_model.dart';
import '../../pages/home/widgets/weekly_calendar_widget.dart';
import '../../pages/home/widgets/task_list_panel_widget.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';

/// Widget önizleme sayfası - Tema ve görünüm ayarlarıyla
class WidgetPreviewPage extends StatefulWidget {
  const WidgetPreviewPage({super.key});

  @override
  State<WidgetPreviewPage> createState() => _WidgetPreviewPageState();
}

class _WidgetPreviewPageState extends State<WidgetPreviewPage> {
  // Tema ayarları
  bool _isDarkMode = false;
  Color _primaryColor = AppColors.lightPrimary;
  Color _secondaryColor = AppColors.lightSecondary;
  
  // Widget durumları
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate = DateTime.now();
  List<TaskModel> _sampleTasks = [];
  
  // Renk paleti seçenekleri
  final List<ColorPreset> _colorPresets = [
    ColorPreset('Mavi', AppColors.lightPrimary, AppColors.lightSecondary),
    ColorPreset('Yeşil', const Color(0xFF4CAF50), const Color(0xFF81C784)),
    ColorPreset('Mor', const Color(0xFF9C27B0), const Color(0xFFBA68C8)),
    ColorPreset('Turuncu', const Color(0xFFFF9800), const Color(0xFFFFB74D)),
    ColorPreset('Kırmızı', const Color(0xFFE91E63), const Color(0xFFF06292)),
    ColorPreset('Turkuaz', const Color(0xFF00BCD4), const Color(0xFF4DD0E1)),
  ];

  @override
  void initState() {
    super.initState();
    _loadSampleTasks();
  }

  void _loadSampleTasks() {
    final now = DateTime.now();
    setState(() {
      _sampleTasks = [
        TaskModel(
          id: '1',
          title: 'Toplantıya hazırlan',
          description: 'Sunum materyallerini kontrol et',
          dueDate: now.copyWith(hour: 10, minute: 0),
          isCompleted: false,
        ),
        TaskModel(
          id: '2',
          title: 'E-posta yanıtla',
          description: 'Müşteri sorularını yanıtla',
          dueDate: now.copyWith(hour: 14, minute: 30),
          isCompleted: true,
        ),
        TaskModel(
          id: '3',
          title: 'Raporu tamamla',
          description: 'Aylık satış raporunu hazırla',
          dueDate: now.copyWith(hour: 16, minute: 0),
          isCompleted: false,
        ),
        TaskModel(
          id: '4',
          title: 'Spor yap',
          dueDate: now.copyWith(hour: 18, minute: 0),
          isCompleted: false,
        ),
      ];
    });
  }

  ThemeData _getCurrentTheme() {
    return _isDarkMode 
        ? darkTheme(1.0).copyWith(
            colorScheme: ColorScheme.dark(
              primary: _primaryColor,
              secondary: _secondaryColor,
              surface: AppColors.darkSurface,
              onPrimary: AppColors.darkOnPrimary,
              onSecondary: AppColors.darkOnSecondary,
              onSurface: AppColors.darkOnSurface,
            ),
          )
        : lightTheme(1.0).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              secondary: _secondaryColor,
              surface: AppColors.lightSurface,
              onPrimary: AppColors.lightOnPrimary,
              onSecondary: AppColors.lightOnSecondary,
              onSurface: AppColors.lightOnSurface,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _getCurrentTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widget Önizleme'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                  // Tema değiştiğinde renkleri de güncelle
                  if (_isDarkMode) {
                    _primaryColor = AppColors.darkPrimary;
                    _secondaryColor = AppColors.darkSecondary;
                  } else {
                    _primaryColor = AppColors.lightPrimary;
                    _secondaryColor = AppColors.lightSecondary;
                  }
                });
              },
              tooltip: _isDarkMode ? 'Açık Tema' : 'Koyu Tema',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 900;
              
              if (isWideScreen) {
                // Geniş ekranlarda yatay düzen
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sol panel - Tema ayarları
                    Container(
                      width: 320,
                      decoration: BoxDecoration(
                        color: _isDarkMode 
                            ? AppColors.darkSurface 
                            : AppColors.lightSurface,
                        border: Border(
                          right: BorderSide(
                            color: _isDarkMode 
                                ? AppColors.dividerDark 
                                : AppColors.dividerLight,
                            width: 1,
                          ),
                        ),
                      ),
                      child: _buildSettingsPanel(),
                    ),
                    
                    // Sağ panel - Widget önizlemesi
                    Expanded(
                      child: Container(
                        color: _isDarkMode 
                            ? AppColors.darkBackground 
                            : AppColors.lightBackground,
                        child: _buildPreviewArea(),
                      ),
                    ),
                  ],
                );
              } else {
                // Küçük ekranlarda dikey düzen
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Üst panel - Tema ayarları
                    Container(
                      decoration: BoxDecoration(
                        color: _isDarkMode 
                            ? AppColors.darkSurface 
                            : AppColors.lightSurface,
                        border: Border(
                          bottom: BorderSide(
                            color: _isDarkMode 
                                ? AppColors.dividerDark 
                                : AppColors.dividerLight,
                            width: 1,
                          ),
                        ),
                      ),
                      child: _buildSettingsPanel(),
                    ),
                    
                    // Alt panel - Widget önizlemesi
                    Container(
                      color: _isDarkMode 
                          ? AppColors.darkBackground 
                          : AppColors.lightBackground,
                      child: _buildPreviewArea(),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Başlık
          Text(
            'Tema Ayarları',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 24),
        
        // Tema modu
        _buildSectionTitle('Görünüm Modu'),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment<bool>(
              value: false,
              label: Text('Açık'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment<bool>(
              value: true,
              label: Text('Koyu'),
              icon: Icon(Icons.dark_mode),
            ),
          ],
          selected: {_isDarkMode},
          onSelectionChanged: (Set<bool> selected) {
            setState(() {
              _isDarkMode = selected.first;
              if (_isDarkMode) {
                _primaryColor = AppColors.darkPrimary;
                _secondaryColor = AppColors.darkSecondary;
              } else {
                _primaryColor = AppColors.lightPrimary;
                _secondaryColor = AppColors.lightSecondary;
              }
            });
          },
        ),
        
        const SizedBox(height: 32),
        
        // Renk şeması
        _buildSectionTitle('Renk Şeması'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: _colorPresets.map((preset) {
            final isSelected = _primaryColor == preset.primary;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _primaryColor = preset.primary;
                  _secondaryColor = preset.secondary;
                });
              },
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 70,
                  maxWidth: 85,
                  minHeight: 80,
                  maxHeight: 85,
                ),
                decoration: BoxDecoration(
                  color: preset.primary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: preset.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: preset.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        preset.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 32),
        
        // Önizleme kontrolleri
        _buildSectionTitle('Önizleme Kontrolleri'),
        const SizedBox(height: 12),
        
        // Tarih seçici
        Card(
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text(
              'Ay Seç',
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${_selectedMonth.month}/${_selectedMonth.year}',
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedMonth,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                setState(() {
                  _selectedMonth = date;
                  _selectedDate = date;
                });
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Bugünü seç
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                final now = DateTime.now();
                _selectedMonth = now;
                _selectedDate = now;
              });
            },
            icon: const Icon(Icons.today),
            label: const Text(
              'Bugünü Seç',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Örnek görevler
        _buildSectionTitle('Örnek Görevler'),
        const SizedBox(height: 8),
        Text(
          '${_sampleTasks.length} görev yüklendi',
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _loadSampleTasks();
            },
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Yenile',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPreviewArea() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
            // Başlık
            Text(
              'Canlı Önizleme',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'Takvim ve görev widgetlarının görünümünü buradan önizleyebilirsiniz.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          
          const SizedBox(height: 32),
          
          // Takvim widget önizlemesi
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Takvim Widget',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: WeeklyCalendarWidget(
                      selectedMonth: _selectedMonth,
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                          _selectedMonth = DateTime(date.year, date.month);
                        });
                      },
                      tasks: _sampleTasks,
                      locale: const Locale('tr', 'TR'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Görev listesi widget önizlemesi
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.task_alt,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Görev Listesi Widget',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TaskListPanelWidget(
                    selectedDate: _selectedDate,
                    tasks: _sampleTasks,
                    neverScroll: true,
                    onTaskTap: (task) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Görev tıklandı: ${task.title}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    onTaskToggle: (task) {
                      setState(() {
                        final index = _sampleTasks.indexWhere((t) => t.id == task.id);
                        if (index != -1) {
                          _sampleTasks[index] = TaskModel(
                            id: task.id,
                            title: task.title,
                            description: task.description,
                            dueDate: task.dueDate,
                            isCompleted: !task.isCompleted,
                            color: task.color,
                          );
                        }
                      });
                    },
                    locale: const Locale('tr', 'TR'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Bilgi kartı
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tema ayarlarınızı değiştirerek widgetların farklı görünümlerini test edebilirsiniz.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }
}

/// Renk paleti modeli
class ColorPreset {
  final String name;
  final Color primary;
  final Color secondary;

  ColorPreset(this.name, this.primary, this.secondary);
}
