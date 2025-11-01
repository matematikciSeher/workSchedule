# 🎯 Google Play Yayını İçin Başlangıç Kılavuzu

## Merhaba! 👋

Work Schedule uygulamanız Google Play'e yüklenmeye hazır! Bu kılavuz, size en hızlı şekilde nereden başlayacağınızı gösterecek.

---

## 📂 Dokümantasyon Dosyaları

Projenizde 3 ana rehber dosyası var:

### 1️⃣ RELEASE_CHECKLIST.md ⚡ (Başlayın Burdan!)
**Süre**: 5 dakika  
**Ne İçeriyor**: En önemli 3 adım ve build komutları  
**Başlamak için**: Bu dosyayı açın ve adım adım ilerleyin

**En Önemli Kısımlar**:
- Keystore oluşturma (5 dakika)
- key.properties dosyası (2 dakika) 
- Release build alma (10 dakika)

👉 **[RELEASE_CHECKLIST.md dosyasını aç](RELEASE_CHECKLIST.md)**

---

### 2️⃣ GUIDE_GOOGLE_PLAY_YAYINI.md 📚 (Detaylı Rehber)
**Süre**: 30 dakika  
**Ne İçeriyor**: Tüm detaylar, açıklamalar ve örnekler  
**Ne Zaman**: Sorunuz olduğunda veya detaylı bilgi istediğinizde

**İçindekiler**:
- Adım adım tüm yapılandırmalar
- Google Play Console kurulumu
- İzin açıklamaları
- İçerik derecelendirmesi
- Sürüm notları örnekleri
- Gizlilik politikası bilgileri

👉 **[GUIDE_GOOGLE_PLAY_YAYINI.md dosyasını aç](GUIDE_GOOGLE_PLAY_YAYINI.md)**

---

### 3️⃣ README_YAYIN_HAZIRLIK.md ✅ (Tamamlanan İşler)
**Süre**: 10 dakika  
**Ne İçeriyor**: Yapılan tüm yapılandırmalar ve kontrol listeleri  
**Ne Zaman**: Yapılan işleri görmek istediğinizde

**İçindekiler**:
- Tüm yapılan yapılandırmalar
- SDK versiyonları
- İzin listesi
- Güvenlik notları
- Sorun giderme

👉 **[README_YAYIN_HAZIRLIK.md dosyasını aç](README_YAYIN_HAZIRLIK.md)**

---

## 🚀 Hızlı Başlangıç (3 Adım)

### ⚠️ ÖNEMLİ: Keystore'u YEDEKLEYİN!

### Adım 1: Keystore Oluştur (5 dk)

Terminal açın ve çalıştırın:

```bash
keytool -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

Eğer keytool bulunamazsa:

```bash
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

**Yedekle**: Bu dosyayı ve şifrelerini MUTLAKA güvenli bir yerde saklayın!

---

### Adım 2: key.properties Oluştur (2 dk)

`android/key.properties` dosyası oluşturun:

```properties
storePassword=<KEYSTORE_ŞİFRESİ>
keyPassword=<KEY_ŞİFRESİ>
keyAlias=release
storeFile=app/release-key.jks
```

**Önemli**: `android/key.properties.example` dosyasını kopyalayıp düzenleyebilirsiniz.

---

### Adım 3: Release Build Al (10 dk)

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Çıktı: `build/app/outputs/bundle/release/app-release.aab`

---

## 📱 Google Play Console

### Hızlı Yükleme

1. **Play Console**: https://play.google.com/console
2. **Uygulama oluştur**: "Work Schedule" 
3. **Üretim > Yeni sürüm**: AAB dosyasını yükle
4. **Sürüm notları**: GUIDE_GOOGLE_PLAY_YAYINI.md'den kopyala
5. **Mağaza profili**: Ekran görüntüleri, açıklamalar
6. **Gizlilik politikası**: ⚠️ ZORUNLU - URL ekle
7. **Veri güvenliği**: İzin açıklamaları ekle
8. **Gönder**: İnceleme 1-3 gün

