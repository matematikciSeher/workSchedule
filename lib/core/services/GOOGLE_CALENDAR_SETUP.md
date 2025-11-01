# Google Calendar API Entegrasyon Rehberi

Bu dokümantasyon, Flutter uygulamanıza Google Calendar API entegrasyonunu adım adım açıklar.

## 📋 İçindekiler

1. [Gereksinimler](#gereksinimler)
2. [Google Cloud Console Yapılandırması](#google-cloud-console-yapılandırması)
3. [Android Yapılandırması](#android-yapılandırması)
4. [iOS Yapılandırması](#ios-yapılandırması)
5. [Paket Kurulumu](#paket-kurulumu)
6. [Kullanım Örnekleri](#kullanım-örnekleri)
7. [Sorun Giderme](#sorun-giderme)

---

## 📦 Gereksinimler

### Gerekli Paketler

Aşağıdaki paketler `pubspec.yaml` dosyasına eklenmiştir:

```yaml
dependencies:
  google_sign_in: ^6.1.6
  googleapis: ^11.3.0
  http: ^1.1.0
```

### Platform Gereksinimleri

- **Android**: Min SDK 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Flutter**: SDK 3.3.0+

---

## 🔧 Google Cloud Console Yapılandırması

### Adım 1: Google Cloud Console'da Proje Oluşturma

1. [Google Cloud Console](https://console.cloud.google.com/) adresine gidin
2. Yeni bir proje oluşturun veya mevcut projeyi seçin
3. Proje adını not edin

### Adım 2: Google Calendar API'yi Etkinleştirme

1. Sol menüden **"APIs & Services"** > **"Library"** seçin
2. Arama çubuğuna **"Google Calendar API"** yazın
3. **"Google Calendar API"** seçeneğine tıklayın
4. **"Enable"** butonuna tıklayın

### Adım 3: OAuth 2.0 Kimlik Bilgileri Oluşturma

#### Android için:

1. **"APIs & Services"** > **"Credentials"** menüsüne gidin
2. **"Create Credentials"** > **"OAuth client ID"** seçin
3. Eğer OAuth consent screen yapılandırılmamışsa, önce onu yapılandırın:
   - **"OAuth consent screen"** sekmesine gidin
   - Uygulama adı, destek e-postası gibi bilgileri doldurun
   - Scope ekleyin: `https://www.googleapis.com/auth/calendar`
   - Test kullanıcıları ekleyin (geliştirme aşamasında)

4. **"OAuth client ID"** oluştururken:
   - Application type: **Android**
   - Name: Uygulamanızın adı
   - Package name: `com.workschedule.app` (AndroidManifest.xml'deki package adı)
   - **SHA-1 certificate fingerprint** eklemeniz gerekiyor

#### SHA-1 Fingerprint Nasıl Alınır?

**Debug Key için:**
```bash
# Windows (Git Bash)
cd android
./gradlew signingReport

# Veya Java keytool kullanarak
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Release Key için:**
```bash
keytool -list -v -keystore <your-keystore-path> -alias <your-key-alias>
```

5. SHA-1 fingerprint'i kopyalayıp OAuth client ID oluşturma ekranına yapıştırın
6. **"Create"** butonuna tıklayın
7. Client ID'yi not edin (android/app/build.gradle.kts içinde kullanılacak)

#### iOS için:

1. **"APIs & Services"** > **"Credentials"** menüsüne gidin
2. **"Create Credentials"** > **"OAuth client ID"** seçin
3. Application type: **iOS**
4. Bundle ID: iOS projenizdeki Bundle Identifier (Info.plist'teki CFBundleIdentifier)
5. **"Create"** butonuna tıklayın
6. Client ID'yi not edin

#### Web için (Opsiyonel - Web platformu için):

1. Application type: **Web application**
2. Authorized redirect URIs ekleyin (gerekirse)

---

## 🤖 Android Yapılandırması

### Adım 1: google-services.json Kontrolü

`android/app/google-services.json` dosyasının mevcut olduğundan emin olun. Bu dosya Firebase projenizden indirilmiş olmalı.

### Adım 2: build.gradle.kts Yapılandırması

`android/app/build.gradle.kts` dosyası zaten Google Services plugin'i içeriyor. Aşağıdaki yapılandırma mevcut:

```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

### Adım 3: SHA-1 Fingerprint Ekleme

Google Cloud Console'da oluşturduğunuz OAuth client ID'ye SHA-1 fingerprint'inizi eklediğinizden emin olun.

### Adım 4: AndroidManifest.xml Kontrolü

`android/app/src/main/AndroidManifest.xml` dosyasında internet izni olduğundan emin olun:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Not: Genellikle bu izin otomatik olarak eklenir, ancak kontrol edin.

### Adım 5: Pro Guard (Release Build için)

Release build yapıyorsanız, `android/app/proguard-rules.pro` dosyasına ekleyin:

```
-keep class com.google.** { *; }
-keep class com.googleapis.** { *; }
-dontwarn com.google.**
```

---

## 🍎 iOS Yapılandırması

### Adım 1: GoogleService-Info.plist Kontrolü

`ios/Runner/GoogleService-Info.plist` dosyasının mevcut olduğundan emin olun.

### Adım 2: Info.plist Yapılandırması

`ios/Runner/Info.plist` dosyasına URL scheme ekleyin. Google Sign-In için gerekli:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

**Önemli:** `YOUR_REVERSED_CLIENT_ID`, `GoogleService-Info.plist` dosyasındaki `REVERSED_CLIENT_ID` değeridir.

### Adım 3: Podfile Yapılandırması

`ios/Podfile` dosyasını kontrol edin. Google Sign-In için özel bir yapılandırma gerekmez, Flutter paketleri otomatik olarak pod'ları yönetir.

### Adım 4: CocoaPods Kurulumu

Terminal'de iOS klasörüne gidin ve pod'ları yükleyin:

```bash
cd ios
pod install
cd ..
```

---

## 📦 Paket Kurulumu

Tüm paketler `pubspec.yaml` dosyasına eklenmiştir. Paketleri kurmak için:

```bash
flutter pub get
```

---

## 💻 Kullanım Örnekleri

### Örnek 1: Google Hesabı ile Giriş Yapma

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/calendar/bloc/calendar_sync_bloc.dart';
import 'features/calendar/bloc/events/calendar_sync_event.dart';
import 'features/calendar/bloc/states/calendar_sync_state.dart';

class CalendarSyncPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarSyncBloc()..add(CheckAuthStatusEvent()),
      child: BlocBuilder<CalendarSyncBloc, CalendarSyncState>(
        builder: (context, state) {
          if (state is CalendarSyncNotAuthenticated) {
            return ElevatedButton(
              onPressed: () {
                context.read<CalendarSyncBloc>().add(SignInWithGoogleEvent());
              },
              child: Text('Google ile Giriş Yap'),
            );
          } else if (state is CalendarSyncAuthenticated) {
            return Text('Hoş geldiniz, ${state.user.email}');
          } else if (state is CalendarSyncLoading) {
            return CircularProgressIndicator();
          }
          return SizedBox();
        },
      ),
    );
  }
}
```

### Örnek 2: Takvim Etkinliklerini Çekme

```dart
// Belirli bir tarih aralığındaki etkinlikleri çek
final startDate = DateTime.now();
final endDate = startDate.add(Duration(days: 30));

context.read<CalendarSyncBloc>().add(
  FetchGoogleCalendarEventsEvent(
    startDate: startDate,
    endDate: endDate,
  ),
);

// State'i dinle
BlocListener<CalendarSyncBloc, CalendarSyncState>(
  listener: (context, state) {
    if (state is CalendarEventsLoadedState) {
      print('Etkinlik sayısı: ${state.events.length}');
      state.events.forEach((event) {
        print('Etkinlik: ${event.summary}');
        print('Başlangıç: ${event.start?.dateTime}');
      });
    }
  },
  child: YourWidget(),
);
```

### Örnek 3: Yeni Etkinlik Oluşturma

```dart
context.read<CalendarSyncBloc>().add(
  CreateGoogleCalendarEvent(
    summary: 'Toplantı',
    start: DateTime.now().add(Duration(hours: 1)),
    end: DateTime.now().add(Duration(hours: 2)),
    description: 'Proje toplantısı',
    location: 'Ofis',
  ),
);

// Başarılı oluşturmayı dinle
BlocListener<CalendarSyncBloc, CalendarSyncState>(
  listener: (context, state) {
    if (state is CalendarEventCreatedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Etkinlik oluşturuldu!')),
      );
    }
  },
  child: YourWidget(),
);
```

### Örnek 4: Tüm Takvimlerden Etkinlikleri Çekme

```dart
// Önce takvimleri listele
context.read<CalendarSyncBloc>().add(LoadCalendarsEvent());

// Tüm takvimlerden etkinlikleri çek
context.read<CalendarSyncBloc>().add(
  FetchAllCalendarsEventsEvent(
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 7)),
  ),
);

// State'i dinle
BlocBuilder<CalendarSyncBloc, CalendarSyncState>(
  builder: (context, state) {
    if (state is AllCalendarsEventsLoadedState) {
      return ListView.builder(
        itemCount: state.eventsMap.length,
        itemBuilder: (context, index) {
          final calendarId = state.eventsMap.keys.elementAt(index);
          final events = state.eventsMap[calendarId]!;
          return ListTile(
            title: Text('Takvim: $calendarId'),
            subtitle: Text('${events.length} etkinlik'),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
);
```

### Örnek 5: Senkronizasyon Yapma

```dart
// Google Calendar'dan yerel veritabanına senkronize et
context.read<CalendarSyncBloc>().add(
  SyncWithGoogleCalendarEvent(
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
    syncDirection: true, // true: Google -> Local
  ),
);

// Senkronizasyon tamamlandığında
BlocListener<CalendarSyncBloc, CalendarSyncState>(
  listener: (context, state) {
    if (state is CalendarSyncCompletedState) {
      print('${state.syncedEventsCount} etkinlik senkronize edildi');
    }
  },
  child: YourWidget(),
);
```

---

## 🔍 Sorun Giderme

### Hata: "Sign in cancelled"

**Sebep:** Kullanıcı giriş ekranını kapattı.

**Çözüm:** Bu normal bir durumdur. Kullanıcı tekrar giriş yapmayı deneyebilir.

### Hata: "PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: ..."

**Sebep:** SHA-1 fingerprint Google Cloud Console'a eklenmemiş veya yanlış.

**Çözüm:**
1. SHA-1 fingerprint'i tekrar alın
2. Google Cloud Console > Credentials > OAuth client ID bölümüne gidin
3. Android client ID'yi düzenleyin ve SHA-1 fingerprint'i ekleyin/güncelleyin
4. Uygulamayı yeniden başlatın

### Hata: "API not enabled"

**Sebep:** Google Calendar API etkinleştirilmemiş.

**Çözüm:**
1. Google Cloud Console > APIs & Services > Library
2. "Google Calendar API" arayın
3. "Enable" butonuna tıklayın

### Hata: "Invalid client"

**Sebep:** OAuth client ID yapılandırması yanlış.

**Çözüm:**
1. Google Cloud Console > Credentials
2. OAuth client ID'yi kontrol edin
3. Package name ve Bundle ID'lerin doğru olduğundan emin olun

### Hata: iOS'ta URL scheme hatası

**Sebep:** Info.plist'te URL scheme yapılandırılmamış.

**Çözüm:**
1. `ios/Runner/Info.plist` dosyasını açın
2. `GoogleService-Info.plist` dosyasındaki `REVERSED_CLIENT_ID` değerini bulun
3. Info.plist'e URL scheme ekleyin (yukarıdaki iOS yapılandırmasına bakın)

### Android'de "Network Security Config" Hatası

**Sebep:** Android 9+ için network security config gerekiyor olabilir.

**Çözüm:**
`android/app/src/main/res/xml/network_security_config.xml` dosyası oluşturun:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
            <certificates src="user" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

AndroidManifest.xml'e ekleyin:
```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

---

## 📝 Önemli Notlar

1. **API Kotaları:** Google Calendar API'nin günlük istek limitleri vardır. Production'da rate limiting uygulayın.

2. **Token Yenileme:** `google_sign_in` paketi otomatik olarak token yenileme işlemini yönetir.

3. **Güvenlik:** Access token'ları güvenli bir şekilde saklayın. Production'da secure storage kullanın.

4. **Test:** Geliştirme aşamasında test kullanıcıları ekleyin. Production'a geçmeden önce OAuth consent screen'i tamamlayın.

5. **Permissions:** Kullanıcılardan gerekli izinleri isteyin ve kullanım nedenlerini açıklayın.

---

## 🚀 Sonraki Adımlar

1. Google Cloud Console'da proje oluşturun
2. API'yi etkinleştirin
3. OAuth credentials oluşturun
4. SHA-1 fingerprint ekleyin (Android)
5. URL scheme ekleyin (iOS)
6. `flutter pub get` çalıştırın
7. Uygulamayı test edin

Başarılar! 🎉

