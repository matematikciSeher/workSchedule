import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/theme_models.dart';

/// Tema ve yazı tipi boyutu yönetim servisi
class ThemeService {
  static const String _keySelectedTheme = 'selected_theme';
  static const String _keyTextScaleFactor = 'text_scale_factor';
  static const String _keyThemeMode = 'theme_mode';

  /// SharedPreferences instance
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Seçili temayı getir
  Future<AppThemeModel> getSelectedTheme() async {
    final prefs = await _prefs;
    final themeId = prefs.getString(_keySelectedTheme);
    
    if (themeId != null) {
      final theme = AppThemes.getThemeById(themeId);
      if (theme != null) return theme;
    }
    
    return AppThemes.defaultTheme;
  }

  /// Temayı kaydet
  Future<void> saveSelectedTheme(AppThemeModel theme) async {
    final prefs = await _prefs;
    await prefs.setString(_keySelectedTheme, theme.id);
  }

  /// Tema modunu getir (light/dark/system)
  Future<ThemeMode> getThemeMode() async {
    final prefs = await _prefs;
    final modeString = prefs.getString(_keyThemeMode) ?? 'system';
    
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Tema modunu kaydet
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await _prefs;
    String modeString;
    
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    
    await prefs.setString(_keyThemeMode, modeString);
  }

  /// Yazı tipi boyutunu getir
  Future<double> getTextScaleFactor() async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyTextScaleFactor) ?? 1.0;
  }

  /// Yazı tipi boyutunu kaydet
  Future<void> saveTextScaleFactor(double factor) async {
    final prefs = await _prefs;
    // 0.8 ile 1.5 arasında sınırla
    final clampedFactor = factor.clamp(0.8, 1.5);
    await prefs.setDouble(_keyTextScaleFactor, clampedFactor);
  }
}

