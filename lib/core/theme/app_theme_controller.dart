import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import 'app_font_families.dart';
import 'theme_models.dart';

/// Tema ayarlarını yönetir ve değişiklikleri tüm uygulamaya yayar.
class AppThemeController extends ChangeNotifier {
  AppThemeController({ThemeService? themeService})
      : _themeService = themeService ?? ThemeService();

  final ThemeService _themeService;

  AppThemeModel _currentTheme = AppThemes.defaultTheme;
  ThemeMode _themeMode = ThemeMode.light;
  double _textScaleFactor = 1.0;
  AppFontFamily _fontFamily = AppFontFamilies.defaultFont;
  bool _isLoading = true;

  AppThemeModel get currentTheme => _currentTheme;
  ThemeMode get themeMode => _themeMode;
  double get textScaleFactor => _textScaleFactor;
  AppFontFamily get fontFamily => _fontFamily;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final theme = await _themeService.getSelectedTheme();
    final themeMode = await _themeService.getThemeMode();
    final textScale = await _themeService.getTextScaleFactor();
    final fontId = await _themeService.getFontFamilyId();

    _currentTheme = theme;
    _themeMode = _normalizeThemeMode(themeMode);
    _textScaleFactor = textScale;
    _fontFamily = AppFontFamilies.getById(fontId) ?? AppFontFamilies.defaultFont;
    _isLoading = false;
    notifyListeners();
  }

  ThemeMode _normalizeThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.system) return ThemeMode.light;
    return mode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _themeService.saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> setTheme(AppThemeModel theme) async {
    if (_currentTheme.id == theme.id) return;
    _currentTheme = theme;
    await _themeService.saveSelectedTheme(theme);
    notifyListeners();
  }

  Future<void> setTextScaleFactor(double factor) async {
    final clamped = factor.clamp(0.8, 1.5);
    if (_textScaleFactor == clamped) return;
    _textScaleFactor = clamped;
    await _themeService.saveTextScaleFactor(clamped);
    notifyListeners();
  }

  Future<void> setFontFamily(AppFontFamily font) async {
    if (_fontFamily.id == font.id) return;
    _fontFamily = font;
    await _themeService.saveFontFamilyId(font.id);
    notifyListeners();
  }
}

/// [AppThemeController]'a alt widget ağacından erişim sağlar.
class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({
    super.key,
    required AppThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppThemeController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null, 'AppThemeScope bulunamadı');
    return controller!;
  }

  static AppThemeController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppThemeScope>()
        ?.notifier;
  }
}
