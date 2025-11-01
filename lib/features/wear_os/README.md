# ⌚ Wear OS Companion App

## 📋 Genel Bakış

Bu klasör, Work Schedule uygulamasının Wear OS companion uygulamasını içerir. Wear OS 2.23 ve üstü sürümler için tasarlanmıştır.

## 📁 Klasör Yapısı

```
lib/features/wear_os/
├── models/                  # Veri modelleri
│   └── wear_os_models.dart  # WearOsEvent, WearOsTask, WearOsDailySummary
├── services/                # Servis katmanı
│   └── wear_os_data_service.dart  # Veri senkronizasyon servisi
├── pages/                   # Sayfalar
│   └── wear_os_home_page.dart     # Ana sayfa
├── widgets/                 # UI bileşenleri
│   ├── wear_os_daily_summary_card.dart  # Günlük özet kartı
│   ├── wear_os_event_card.dart          # Etkinlik kartı
│   └── wear_os_task_card.dart           # Görev kartı
├── examples/                # Kullanım örnekleri
│   └── wear_os_integration_example.dart
└── README.md               # Bu dosya
```

## 🚀 Hızlı Başlangıç

### 1. Veri Modelleri

Wear OS için optimize edilmiş hafif veri modelleri:

```dart
import 'package:work_schedule/features/wear_os/models/wear_os_models.dart';

// Event modeli
final event = WearOsEvent(
  id: '123',
  title: 'Toplantı',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(hours: 1)),
);

// Task modeli
final task = WearOsTask(
  id: '456',
  title: 'Raporu tamamla',
  dueDate: DateTime.now(),
  isCompleted: false,
);
```

### 2. Veri Senkronizasyonu

Ana uygulamadan Wear OS'a veri gönderimi:

```dart
import 'package:work_schedule/features/wear_os/services/wear_os_data_service.dart';

final wearOsService = WearOsDataService();

// Eventleri senkronize et
await wearOsService.syncEvents(events);

// Taskleri senkronize et
await wearOsService.syncTasks(tasks);
```

### 3. UI Kullanımı

Wear OS home page'i gösterimi:

```dart
import 'package:work_schedule/features/wear_os/pages/wear_os_home_page.dart';

MaterialApp(
  home: WearOsHomePage(),
  theme: ThemeData.dark(),
)
```

## 🔄 Veri Akışı

```
Ana Uygulama (Mobile)
    ↓
Event/Task Repository
    ↓
WearOsDataService.syncEvents/syncTasks()
    ↓
SharedPreferences (JSON)
    ↓
WearOsDataService.getEvents/getTasks()
    ↓
Wear OS UI (WearOsHomePage)
```

## 📊 Özellikler

### Günlük Özet
- Bugünkü etkinlik ve görev sayıları
- Tamamlama yüzdesi
- Progress bar göstergesi

### Acil Görevler
- Süresi dolmuş görevler (kırmızı)
- Bugün due date'i olan görevler
- Öncelik seviyesi gösterimi

### Yaklaşan Etkinlikler
- Sonraki 24 saat içindeki etkinlikler
- Tarih ve saat bilgisi
- Konum bilgisi (varsa)

### Görev Yönetimi
- Görev tamamlama/iptal
- Öncelik seviyesi (1: Düşük, 2: Orta, 3: Yüksek)
- Aciliyet durumu (urgent, soon, normal, overdue)

## 🎨 UI Bileşenleri

### WearOsDailySummaryCard
Günlük özet bilgilerini gösterir:
- Tarih
- Etkinlik sayısı
- Tamamlanan/toplam görev sayısı
- Progress bar

### WearOsEventCard
Etkinlik bilgilerini gösterir:
- Başlık
- Tarih ve saat
- Konum (varsa)
- Acil durum vurgusu

### WearOsTaskCard
Görev bilgilerini gösterir:
- Başlık
- Due date
- Öncelik seviyesi
- Tamamlama durumu

## 🧪 Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:work_schedule/features/wear_os/services/wear_os_data_service.dart';

void main() {
  test('Event senkronizasyonu', () async {
    final service = WearOsDataService();
    await service.syncEvents(/* test events */);
    final events = await service.getEvents();
    expect(events.length, greaterThan(0));
  });
}
```

## 📚 Daha Fazla Bilgi

Detaylı dokümantasyon için: [WEAR_OS_COMPANION_APP.md](../../docs/WEAR_OS_COMPANION_APP.md)

Kullanım örnekleri için: [wear_os_integration_example.dart](./examples/wear_os_integration_example.dart)

## ⚠️ Notlar

- Minimum SDK: 26 (Android 8.0 Oreo) - Wear OS 2.23+ için
- SharedPreferences limitleri göz önünde bulundurulmalı
- Gerçek zamanlı senkronizasyon için Firestore veya WebSocket kullanılabilir
- OLED ekranlar için koyu tema optimize edilmiştir

