# Responsive ve Tema Destekli UI Mimarisi

Bu mimari, Flutter uygulamanızda **responsive tasarım** ve **tema yönetimi** için kapsamlı bir çözüm sunar.

## 🎨 Özellikler

- ✅ **Light/Dark Tema** - Otomatik tema geçişi
- ✅ **Özel Renk Paleti** - Tutarlı renk sistemi
- ✅ **Responsive Tasarım** - Mobile, Tablet, Desktop desteği
- ✅ **Dinamik Font Boyutları** - Cihaz tipine göre otomatik scaling
- ✅ **Riverpod State Management** - Performanslı state yönetimi
- ✅ **SharedPreferences** - Tema tercihlerinin kalıcı saklanması

## 📁 Mimarı Yapısı

```
lib/core/
├── theme/
│   ├── app_colors.dart          # Tema renk paletleri
│   ├── app_text_styles.dart     # Responsive text stilleri
│   ├── app_theme.dart           # Light/Dark tema tanımları
│   └── theme_provider.dart      # Tema state yönetimi
├── responsive/
│   └── responsive_provider.dart # Responsive state yönetimi
└── widgets/
    ├── responsive_layout.dart   # Responsive layout widget'ları
    └── theme_wrapper.dart       # Tema wrapper widget'ları
```

## 🚀 Kullanım

### 1. Temel Kullanım

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/widgets/responsive_layout.dart';
import 'core/responsive/responsive_provider.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    
    return Scaffold(
      body: ResponsiveLayout(
        child: Container(
          padding: EdgeInsets.all(responsive.horizontalPadding),
          child: Text(
            'Responsive Text',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
```

### 2. Tema Değiştirme

```dart
import 'core/widgets/theme_wrapper.dart';

// Tema toggle button
ThemeToggleButton()

// Programatik tema değiştirme
ref.read(themeProvider.notifier).setLightTheme();
ref.read(themeProvider.notifier).setDarkTheme();
ref.read(themeProvider.notifier).toggleTheme();
```

### 3. Responsive Conditional Rendering

```dart
ResponsiveConditional(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

### 4. Responsive Builder

```dart
ResponsiveBuilder(
  builder: (context, responsive) {
    return GridView.count(
      crossAxisCount: responsive.gridColumns,
      children: [...],
    );
  },
)
```

### 5. Tema Bilgilerine Erişim

```dart
// Context extension ile
final responsive = context.responsive;
final themeData = context.themeData;
final deviceType = context.deviceType;

// WidgetRef extension ile
final themeMode = ref.themeMode;
ref.toggleTheme();
ref.setLightTheme();
ref.setDarkTheme();
```

## 🎨 Tema Özelleştirme

### Renk Paleti Değiştirme

`lib/core/theme/app_colors.dart` dosyasında renkleri özelleştirebilirsiniz:

```dart
class AppColors {
  // Light tema
  static const lightPrimary = Color(0xFF2196F3);
  static const lightSecondary = Color(0xFF00BCD4);
  
  // Dark tema
  static const darkPrimary = Color(0xFF64B5F6);
  static const darkSecondary = Color(0xFF4DD0E1);
}
```

### Text Stillerini Özelleştirme

`lib/core/theme/app_text_styles.dart` dosyasında font stillerini ayarlayabilirsiniz.

### Breakpoint'leri Değiştirme

`lib/core/responsive/responsive_provider.dart` dosyasında:

```dart
class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1440;
}
```

## 📱 Responsive Helper'lar

```dart
// Cihaz kontrolü
responsive.isMobile
responsive.isTablet
responsive.isDesktop

// Ekran boyutu
responsive.width
responsive.height

// Font scaling
responsive.textScaleFactor

// Dinamik padding
final padding = responsive.isMobile ? 16.0 : 24.0;

// Grid columns
responsive.gridColumns // Mobile: 1, Tablet: 2, Desktop: 3
```

## 🎯 Best Practices

1. **Her zaman ResponsiveLayout kullanın** - Otomatik responsive state güncellemesi
2. **Theme.of(context) kullanın** - Tema stillerine erişim için
3. **context.responsive extension'ını kullanın** - Basit erişim için
4. **ResponsiveConditional kullanın** - Cihaz-spesifik layoutlar için
5. **Kod içinde sabit boyut kullanmaktan kaçının** - Responsive değerleri kullanın

## 🔄 Tema Geçişleri

Tema geçişleri otomatik olarak animasyonludur (200ms). SharedPreferences ile kalıcı olarak saklanır.

## 📝 Örnek Sayfa

`lib/pages/settings/sync_settings_page.dart` dosyasında tam bir örnek implementasyon bulunmaktadır.

