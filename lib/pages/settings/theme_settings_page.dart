import 'package:flutter/material.dart';
import '../../core/services/theme_service.dart';
import '../../core/theme/theme_models.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  final ThemeService _themeService = ThemeService();
  AppThemeModel? _selectedTheme;
  ThemeMode _themeMode = ThemeMode.system;
  double _textScaleFactor = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    final theme = await _themeService.getSelectedTheme();
    final themeMode = await _themeService.getThemeMode();
    final textScale = await _themeService.getTextScaleFactor();
    
    setState(() {
      _selectedTheme = theme;
      _themeMode = themeMode;
      _textScaleFactor = textScale;
      _isLoading = false;
    });
  }

  Future<void> _onThemeSelected(AppThemeModel theme) async {
    await _themeService.saveSelectedTheme(theme);
    setState(() => _selectedTheme = theme);
    
    // Uygulamayı yeniden başlatmak için Navigator kullanabilirsiniz
    // Veya bir state management kullanarak tüm uygulamayı güncelleyebilirsiniz
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tema "${theme.name}" seçildi'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _onThemeModeChanged(ThemeMode mode) async {
    await _themeService.saveThemeMode(mode);
    setState(() => _themeMode = mode);
  }

  Future<void> _onTextScaleChanged(double value) async {
    await _themeService.saveTextScaleFactor(value);
    setState(() => _textScaleFactor = value);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tema Ayarları')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tema ve Yazı Tipi Ayarları'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tema Modu Seçimi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tema Modu',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Açık'),
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Koyu'),
                        icon: Icon(Icons.dark_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('Sistem'),
                        icon: Icon(Icons.brightness_auto),
                      ),
                    ],
                    selected: {_themeMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      _onThemeModeChanged(newSelection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Yazı Tipi Boyutu
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yazı Tipi Boyutu',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_textScaleFactor * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _textScaleFactor,
                    min: 0.8,
                    max: 1.5,
                    divisions: 14,
                    label: '${(_textScaleFactor * 100).toStringAsFixed(0)}%',
                    onChanged: _onTextScaleChanged,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '80%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '150%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tema Renk Seçimi
          Text(
            'Tema Renkleri',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: AppThemes.allThemes.length,
            itemBuilder: (context, index) {
              final theme = AppThemes.allThemes[index];
              final isSelected = _selectedTheme?.id == theme.id;
              
              return InkWell(
                onTap: () => _onThemeSelected(theme),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.lightColorScheme.primary
                          : Theme.of(context).dividerColor,
                      width: isSelected ? 3 : 1,
                    ),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    children: [
                      // Renk önizlemesi
                      Container(
                        width: 60,
                        decoration: BoxDecoration(
                          color: theme.lightColorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(11),
                            bottomLeft: Radius.circular(11),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            isSelected ? Icons.check : null,
                            color: theme.lightColorScheme.onPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                theme.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              if (isSelected)
                                Text(
                                  'Seçili',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: theme.lightColorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Bilgilendirme
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tema değişikliklerinin tam olarak uygulanması için uygulamayı yeniden başlatmanız gerekebilir.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
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

