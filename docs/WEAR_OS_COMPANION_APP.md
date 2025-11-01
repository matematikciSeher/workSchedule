# ⌚ Wear OS Companion App Entegrasyonu

## 📋 Genel Bakış

Work Schedule uygulaması, Wear OS 2.23 ve üstü sürümler için tam özellikli bir companion uygulama destekler. Bu companion uygulama, kullanıcıların takvim etkinliklerini ve görevlerini saat ekranında görüntülemelerine olanak tanır.

## 🏗️ Mimari Yapı

### 1. Veri Modeli Katmanı

**Konum:** `lib/features/wear_os/models/`

- **`WearOsEvent`**: Etkinlik verileri için hafifletilmiş model
- **`WearOsTask`**: Görev verileri için hafifletilmiş model  
- **`WearOsDailySummary`**: Günlük özet verileri

Bu modeller, Wear OS'un kısıtlı kaynaklarını göz önünde bulundurarak optimize edilmiştir ve yalnızca gerekli alanları içerir.

### 2. Servis Katmanı

**Konum:** `lib/features/wear_os/services/`

- **`WearOsDataService`**: Ana uygulama ile veri senkronizasyonunu yönetir
  - SharedPreferences kullanarak veri paylaşımı
  - JSON tabanlı veri aktarımı
  - Günlük özet oluşturma
  - Acil görev ve yaklaşan etkinlik filtreleme

### 3. UI Katmanı

**Konum:** `lib/features/wear_os/pages/` ve `lib/features/wear_os/widgets/`

- **`WearOsHomePage`**: Ana sayfa (günlük özet, etkinlikler, görevler)
- **`WearOsDailySummaryCard`**: Günlük özet gösterimi
- **`WearOsEventCard`**: Etkinlik kartı
- **`WearOsTaskCard`**: Görev kartı

## 🔄 Veri Senkronizasyonu

### SharedPreferences Tabanlı Paylaşım

Ana uygulama ve Wear OS companion uygulaması arasındaki veri paylaşımı SharedPreferences üzerinden gerçekleşir:

```dart
// Ana uygulamadan veri gönderimi
final wearOsService = WearOsDataService();
await wearOsService.syncEvents(events);
await wearOsService.syncTasks(tasks);

// Wear OS'tan veri okuma
final events = await wearOsService.getEvents();
final tasks = await wearOsService.getTasks();
```

### Veri Formatı

Veriler JSON formatında saklanır:
- `wear_os_events`: Etkinlikler listesi
- `wear_os_tasks`: Görevler listesi
- `wear_os_last_sync`: Son senkronizasyon zamanı
- `wear_os_daily_summary_[date]`: Günlük özetler

## 📱 Ana Özellikler

### 1. Günlük Özet
- Bugünkü görevler ve tamamlama durumu
- Bugünkü etkinlik sayısı
- Tamamlama yüzdesi ve progress bar

### 2. Yaklaşan Etkinlikler
- Sonraki 24 saat içindeki etkinlikler
- Tarih, saat ve konum bilgisi
- Acil etkinlik uyarıları

### 3. Acil Görevler
- Süresi dolmuş görevler (kırmızı)
- Bugün due date'i olan görevler
- Öncelik seviyesi göstergesi

### 4. Görev Yönetimi
- Görev tamamlama/iptal etme
- Öncelik seviyesi (Düşük, Orta, Yüksek)
- Tarih bazlı filtreleme

## 🎨 UI/UX Özellikleri

### Renk Paleti
- **Siyah arka plan**: OLED ekranlar için optimize
- **Mavi**: Etkinlikler ve genel bilgiler
- **Kırmızı**: Acil durumlar ve süresi dolmuş öğeler
- **Yeşil**: Tamamlanan görevler
- **Turuncu**: Öncelikli görevler

### Kompakt Tasarım
- Watch ekran boyutuna uygun küçük bileşenler
- Scroll edilebilir listeler
- Pull-to-refresh desteği
- Minimal navigasyon

### İkonlar
- Material Design ikonları
- 16-20px boyutlarında
- Renkli vurgu

## 🔧 Kurulum ve Yapılandırma

### 1. pubspec.yaml Bağımlılıkları

```yaml
dependencies:
  # Mevcut bağımlılıklar...
  shared_preferences: ^2.2.2
  intl: ^0.19.0
```

### 2. Android Manifest Entegrasyonu

**`android/app/src/main/AndroidManifest.xml`** dosyasına Wear OS desteği ekleyin:

```xml
<manifest>
  <uses-feature android:name="android.hardware.type.watch" />
  
  <application>
    <!-- Mevcut yapılandırma -->
  </application>
</manifest>
```

### 3. Gradle Yapılandırması

**`android/app/build.gradle.kts`** dosyasında Wear OS desteği:

```kotlin
android {
  defaultConfig {
    minSdk = 26  // Wear OS 2.23+ için minimum SDK
    targetSdk = 34
  }
}
```

