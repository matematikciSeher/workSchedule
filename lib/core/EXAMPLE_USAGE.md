# Responsive ve Tema Mimarisi - Kullanım Örnekleri

## 🎯 Hızlı Başlangıç

### 1. Temel Sayfa Yapısı

Tüm sayfalarınızda aynı yapıyı kullanın:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/responsive/responsive_provider.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayfa Başlığı'),
        actions: const [
          ThemeToggleButton(), // Tema değiştirme butonu
        ],
      ),
      body: ResponsiveLayout(
        child: ListView(
          padding: EdgeInsets.all(responsive.horizontalPadding),
          children: [
            // İçerik buraya gelecek
          ],
        ),
      ),
    );
  }
}
```

### 2. StatefulWidget ile Kullanım

```dart
class MyStatefulPage extends ConsumerStatefulWidget {
  const MyStatefulPage({super.key});

  @override
  ConsumerState<MyStatefulPage> createState() => _MyStatefulPageState();
}

class _MyStatefulPageState extends ConsumerState<MyStatefulPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Scaffold(
      body: ResponsiveLayout(
        child: Container(
          padding: EdgeInsets.all(responsive.horizontalPadding),
          child: Column(
            children: [
              Text(
                'Başlık',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              // ... diğer widget'lar
            ],
          ),
        ),
      ),
    );
  }
}
```

### 3. Responsive Conditional Layout

Farklı cihazlarda farklı layoutlar gösterin:

```dart
body: ResponsiveConditional(
  mobile: MobileLayout(),      // Telefon için özel layout
  tablet: TabletLayout(),      // Tablet için özel layout
  desktop: DesktopLayout(),    // Desktop için özel layout
),
```

### 4. Grid Layout ile Kullanım

```dart
ResponsiveBuilder(
  builder: (context, responsive) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.gridColumns, // 1, 2 veya 3
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemCard(item: items[index]);
      },
    );
  },
)
```

### 5. Dinamik Padding ve Spacing

```dart
final responsive = context.responsive;

// Padding hesaplama
final padding = responsive.isMobile ? 16.0 : 
                responsive.isTablet ? 24.0 : 32.0;

Container(
  padding: EdgeInsets.all(padding),
  child: Text('Dinamik padding'),
)

// Grid spacing
GridView.count(
  crossAxisCount: 2,
  mainAxisSpacing: padding / 2,
  crossAxisSpacing: padding / 2,
  children: [...],
)
```

### 6. Tema Kontrolü

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).themeMode;
    final isDark = themeMode == ThemeModeType.dark;
    
    return Container(
      color: isDark ? Colors.grey[900] : Colors.white,
      child: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
      ),
    );
  }
}
```

### 7. Programatik Tema Değiştirme

```dart
// WidgetRef extension ile
ref.read(themeProvider.notifier).setLightTheme();
ref.read(themeProvider.notifier).setDarkTheme();
ref.read(themeProvider.notifier).setSystemTheme();
ref.read(themeProvider.notifier).toggleTheme();

// Context extension ile (ProviderScope içinde)
final container = ProviderScope.containerOf(context);
container.read(themeProvider.notifier).toggleTheme();
```

### 8. Modal Bottom Sheet ile Tema Seçimi

```dart
void showThemeSelector(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => const ThemeSelector(),
  );
}
```

### 9. Complex Layout Örneği

```dart
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    
    return Scaffold(
      body: ResponsiveLayout(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Dashboard'),
              actions: const [ThemeToggleButton()],
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: EdgeInsets.all(responsive.horizontalPadding),
              sliver: ResponsiveBuilder(
                builder: (context, responsive) {
                  if (responsive.isMobile) {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        StatCard(),
                        StatCard(),
                        StatCard(),
                      ]),
                    );
                  } else {
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: responsive.gridColumns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildListDelegate([
                        StatCard(),
                        StatCard(),
                        StatCard(),
                      ]),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 10. Custom Widget ile Tema Uyumu

```dart
class ThemedCard extends StatelessWidget {
  final Widget child;
  
  const ThemedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
        ),
        child: child,
      ),
    );
  }
}

// Kullanım
ThemedCard(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Tema uyumlu kart'),
  ),
)
```

### 11. Typography Kullanımı

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Display Large',
      style: Theme.of(context).textTheme.displayLarge,
    ),
    Text(
      'Headline Medium',
      style: Theme.of(context).textTheme.headlineMedium,
    ),
    Text(
      'Body Large',
      style: Theme.of(context).textTheme.bodyLarge,
    ),
    Text(
      'Label Small',
      style: Theme.of(context).textTheme.labelSmall,
    ),
  ],
)
```

### 12. Form Widget'ları ile Kullanım

```dart
Column(
  children: [
    TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        // InputDecoration otomatik olarak temaya uyum sağlar
      ),
    ),
    const SizedBox(height: 16),
    SwitchListTile(
      title: const Text('Bildirimleri Etkinleştir'),
      value: _notificationsEnabled,
      onChanged: (value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
    ),
    const SizedBox(height: 16),
    ElevatedButton(
      onPressed: () {},
      child: const Text('Kaydet'),
      // Button theme otomatik olarak uygulanır
    ),
  ],
)
```

## 🎨 Özelleştirme İpuçları

### Renk Özelleştirme

```dart
// lib/core/theme/app_colors.dart dosyasında
static const lightPrimary = Color(0xFF2196F3); // Mavi
static const lightAccent = Color(0xFFFF5722);   // Turuncu

// Kendi renklerinizi kullanın
static const lightPrimary = Color(0xFF6C5CE7); // Mor
static const lightAccent = Color(0xFF00B894);   // Yeşil
```

### Font Scaling Özelleştirme

```dart
// lib/core/responsive/responsive_provider.dart içinde
static double _calculateTextScale(double width) {
  if (width < Breakpoints.mobile) {
    return 0.85; // Daha küçük font
  } else if (width < Breakpoints.tablet) {
    return 1.0;
  } else {
    return 1.15; // Daha büyük font
  }
}
```

### Breakpoint Özelleştirme

```dart
// lib/core/responsive/responsive_provider.dart içinde
class Breakpoints {
  static const double mobile = 600;   // Artırıldı
  static const double tablet = 900;   // Artırıldı
  static const double desktop = 1200; // Artırıldı
  static const double wide = 1800;    // Artırıldı
}
```

## 📚 Daha Fazla Bilgi

- Tüm özellikler için `lib/core/README.md` dosyasına bakın
- Mevcut implementasyon için `lib/pages/settings/sync_settings_page.dart` dosyasını inceleyin

