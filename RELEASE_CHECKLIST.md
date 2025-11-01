# 🚀 Google Play Yayını - Hızlı Kontrol Listesi

## ✅ Hazırlanan Dosyalar

### 1. Yapılandırma Dosyaları
- ✅ `android/app/build.gradle.kts` - Release signing yapılandırıldı
- ✅ `android/app/proguard-rules.pro` - ProGuard kuralları eklendi
- ✅ `android/app/src/main/AndroidManifest.xml` - App label güncellendi
- ✅ `android/key.properties.example` - Örnek keystore dosyası

### 2. Dokümantasyon
- ✅ `GUIDE_GOOGLE_PLAY_YAYINI.md` - Detaylı yayın rehberi

---

## 🔧 Yapmanız Gereken Adımlar

### ADIM 1: Keystore Oluşturma ⚠️ ÖNEMLİ

Terminal'de şu komutu çalıştırın:

**Windows (Git Bash veya CMD)**:
```bash
keytool -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

**Eğer keytool bulunamazsa**:
```bash
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

**İstenen Bilgiler**:
- Keystore şifresi: [GÜÇLÜ BİR ŞİFRE - UNUTMAYIN!]
- Tekrar gir:
- Şifre doğrulama: [Evet için y basın]
- Ad Soyad: Kerim
- Organizasyon birimi: [Boş bırakabilirsiniz]
- Organizasyon: [Boş bırakabilirsiniz]
- Şehir: [örn: İstanbul]
- Eyalet: [örn: İstanbul]
- Ülke kodu: TR

⚠️ **Bu dosya ve şifreler MUTLAKA YEDEKLENMELİDİR!**

---

### ADIM 2: key.properties Dosyası Oluşturma

`android/key.properties` dosyası oluşturun (key.properties.example'ı kopyalayıp düzenleyin):

```properties
storePassword=<OLUŞTURDUĞUNUZ_KEYSTORE_ŞİFRESİ>
keyPassword=<OLUŞTURDUĞUNUZ_KEY_ŞİFRESİ>
keyAlias=release
storeFile=app/release-key.jks
```

**Örnek**:
```properties
storePassword=BenimSuperGizliSifre123!@#
keyPassword=BenimSuperGizliSifre123!@#
keyAlias=release
storeFile=app/release-key.jks
```

---

### ADIM 3: Versiyon Kontrolü

`pubspec.yaml` dosyasında versiyon kontrol edin:

```yaml
version: 1.0.0+1  # Tamam, ilk sürüm için uygun
```

- `1.0.0` = Kullanıcıya görünen versiyon
- `1` = Build numarası (her yüklemede artırılmalı)

---

### ADIM 4: Gerekli İzinleri Kontrol Edin

`android/app/src/main/AndroidManifest.xml` - Mevcut izinleriniz:

✅ POST_NOTIFICATIONS - Android 13+ bildirim izni  
✅ SCHEDULE_EXACT_ALARM - Hassas zamanlanmış bildirimler  
✅ RECEIVE_BOOT_COMPLETED - Cihaz yeniden başlatma sonrası bildirimler  
✅ VIBRATE - Titreşim özelliği  
✅ USE_FULL_SCREEN_INTENT - Tam ekran bildirimler  

**Google Play Console'da** bu izinler için açıklama eklemeyi unutmayın! (Detaylar için `GUIDE_GOOGLE_PLAY_YAYINI.md` dosyasına bakın)

---

### ADIM 5: Release Build Alma

```bash
# Projeyi temizle
flutter clean

# Bağımlılıkları yükle
flutter pub get

# AAB (App Bundle) oluştur - Google Play için önerilen format
flutter build appbundle --release

# VEYA APK oluştur (test için)
flutter build apk --release
```

**Çıktı Dosyası**:
- AAB: `build/app/outputs/bundle/release/app-release.aab`
- APK: `build/app/outputs/flutter-apk/app-release.apk`

---

### ADIM 6: Google Play Console'a Yükleme

1. **Play Console Hesabı**: https://play.google.com/console
   - İlk kez: $25 kayıt ücreti

2. **Uygulama Oluştur**:
   - Uygulama adı: "Work Schedule"
   - Dil: Türkçe
   - Kategori: Uygulama > Verimlilik

3. **Üretim Yolu** > **Yeni Sürüm Oluştur**:
   - `app-release.aab` dosyasını yükleyin
   - Sürüm adı: 1.0.0
   - Sürüm notları (min 300 karakter): Bkz. `GUIDE_GOOGLE_PLAY_YAYINI.md`

4. **Mağaza Profili**:
   - Uygulama simgesi: 512x512 px
   - Özellik grafiği: 1024x500 px
   - Ekran görüntüleri: Minimum 2, önerilen 8
   - Kısa açıklama
   - Uzun açıklama
   - Kategori
   - Gizlilik politikası URL'i

5. **Veri Güvenliği**:
   - Kullandığınız izinler için açıklama ekleyin
   - Veri toplama yöntemleri beyan edin

6. **İçerik Derecelendirmesi**:
   - PEGI 3 veya E (Everyone) formunu doldurun

7. **Test**:
   - Internal Testing veya Closed Testing'de test edin

8. **Gönder**:
   - İnceleme: 1-3 gün

---

## 📋 Ek Kontroller

### Firebase Yapılandırması
- [ ] `google-services.json` dosyası doğru konumda mı? (`android/app/`)
- [ ] Firebase projesinde SHA-1 ve SHA-256 sertifika parmak izleri ekli mi?

### App İkonu
- [ ] İkon dosyalarını özelleştirdiniz mi?
- [ ] Tüm mipmap klasörlerinde ikon var mı?

### Gizlilik Politikası
- [ ] Gizlilik politikası oluşturuldu mu?
- [ ] URL Google Play Console'a eklendi mi?

### Test
- [ ] Internal Testing'de test edildi mi?
- [ ] Tüm özellikler çalışıyor mu?
- [ ] Bildirimler çalışıyor mu?
- [ ] Giriş/çıkış çalışıyor mu?

---

## ⚠️ ÖNEMLİ UYARILAR

1. **Keystore Yedekleme**: `release-key.jks` ve şifreleri yedekleyin!
2. **VersionCode Artırma**: Her güncellemede versionCode artırılmalı
3. **Yedekleme**: Keystore kaybedilirse uygulama güncellenemez!
4. **Gizlilik Politikası**: Zorunludur (Firebase kullanıyorsunuz)
5. **İzin Açıklamaları**: Google Play Console'da izinler için açıklama ekleyin

---

## 🎯 Hızlı Komutlar

```bash
# Keystore oluştur
keytool -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# Build al
flutter clean
flutter pub get
flutter build appbundle --release

# Google Play Console'a yükle
# build/app/outputs/bundle/release/app-release.aab
```

---

## 📞 Yardım

Detaylı bilgi için:
- `GUIDE_GOOGLE_PLAY_YAYINI.md` - Kapsamlı rehber
- Flutter Docs: https://flutter.dev/docs/deployment/android
- Play Console Help: https://support.google.com/googleplay/android-developer

**İyi şanslar! 🚀**