## 🚀 Kullanım Örnekleri

### Ana Uygulamadan Veri Gönderimi

```dart
import 'package:work_schedule/features/wear_os/services/wear_os_data_service.dart';
import 'package:work_schedule/domain/entities/event_entity.dart';
import 'package:work_schedule/domain/entities/task_entity.dart';

// Event BLoC veya Repository içinde
final wearOsService = WearOsDataService();

// Etkinlikleri senkronize et
final events = await eventRepository.getAllEvents();
await wearOsService.syncEvents(events);

// Görevleri senkronize et
final tasks = await taskRepository.getAllTasks();
await wearOsService.syncTasks(tasks);
```

### Wear OS Companion'da Veri Okuma

```dart
import 'package:work_schedule/features/wear_os/pages/wear_os_home_page.dart';

// Ana uygulama başlatıldığında
MaterialApp(
  home: WearOsHomePage(),
  // ...
)
```

### Günlük Özet Gösterimi

```dart
final wearOsService = WearOsDataService();
final today = DateTime.now();
final summary = await wearOsService.getDailySummary(today);

print('Bugünkü etkinlikler: ${summary.events.length}');
print('Tamamlanan görevler: ${summary.completedTasksCount}/${summary.totalTasksCount}');
```

### Acil Görevleri Listele

```dart
final wearOsService = WearOsDataService();
final urgentTasks = await wearOsService.getUrgentTasks();

for (final task in urgentTasks) {
  print('Acil: ${task.title} - ${task.urgencyLevel}');
}
```

### Yaklaşan Etkinlikleri Göster

```dart
final wearOsService = WearOsDataService();
final upcomingEvents = await wearOsService.getUpcomingEvents();

for (final event in upcomingEvents) {
  print('Yaklaşan: ${event.title} - ${event.startDate}');
}
```

## 🧪 Test Stratejisi

### Unit Testler

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:work_schedule/features/wear_os/services/wear_os_data_service.dart';
import 'package:work_schedule/features/wear_os/models/wear_os_models.dart';

void main() {
  group('WearOsDataService', () {
    late WearOsDataService service;
    
    setUp(() {
      service = WearOsDataService();
    });
    
    test('Event senkronizasyonu çalışmalı', () async {
      final events = /* test verileri */;
      await service.syncEvents(events);
      
      final syncedEvents = await service.getEvents();
      expect(syncedEvents.length, equals(events.length));
    });
  });
}
```

### Widget Testleri

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:work_schedule/features/wear_os/widgets/wear_os_event_card.dart';

void main() {
  testWidgets('Event card doğru veriyi göstermeli', (tester) async {
    final event = WearOsEvent(/* test verisi */);
    
    await tester.pumpWidget(
      MaterialApp(
        home: WearOsEventCard(event: event),
      ),
    );
    
    expect(find.text(event.title), findsOneWidget);
  });
}
```

## 📊 Performans Optimizasyonları

### 1. Veri Optimizasyonu
- Yalnızca gerekli alanlar sync edilir
- JSON compression kullanılır
- Günlük özet cache'lenir

### 2. UI Optimizasyonu
- Lazy loading ile sayfa bazlı yükleme
- Image/assets kullanılmaz
- Minimal widget rebuild'leri

### 3. Bellek Yönetimi
- SharedPreferences'in boyut limitleri göz önünde bulundurulur
- Eski veriler otomatik temizlenir
- Disposed olduğunda state temizlenir

## 🔄 Gelecek Geliştirmeler

### Planlanan Özellikler
- [ ] Wear OS native messaging API entegrasyonu
- [ ] Sesli komut desteği
- [ ] Watch face complication desteği
- [ ] Offline mod iyileştirmeleri
- [ ] Daha fazla filtreleme seçeneği
- [ ] Bildirim entegrasyonu

### Platform Genişletme
- [ ] Apple Watch desteği (WatchOS)
- [ ] Tizen (Samsung Galaxy Watch) desteği
- [ ] Garmin Connect entegrasyonu

## 🐛 Bilinen Sorunlar

1. **SharedPreferences Limit**: Çok büyük veri setleri sorun yaratabilir
2. **Senkronizasyon Timing**: Gerçek zamanlı senkronizasyon yoktur
3. **Background Sync**: Wear OS background limitleri nedeniyle kısıtlı

## 📚 Kaynaklar

- [Wear OS Developer Guides](https://developer.android.com/training/wearables)
- [Flutter Wear OS Plugin](https://pub.dev/packages/flutter_wear_os_connectivity)
- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)

## 🤝 Katkıda Bulunma

Wear OS companion uygulamasına katkıda bulunmak için:
1. Feature request açın veya bug report yapın
2. Pull request gönderin
3. Testleri güncelleyin
4. Dokümantasyonu güncelleyin

---

**Not**: Bu companion app, Wear OS 2.23 ve üstü sürümleri destekler. Minimum SDK sürümü 26'dır (Android 8.0 Oreo).

