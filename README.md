# Work Schedule 📅

Modern ve kullanıcı dostu iş programı uygulaması. Firebase ile bulut senkronizasyonu, hassas zamanlanmış bildirimler ve Google Calendar entegrasyonu.

## 🚀 Google Play Yayını

**Uygulama Google Play'e yüklenmeye hazır!**

👉 **BAŞLAMADAN ÖNCE**: [BAŞLANGIÇ.md](BAŞLANGIÇ.md) dosyasını okuyun!

Detaylı bilgi için:
- 🎯 **BAŞLANGIÇ.md** - Hızlı başlangıç kılavuzu (Buradan başla!)
- 📖 **RELEASE_CHECKLIST.md** - Hızlı kontrol listesi ve adımlar
- 📚 **GUIDE_GOOGLE_PLAY_YAYINI.md** - Kapsamlı yayın rehberi
- ✅ **README_YAYIN_HAZIRLIK.md** - Yapılan tüm yapılandırmalar

### ⚡ Hızlı Başlangıç

1. **Keystore Oluştur**: `RELEASE_CHECKLIST.md` dosyasındaki adımları izleyin
2. **Build Al**: `flutter build appbundle --release`
3. **Google Play Console'a Yükle**: Play Console üzerinden yayınlayın

---

## 📱 Özellikler

- ✅ Firebase Authentication (Google Sign-In)
- ✅ Cloud Firestore (Bulut senkronizasyon)
- ✅ Takvim görünümü (Aylık/Haftalık/Günlük)
- ✅ Hassas zamanlanmış bildirimler
- ✅ Google Calendar entegrasyonu
- ✅ Modern ve responsive UI/UX
- ✅ Dark mode desteği
- ✅ Offline senkronizasyon
- ✅ PDF dışa aktarma
- ⌚ **Wear OS companion app** (Yeni!)

## 🛠️ Teknoloji Stack

**Framework**: Flutter 3.35.6  
**Backend**: Firebase (Auth, Firestore)  
**State Management**: BLoC Pattern  
**Local Database**: Isar, SQLite  
**Notifications**: flutter_local_notifications  
**Calendar**: table_calendar  

## 📦 Bağımlılıklar

Ana bağımlılıklar:
- `flutter_bloc` - State management
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Firebase servisleri
- `google_sign_in`, `googleapis` - Google entegrasyonu
- `table_calendar` - Takvim bileşeni
- `flutter_local_notifications` - Bildirimler
- `isar` - Local veritabanı
- `workmanager` - Arka plan görevleri

Tam liste için `pubspec.yaml` dosyasına bakın.

## 📂 Proje Yapısı

```
lib/
├── core/              # Çekirdek yapı (services, routes, theme)
├── data/              # Veri katmanı (datasources, models, repositories)
├── domain/            # İş mantığı (entities, usecases, repositories)
├── features/          # Özellikler (calendar, event, task, settings, wear_os)
│   └── wear_os/       # Wear OS companion app
├── pages/             # Sayfalar ve UI
└── shared/            # Paylaşılan bileşenler
```

Detaylı yapı için `KLASÖR_YAPISI_ÖZET.md` dosyasına bakın.

## ⌚ Wear OS Companion App

Work Schedule artık Wear OS 2.23+ için tam özellikli bir companion uygulama sunar:

### Özellikler
- 📊 **Günlük Özet**: Etkinlik ve görev sayıları, tamamlama yüzdesi
- 🚨 **Acil Görevler**: Süresi dolmuş ve öncelikli görevler
- 📅 **Yaklaşan Etkinlikler**: Sonraki 24 saat içindeki etkinlikler
- ✅ **Görev Yönetimi**: Tamamlama durumu, öncelik seviyeleri

### Dokümantasyon
- 📖 [Wear OS Companion App Dokümantasyonu](docs/WEAR_OS_COMPANION_APP.md) - Kapsamlı rehber
- 📝 [Wear OS README](lib/features/wear_os/README.md) - Hızlı başlangıç
- 💻 [Kullanım Örnekleri](lib/features/wear_os/examples/wear_os_integration_example.dart)

## 🏗️ Mimari

**Clean Architecture + BLoC Pattern**

- **Domain Layer**: İş mantığı, entities
- **Data Layer**: Veri kaynakları, models
- **Presentation Layer**: UI, BLoC'lar
- **Core**: Servisler, utilities

## 🧪 Test

```bash
# Unit testler
flutter test

# Integration testler
flutter drive --driver=test_driver/integration_test.dart --target=test/integration/app_test.dart
```

## 📝 Dokümantasyon

- **OPTIMIZATION_SUMMARY.md** - Performans optimizasyonları
- **BLOC_MİMARİ_YAPISI.md** - BLoC mimarisi detayları
- **THEME_ARCHITECTURE_SUMMARY.md** - Tema sistemi
- **GOOGLE_CALENDAR_SETUP.md** - Google Calendar kurulumu

## 🔒 Güvenlik

- Firebase Security Rules yapılandırıldı
- ProGuard/R8 kod karıştırma aktif
- Release signing yapılandırıldı
- Gizlilik politikası hazır

## 📄 Lisans

Proje özel kullanım içindir.

---

**Son Güncelleme**: 2025