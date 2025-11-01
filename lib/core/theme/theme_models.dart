import 'package:flutter/material.dart';

/// Tema modeli - her tema için renk şeması
class AppThemeModel {
  final String id;
  final String name;
  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;
  final Color lightBackground;
  final Color darkBackground;

  const AppThemeModel({
    required this.id,
    required this.name,
    required this.lightColorScheme,
    required this.darkColorScheme,
    required this.lightBackground,
    required this.darkBackground,
  });
}

/// 22 tema tanımı
class AppThemes {
  static const List<AppThemeModel> allThemes = [
    // 1. Blue (Mavi)
    AppThemeModel(
      id: 'blue',
      name: 'Mavi',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF2196F3),
        secondary: Color(0xFF03A9F4),
        tertiary: Color(0xFF00BCD4),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF64B5F6),
        secondary: Color(0xFF4FC3F7),
        tertiary: Color(0xFF4DD0E1),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 2. Purple (Mor)
    AppThemeModel(
      id: 'purple',
      name: 'Mor',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF9C27B0),
        secondary: Color(0xFFBA68C8),
        tertiary: Color(0xFFAB47BC),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFCE93D8),
        secondary: Color(0xFFE1BEE7),
        tertiary: Color(0xFFF8BBD0),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 3. Green (Yeşil)
    AppThemeModel(
      id: 'green',
      name: 'Yeşil',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF4CAF50),
        secondary: Color(0xFF66BB6A),
        tertiary: Color(0xFF81C784),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF81C784),
        secondary: Color(0xFFA5D6A7),
        tertiary: Color(0xFFC8E6C9),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 4. Orange (Turuncu)
    AppThemeModel(
      id: 'orange',
      name: 'Turuncu',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFFFF9800),
        secondary: Color(0xFFFFB74D),
        tertiary: Color(0xFFFFCC80),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFFFB74D),
        secondary: Color(0xFFFFCC80),
        tertiary: Color(0xFFFFE0B2),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 5. Red (Kırmızı)
    AppThemeModel(
      id: 'red',
      name: 'Kırmızı',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFFF44336),
        secondary: Color(0xFFE57373),
        tertiary: Color(0xFFEF5350),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFE57373),
        secondary: Color(0xFFEF9A9A),
        tertiary: Color(0xFFFFCDD2),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 6. Pink (Pembe)
    AppThemeModel(
      id: 'pink',
      name: 'Pembe',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFFE91E63),
        secondary: Color(0xFFF06292),
        tertiary: Color(0xFFF48FB1),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFF06292),
        secondary: Color(0xFFF48FB1),
        tertiary: Color(0xFFF8BBD0),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 7. Teal (Turkuaz)
    AppThemeModel(
      id: 'teal',
      name: 'Turkuaz',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF009688),
        secondary: Color(0xFF4DB6AC),
        tertiary: Color(0xFF80CBC4),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF4DB6AC),
        secondary: Color(0xFF80CBC4),
        tertiary: Color(0xFFB2DFDB),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 8. Cyan (Cyan)
    AppThemeModel(
      id: 'cyan',
      name: 'Cyan',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF00BCD4),
        secondary: Color(0xFF4DD0E1),
        tertiary: Color(0xFF80DEEA),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF4DD0E1),
        secondary: Color(0xFF80DEEA),
        tertiary: Color(0xFFB2EBF2),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 9. Indigo (Çivit Mavi)
    AppThemeModel(
      id: 'indigo',
      name: 'Çivit Mavi',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF3F51B5),
        secondary: Color(0xFF5C6BC0),
        tertiary: Color(0xFF7986CB),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF7986CB),
        secondary: Color(0xFF9FA8DA),
        tertiary: Color(0xFFC5CAE9),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 10. Brown (Kahverengi)
    AppThemeModel(
      id: 'brown',
      name: 'Kahverengi',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF795548),
        secondary: Color(0xFF8D6E63),
        tertiary: Color(0xFFA1887F),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF8D6E63),
        secondary: Color(0xFFA1887F),
        tertiary: Color(0xFFBCAAA4),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 11. Grey (Gri)
    AppThemeModel(
      id: 'grey',
      name: 'Gri',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF607D8B),
        secondary: Color(0xFF78909C),
        tertiary: Color(0xFF90A4AE),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF78909C),
        secondary: Color(0xFF90A4AE),
        tertiary: Color(0xFFB0BEC5),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 12. Amber (Kehribar)
    AppThemeModel(
      id: 'amber',
      name: 'Kehribar',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFFFFC107),
        secondary: Color(0xFFFFD54F),
        tertiary: Color(0xFFFFE082),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFFFD54F),
        secondary: Color(0xFFFFE082),
        tertiary: Color(0xFFFFECB3),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 13. Deep Purple (Koyu Mor)
    AppThemeModel(
      id: 'deep_purple',
      name: 'Koyu Mor',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF673AB7),
        secondary: Color(0xFF9575CD),
        tertiary: Color(0xFFB39DDB),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF9575CD),
        secondary: Color(0xFFB39DDB),
        tertiary: Color(0xFFD1C4E9),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 14. Light Blue (Açık Mavi)
    AppThemeModel(
      id: 'light_blue',
      name: 'Açık Mavi',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF03A9F4),
        secondary: Color(0xFF29B6F6),
        tertiary: Color(0xFF4FC3F7),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF29B6F6),
        secondary: Color(0xFF4FC3F7),
        tertiary: Color(0xFF81D4FA),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 15. Lime (Limon)
    AppThemeModel(
      id: 'lime',
      name: 'Limon',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFFCDDC39),
        secondary: Color(0xFFD4E157),
        tertiary: Color(0xFFDCE775),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFD4E157),
        secondary: Color(0xFFDCE775),
        tertiary: Color(0xFFE6EE9C),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 16. Deep Orange (Koyu Turuncu)
    AppThemeModel(
      id: 'deep_orange',
      name: 'Koyu Turuncu',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFFFF5722),
        secondary: Color(0xFFFF7043),
        tertiary: Color(0xFFFF8A65),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFFF7043),
        secondary: Color(0xFFFF8A65),
        tertiary: Color(0xFFFFAB91),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 17. Blue Grey (Mavi Gri)
    AppThemeModel(
      id: 'blue_grey',
      name: 'Mavi Gri',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF455A64),
        secondary: Color(0xFF546E7A),
        tertiary: Color(0xFF607D8B),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF546E7A),
        secondary: Color(0xFF607D8B),
        tertiary: Color(0xFF78909C),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 18. Yellow (Sarı)
    AppThemeModel(
      id: 'yellow',
      name: 'Sarı',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFFFFEB3B),
        secondary: Color(0xFFFFF176),
        tertiary: Color(0xFFFFF59D),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFFFF176),
        secondary: Color(0xFFFFF59D),
        tertiary: Color(0xFFFFF9C4),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 19. Light Green (Açık Yeşil)
    AppThemeModel(
      id: 'light_green',
      name: 'Açık Yeşil',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF8BC34A),
        secondary: Color(0xFF9CCC65),
        tertiary: Color(0xFFAED581),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF9CCC65),
        secondary: Color(0xFFAED581),
        tertiary: Color(0xFFC5E1A5),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 20. Red Accent (Kırmızı Vurgu)
    AppThemeModel(
      id: 'red_accent',
      name: 'Kırmızı Vurgu',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFFFF1744),
        secondary: Color(0xFFFF5252),
        tertiary: Color(0xFFFF8A80),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFFFF5252),
        secondary: Color(0xFFFF8A80),
        tertiary: Color(0xFFFFCDD2),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 21. Green Accent (Yeşil Vurgu)
    AppThemeModel(
      id: 'green_accent',
      name: 'Yeşil Vurgu',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF00E676),
        secondary: Color(0xFF69F0AE),
        tertiary: Color(0xFFB9F6CA),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF69F0AE),
        secondary: Color(0xFFB9F6CA),
        tertiary: Color(0xFFC8E6C9),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),

    // 22. Blue Accent (Mavi Vurgu)
    AppThemeModel(
      id: 'blue_accent',
      name: 'Mavi Vurgu',
      lightColorScheme: ColorScheme.light(
        primary: Color(0xFF2979FF),
        secondary: Color(0xFF448AFF),
        tertiary: Color(0xFF82B1FF),
        error: Color(0xFFD32F2F),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212121),
      ),
      darkColorScheme: ColorScheme.dark(
        primary: Color(0xFF448AFF),
        secondary: Color(0xFF82B1FF),
        tertiary: Color(0xFFBBDEFB),
        error: Color(0xFFEF5350),
        surface: Color(0xFF1E1E1E),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onError: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
      ),
      lightBackground: Color(0xFFF5F5F5),
      darkBackground: Color(0xFF121212),
    ),
  ];

  /// ID'ye göre tema bul
  static AppThemeModel? getThemeById(String id) {
    try {
      return allThemes.firstWhere((theme) => theme.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Varsayılan tema
  static AppThemeModel get defaultTheme => allThemes[0]; // Blue
}