---

## ✅ Ne Hazır?

### Yapılandırılmış Dosyalar

- ✅ `android/app/build.gradle.kts` - Release signing
- ✅ `android/app/proguard-rules.pro` - ProGuard kuralları
- ✅ `android/app/src/main/AndroidManifest.xml` - İzinler
- ✅ `android/key.properties.example` - Örnek dosya

### Versiyon Bilgileri

- **Application ID**: `com.workschedule.app`
- **Version**: `1.0.0+1`
- **Min SDK**: 24 (Android 7.0+)
- **Target SDK**: 34 (Android 14)

### İzinler

- ✅ POST_NOTIFICATIONS (Bildirimler)
- ✅ SCHEDULE_EXACT_ALARM (Hassas zamanlama)
- ✅ RECEIVE_BOOT_COMPLETED (Yeniden başlatma)
- ✅ VIBRATE (Titreşim)
- ✅ USE_FULL_SCREEN_INTENT (Tam ekran bildirim)

---

## ⚠️ Önemli Notlar

### 1. Keystore Yedekleme
**ÇOK ÖNEMLİ**: Keystore'u kaybederseniz uygulamayı güncelleyemezsiniz!
- USB'de saklayın
- Bulut servisinde yedekleyin
- Şifreleri parola yöneticisinde tutun

### 2. Gizlilik Politikası
**ZORUNLU**: Firebase kullandığınız için zorunludur.
- Ücretsiz oluştur: https://www.privacypolicygenerator.info/
- URL'i Play Console'a ekleyin

### 3. Version Code
Her güncellemede artırın:
```yaml
version: 1.0.0+1  # İlk sürüm
version: 1.0.1+2  # İlk güncelleme
version: 1.1.0+3  # Yeni özellikler
```

### 4. Firebase Yapılandırması
SHA-1 ve SHA-256 fingerprint'lerini Firebase Console'a ekleyin:
```bash
keytool -list -v -keystore android/app/release-key.jks -alias release
```

### 5. Test
Production'a geçmeden önce:
- Internal Testing'de test edin
- Closed Testing'de beta kullanıcılarla test edin
- Tüm özelliklerin çalıştığından emin olun

---

## 🆘 Yardım

### Sorun mu yaşıyorsunuz?

**Build hatası**:
- `RELEASE_CHECKLIST.md` dosyasındaki sorun giderme bölümüne bakın
- `flutter clean` ve `flutter pub get` yapın

**Keystore hatası**:
- `key.properties` dosyasını kontrol edin
- Şifrelerin doğru olduğundan emin olun

**Google Play reddetme**:
- İzin açıklamalarını kontrol edin
- Gizlilik politikası URL'inin çalıştığından emin olun
- İçerik derecelendirme formunu tamamlayın

### Detaylı Bilgi

- **Flutter Docs**: https://flutter.dev/docs/deployment/android
- **Play Console Help**: https://support.google.com/googleplay/android-developer
- **Firebase Docs**: https://firebase.google.com/docs

---

## 📞 İletişim

Sorularınız için:
1. Rehber dosyalarını kontrol edin
2. Flutter dokümantasyonuna bakın
3. Stack Overflow'da araştırın

---

## 🎉 Başarılar!

Artık hazırsınız! Google Play'e yükleme sürecinizde başarılar dileriz.

**Özet**:
1. Keystore oluştur → **YEDEKLE!**
2. key.properties oluştur
3. Build al
4. Google Play Console'a yükle

**Yol Haritası**:
```
RELEASE_CHECKLIST.md → Hızlı adımlar
  ↓
GUIDE_GOOGLE_PLAY_YAYINI.md → Detaylar
  ↓
README_YAYIN_HAZIRLIK.md → Kontroller
  ↓
Google Play Console → Yayın!
```

**İyi şanslar! 🚀**

---

*Bu kılavuz Work Schedule projesi için özel olarak hazırlanmıştır.*  
*Son güncelleme: 2025*

