# Etkinlik Hatırlatıcı Sistemi

Bu dokümantasyon, etkinlik hatırlatıcı sisteminin nasıl kullanılacağını açıklar.

## Genel Bakış

Etkinlik hatırlatıcı sistemi, `flutter_local_notifications` paketini kullanarak yerel bildirimler gönderir. Kullanıcılar bir etkinlik eklediklerinde, etkinlik başlamadan belirli bir süre önce bildirim alabilirler. Sistem tekrar eden hatırlatmaları da destekler.

## Özellikler

- ✅ Tek seferlik hatırlatmalar (etkinlikten X dakika önce)
- ✅ Tekrar eden hatırlatmalar (günlük, haftalık, aylık)
- ✅ Etkinlik oluşturulduğunda otomatik bildirim zamanlama
- ✅ Etkinlik güncellendiğinde bildirimleri güncelleme
- ✅ Etkinlik silindiğinde bildirimleri iptal etme

## Kullanım

### EventEntity ile Hatırlatma Ayarlama

```dart
final event = EventEntity(
  id: 'unique-id',
  title: 'Toplantı',
  description: 'Proje görüşmesi',
  startDate: DateTime(2024, 12, 25, 14, 0), // 25 Aralık 2024, 14:00
  endDate: DateTime(2024, 12, 25, 15, 0),
  reminderBeforeMinutes: 15, // 15 dakika önce hatırlat
  isRecurring: false, // Tek seferlik
  recurringPattern: null,
  // ... diğer alanlar
);

// Etkinlik oluşturulduğunda otomatik olarak bildirim zamanlanır
await eventRepository.createEvent(event);
```

### Tekrar Eden Hatırlatma

```dart
final recurringEvent = EventEntity(
  id: 'unique-id-2',
  title: 'Haftalık Toplantı',
  startDate: DateTime(2024, 12, 25, 14, 0),
  endDate: DateTime(2024, 12, 25, 15, 0),
  reminderBeforeMinutes: 30, // 30 dakika önce hatırlat
  isRecurring: true,
  recurringPattern: 'weekly', // 'daily', 'weekly', 'monthly'
  // ... diğer alanlar
);

await eventRepository.createEvent(recurringEvent);
```

### Bildirimleri İptal Etme

```dart
// Etkinlik silindiğinde bildirimler otomatik olarak iptal edilir
await eventRepository.deleteEvent(eventId);

// Veya manuel olarak
final notificationHelper = EventNotificationHelper();
await notificationHelper.cancelEventNotifications(event);
```

## Yapılandırma

### EventEntity Alanları

- `reminderBeforeMinutes` (int?): Etkinlikten kaç dakika önce hatırlatılacak. Null veya 0 ise hatırlatma yapılmaz.
- `isRecurring` (bool): Tekrar eden hatırlatma mı? Varsayılan: false
- `recurringPattern` (String?): Tekrar deseni. Geçerli değerler: 'daily', 'weekly', 'monthly'. Null ise tek seferlik.

### Bildirim İçeriği

Bildirim başlığı: "Etkinlik Hatırlatıcısı"
Bildirim içeriği:
- Etkinlik başlığı
- Konum (varsa): " - [konum]"
- Açıklama (varsa): Yeni satırda gösterilir

## Teknik Detaylar

### Servisler

1. **NotificationService**: Temel bildirim işlemlerini yönetir
   - Bildirim zamanlama
   - Tekrar eden bildirimler
   - Bildirim iptal etme

2. **EventNotificationHelper**: Etkinlik bildirimlerini yönetir
   - EventEntity'den bildirim ayarlarını okur
   - Bildirim zamanını hesaplar
   - Tekrar eden bildirimleri yönetir

### Otomatik Entegrasyon

`EventRepositoryImpl` sınıfı otomatik olarak:
- `createEvent()` çağrıldığında bildirim zamanlar
- `updateEvent()` çağrıldığında bildirimleri günceller
- `deleteEvent()` çağrıldığında bildirimleri iptal eder

## Platform Özel Notlar

### Android

- Android 13+ (API 33+) için POST_NOTIFICATIONS izni gereklidir
- Bildirimler için Android notification channel kullanılır: 'event_reminders'
- Tam zamanlı bildirimler için SCHEDULE_EXACT_ALARM izni kullanılır

### iOS

- Bildirimler için kullanıcıdan izin istenir
- iOS ayarlarında bildirim izinleri kontrol edilir

## Limitler

- Tekrar eden bildirimler için maksimum 1 yıllık süre desteklenir
- Geçmiş tarihli bildirimler zamanlanmaz
- Bildirim ID'leri event ID'sinin hash koduna göre hesaplanır

## Örnek Senaryolar

### Senaryo 1: Basit Hatırlatma
```dart
EventEntity(
  startDate: DateTime.now().add(Duration(days: 1)),
  reminderBeforeMinutes: 60, // 1 saat önce hatırlat
)
```

### Senaryo 2: Günlük Tekrar Eden Hatırlatma
```dart
EventEntity(
  startDate: DateTime.now().add(Duration(hours: 2)),
  reminderBeforeMinutes: 15,
  isRecurring: true,
  recurringPattern: 'daily',
)
```

### Senaryo 3: Haftalık Toplantı Hatırlatıcısı
```dart
EventEntity(
  startDate: DateTime(2024, 12, 25, 14, 0), // Her Çarşamba
  reminderBeforeMinutes: 30,
  isRecurring: true,
  recurringPattern: 'weekly',
)
```

