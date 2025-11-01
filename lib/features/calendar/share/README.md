# 📅 Takvim Paylaşım ve Zaman Dilimi Senkronizasyonu

Bu modül, etkinlik ve takvim paylaşımı, .ics formatında dışa/içe aktarma ve zaman dilimi senkronizasyonu özelliklerini sağlar.

## 🎯 Özellikler

### 1. .ics (iCalendar) Export/Import
- Tek etkinlik veya tüm takvim .ics formatında dışa aktarılabilir
- .ics dosyaları içe aktarılabilir ve otomatik parse edilir
- RFC 5545 standardına uygun

### 2. Zaman Dilimi Senkronizasyonu
- Alıcının zaman dilimine göre otomatik saat ayarlama
- UTC standardı kullanımı
- Zaman dilimi farkı uyarıları

### 3. Paylaşım Seçenekleri
- E-posta
- Mesaj
- Sosyal medya
- Dosya paylaşımı
- Deep link desteği

### 4. BLoC Pattern Entegrasyonu
- Tüm paylaşım işlemleri BLoC pattern ile yönetilir
- Event-driven mimari
- Reactive state management

## 📦 Servisler

### ICalendarService
`.ics` dosyalarını oluşturur ve parse eder.

```dart
final icalService = ICalendarService();

// Tek etkinlik export
final icalContent = icalService.exportEventToICal(event);

// Tüm takvim export
final icalContent = icalService.exportEventsToICal(events, calendarName: 'My Calendar');

// Import
final importedEvents = await icalService.importEventsFromICal(icalContent);
```

### TimezoneService
Zaman dilimi dönüşümlerini yönetir.

```dart
final timezoneService = TimezoneService();
await timezoneService.initialize();

// Yerel zaman dilimi
final localTz = await timezoneService.getLocalTimezone();

// UTC offset
final offsetHours = await timezoneService.getUTCOffsetHours();

// Zaman dilimi dönüşümü
final adjustedTime = await timezoneService.convertUTCToTimezone(
  utcDateTime,
  'Europe/Berlin',
);

// Uyarı mesajı
final warning = await timezoneService.getTimezoneChangeWarningMessage(
  originalTime,
  'Europe/Istanbul',
  'Europe/Berlin',
);
```

### ShareService
Paylaşım işlemlerini yönetir (share_plus paketi ile).

```dart
final shareService = ShareService();

// .ics içeriğini paylaş
await shareService.shareICalContent(
  icalContent,
  subject: 'Takvim Paylaşımı',
  fileName: 'calendar.ics',
);

// Deep link paylaş
await shareService.shareDeepLink(
  deepLink,
  subject: 'Takvim Bağlantısı',
);
```

### DeepLinkService
Deep link'leri parse eder ve oluşturur.

```dart
final deepLinkService = DeepLinkService();

// Parse
final result = deepLinkService.parseDeepLink('workschedule://share/event?eventId=123');

// Oluştur
final link = deepLinkService.createEventDeepLink(
  eventId: '123',
  timezone: 'Europe/Istanbul',
);
```

## 🎨 Widget'lar

### ShareEventDialog
Tek bir etkinliği paylaşmak için dialog.

```dart
showDialog(
  context: context,
  builder: (context) => ShareEventDialog(
    event: myEvent,
  ),
);
```

### ShareCalendarDialog
Tüm takvimi paylaşmak için dialog.

```dart
showDialog(
  context: context,
  builder: (context) => ShareCalendarDialog(
    events: allEvents,
    calendarName: 'My Calendar',
  ),
);
```

### ImportCalendarDialog
.ics dosyası içe aktarma dialog'u.

```dart
showDialog(
  context: context,
  builder: (context) => const ImportCalendarDialog(),
);
```

## 🔄 BLoC Kullanımı

### Event Gönderme

```dart
// Tek etkinlik paylaş
context.read<ShareCalendarBloc>().add(
  ShareSingleEventEvent(
    event: myEvent,
    targetTimezone: 'Europe/Berlin',
  ),
);

// Tüm takvim paylaş
context.read<ShareCalendarBloc>().add(
  ShareAllEventsEvent(
    events: allEvents,
    calendarName: 'My Calendar',
    targetTimezone: 'America/New_York',
  ),
);

// .ics dosyası içe aktar
context.read<ShareCalendarBloc>().add(
  ImportICalFileEvent(
    icalContent: icalContent,
    sourceTimezone: 'Europe/Istanbul',
  ),
);

// Zaman dilimi farkı kontrol et
context.read<ShareCalendarBloc>().add(
  CheckTimezoneDifferenceEvent(
    eventTime: event.startDate,
    sourceTimezone: 'Europe/Istanbul',
    targetTimezone: 'Europe/Berlin',
  ),
);
```

### State Dinleme

```dart
BlocListener<ShareCalendarBloc, ShareCalendarState>(
  listener: (context, state) {
    if (state is ShareCalendarSuccess) {
      // Başarılı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is ShareCalendarError) {
      // Hata
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is ImportCalendarSuccess) {
      // İçe aktarma başarılı
      // state.importedEvents kullanılabilir
    } else if (state is TimezoneDifferenceChecked) {
      // Zaman dilimi farkı hesaplandı
      // state.warningMessage gösterilebilir
    }
  },
  child: YourWidget(),
)
```

### State Builder

```dart
BlocBuilder<ShareCalendarBloc, ShareCalendarState>(
  builder: (context, state) {
    if (state is ShareCalendarLoading) {
      return const CircularProgressIndicator();
    }
    // Diğer state'ler...
    return YourWidget();
  },
)
```

## 🔗 Deep Link Kullanımı

### Deep Link Formatı

```
workschedule://share/event?eventId=123&timezone=Europe/Istanbul
workschedule://share/calendar?calendarName=My Calendar&timezone=Europe/Berlin
workschedule://import/calendar?ical=...&sourceTimezone=Europe/Istanbul
```

### Deep Link'i Handle Etme

Deep link'ler `RouteGenerator` tarafından otomatik olarak handle edilir. 

Android ve iOS için URL scheme yapılandırması gerekebilir:

**Android (AndroidManifest.xml):**
```xml
<activity>
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="workschedule" />
  </intent-filter>
</activity>
```

**iOS (Info.plist):**
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>workschedule</string>
    </array>
  </dict>
</array>
```

## ⚠️ Zaman Dilimi Uyarıları

Paylaşım sırasında zaman dilimi farkı tespit edilirse, kullanıcıya otomatik olarak uyarı gösterilir:

- Fark saat cinsinden gösterilir
- Orijinal ve yeni saat karşılaştırılır
- Etkinlik saatleri otomatik olarak ayarlanır

Örnek uyarı:
```
Zaman dilimi farkı: 2 saat ileri
Orijinal saat: 10:00 (Europe/Istanbul)
Yeni saat: 08:00 (Europe/Berlin)
```

## 📝 Notlar

- Tüm DateTime değerleri UTC olarak saklanmalıdır
- Zaman dilimi dönüşümleri otomatik yapılır
- .ics dosyaları RFC 5545 standardına uygundur
- Paylaşım işlemleri asenkron çalışır
- Deep link'ler için uygulama yüklü olmalıdır

## 🔧 Geliştirilecek Özellikler

- [ ] Cloud storage entegrasyonu (Firebase Storage, etc.)
- [ ] QR kod ile paylaşım
- [ ] E-posta şablonları
- [ ] Toplu içe aktarma
- [ ] Paylaşım geçmişi
- [ ] İzin yönetimi (private/public events)

