# Google Play Yayını İçin Hazırlık Rehberi

Bu rehber, workSchedule uygulamanızı Google Play'e yüklemek için gereken tüm adımları içermektedir.

## 📋 Hazırlanması Gerekenler Özeti

1. ✅ Release keystore oluşturma
2. ✅ key.properties dosyası oluşturma
3. ✅ build.gradle.kts yapılandırması
4. ✅ Version kodları
5. ✅ İzinler ve izin açıklamaları
6. ✅ App ikonu ve metadata
7. ✅ Sürüm notları
8. ✅ APK/AAB build alma

---

## 🔐 1. Release Keystore Oluşturma

### Adım 1.1: Keystore Komutu

Windows Git Bash'te şu komutu çalıştırın (keytool'u Java'nın bin klasöründen çağırın):

```bash
# Java keytool'un yolunu bulun (genellikle)
$JAVA_HOME/bin/keytool -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

VEYA Flutter'ın keytool'unu kullanın:
```bash
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

### Adım 1.2: Keystore Bilgileri

İstendiğinde şu bilgileri gireceksiniz:
- **Şifre**: Güçlü bir şifre (unutmayın!)
- **Ad Soyad**: Kerim veya tam adınız
- **Organizasyon Birimi**: (boş bırakabilirsiniz)
- **Organizasyon**: (boş bırakabilirsiniz)
- **Şehir**: (ör: İstanbul)
- **Eyalet/Bölge**: (ör: İstanbul)
- **Ülke Kodu**: TR (Türkiye için)

⚠️ **ÖNEMLİ**: Bu keystore dosyası ve şifreleri MUTLAKA YEDEKLEYİN! Kaybederseniz uygulamanızı güncelleyemezsiniz!

---

## 📝 2. key.properties Dosyası Oluşturma

`android/key.properties` dosyası oluşturun:

```properties
storePassword=<KEYSTORE_ŞİFRESİ>
keyPassword=<KEY_ŞİFRESİ>
keyAlias=release
storeFile=app/release-key.jks
```

**Örnek**:
```properties
storePassword=BenimGizliSifre123!
keyPassword=BenimGizliSifre123!
keyAlias=release
storeFile=app/release-key.jks
```

---

## ⚙️ 3. build.gradle.kts Yapılandırması

`android/app/build.gradle.kts` dosyasını aşağıdaki şekilde güncelleyin:

```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Keystore bilgilerini yükle
val keystoreProperties = java.util.Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.workschedule.app"
    compileSdk = 34  // compileSdk = flutter.compileSdkVersion yerine sabit değer
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.workschedule.app"
        minSdk = 24  // Android 7.0+ (bildirimler için önemli)
        targetSdk = 34  // Android 14
        versionCode = 1
        versionName = "1.0.0"
        
        // Multidex desteği (Firebase için gerekli olabilir)
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true  // ProGuard/R8 optimizasyonu
            isShrinkResources = true  // Kullanılmayan kaynakları temizle
            
            // ProGuard rules dosyası
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Dönüşüm uyarılarını bastır
    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }
}

flutter {
    source = "../.."
}
```

---

## 📦 4. Version Kodları ve Versiyon

`pubspec.yaml` dosyasında versiyon:

```yaml
version: 1.0.0+1  # versionName+versionCode
```

- `1.0.0` = Kullanıcıya görünen versiyon (versionName)
- `1` = Google Play'deki build numarası (versionCode) - her yüklemede artırılmalı

**Her güncelleme için**:
```yaml
version: 1.0.1+2  # Küçük güncelleme
version: 1.1.0+3  # Yeni özellikler
version: 2.0.0+4  # Büyük güncelleme
```

---

## 🔔 5. İzinler ve Açıklamaları

### 5.1: AndroidManifest.xml'deki İzinler

`android/app/src/main/AndroidManifest.xml` - **Mevcut izinleriniz**:

```xml
<!-- Bildirim izinleri -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

### 5.2: Google Play Console'da İzin Açıklamaları

Google Play Console > Uygulama içeriği > Veri güvenliği > İzinler bölümünde şu açıklamaları ekleyin:

**POST_NOTIFICATIONS (Android 13+)**:
> "Uygulama, iş günü ve etkinlik bildirimleri göndermek için kullanılır. Kullanıcılar bildirim izinlerini uygulama ayarlarından devre dışı bırakabilir."

**SCHEDULE_EXACT_ALARM**:
> "Etkinlikler için hassas zamanlanmış bildirimler göndermek için kullanılır."

**RECEIVE_BOOT_COMPLETED**:
> "Cihaz yeniden başlatıldıktan sonra zamanlanmış bildirimleri yeniden oluşturmak için kullanılır."

**VIBRATE**:
> "Bildirimler geldiğinde titreşim özelliğini kullanmak için."

**USE_FULL_SCREEN_INTENT**:
> "Kilit ekranında tam ekran bildirimler göstermek için kullanılır."

### 5.3: İhtiyaç Duyabileceğiniz Ek İzinler

Paket kullanımlarınızda `file_picker` ve `image_picker` var. İsterseniz ekleyin:

```xml
<!-- Dosya ve fotoğraf seçim için -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

Açıklaması:
> "Kullanıcıların etkinliklere fotoğraf ve dosya eklemesine izin verir. İzin kullanıcı tarafından onaylanmadığı sürece erişim sağlanmaz."

---

## 🎨 6. App İkonu ve Metadata

### 6.1: App İkonu

Mevcut launcher ikonlarınız var:
- `mipmap-hdpi/ic_launcher.png`
- `mipmap-mdpi/ic_launcher.png`
- `mipmap-xhdpi/ic_launcher.png`
- `mipmap-xxhdpi/ic_launcher.png`
- `mipmap-xxxhdpi/ic_launcher.png`

✅ Bu ikonları özelleştirebilirsiniz.

### 6.2: App Label (Uygulama Adı)

`AndroidManifest.xml`:
```xml
android:label="workschedule"
```

⚠️ **Önerilen değişiklik**: Daha okunabilir bir isim
```xml
android:label="Work Schedule"
```

### 6.3: App ID (Package Name)

`com.workschedule.app` - Google Play'de değiştirilemez! İlk yayın öncesi kontrol edin.

---

## 📝 7. ProGuard Rules

`android/app/proguard-rules.pro` dosyası oluşturun:

```pro
# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Google Sign-In
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Google APIs
-keep class com.google.api.** { *; }
-keep class com.google.protobuf.** { *; }

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# Isar Database
-keep class io.isar.** { *; }

# Work Manager
-keep class androidx.work.** { *; }

# OkHttp
-dontwarn okhttp3.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
```

---

## 📄 8. Google Play Console için Hazırlıklar

### 8.1: Gerekli Dosyalar ve Bilgiler

#### Uygulama Bilgileri:
- **Uygulama Adı**: Work Schedule (veya istediğiniz isim)
- **Kısa Açıklama**: "İş programınızı organize edin, etkinlikler oluşturun"
- **Uzun Açıklama**:
```
Work Schedule ile iş programınızı kolayca yönetin. 

Özellikler:
📅 Takvim görünümünde etkinliklerinizi görüntüleyin
⏰ Hassas zamanlanmış bildirimler alın
☁️ Firebase ile bulut senkronizasyonu
📸 Etkinliklere fotoğraf ekleyin
🎨 Modern ve kullanıcı dostu arayüz
🔄 Google Calendar ile entegrasyon

İş programınızı hiç olmadığı kadar kolay yönetin!
```

- **Kategori**: Productivity (Verimlilik)
- **İçerik Derecelendirmesi**: PEGI 3 / Everyone
- **Fiyatlandırma**: Ücretsiz

#### Erişilebilirlik:
- **Telefon**: 16+
- **Tablet**: Destekleniyor

#### Gizlilik Politikası:
⚠️ **Oluşturmanız gerekiyor!** Uygulamanız:
- Kullanıcı girişi yapıyor (Firebase Auth)
- Veri depoluyor (Firebase Firestore)
- Google Calendar API kullanıyor
- Dosya ve resim erişimi var

Bir gizlilik politikası sayfası oluşturun veya şu ücretsiz araçları kullanın:
- https://www.privacypolicygenerator.info/
- https://www.freeprivacypolicy.com/

#### İçerik Derecelendirmesi:
PEGI 3 (Herkes) - bir iş programı uygulaması olduğu için

---

## 🏗️ 9. Release Build Alma

### 9.1: App Bundle (AAB) Oluşturma (ÖNERİLEN)

Google Play kendi optimizasyonunu yapar, APK yerine AAB tercih edin:

```bash
flutter build appbundle --release
```

Çıktı: `build/app/outputs/bundle/release/app-release.aab`

### 9.2: APK Oluşturma (Test için)

```bash
flutter build apk --release
```

### 9.3: Splitted APK'lar (AAB yerine APK istiyorsanız)

```bash
flutter build apk --release --split-per-abi
```

---

## 🚀 10. Google Play Console'a Yükleme Adımları

### Adım 1: Play Console Hesabı
1. https://play.google.com/console adresine gidin
2. Bir kerelik $25 kayıt ücreti ödeyin
3. Developer hesabı oluşturun

### Adım 2: Uygulama Oluşturma
1. **Uygulamalar** > **Uygulama oluştur**
2. Uygulama adı: "Work Schedule"
3. Dil: Türkçe
4. Uygulama veya oyun: Uygulama
5. Ücretsiz mi, yoksa ücretli mi: Ücretsiz
6. Uygulama imzalama: Google, uygulama imzalamayı yönetir (önerilir)

### Adım 3: Üretim Yolu Oluşturma
1. **Üretim** > **Yeni sürüm oluştur**
2. AAB dosyasını yükleyin
3. Sürüm adı: "1.0.0"
4. Sürüm notları (en az 300 karakter olmalı):

```
İlk Sürüm - Work Schedule

🎉 Work Schedule uygulamasına hoş geldiniz!

Bu sürümde sunulan özellikler:

📅 TAKVİM YÖNETİMİ
- Aylık, haftalık ve günlük takvim görünümleri
- Kolay etkinlik oluşturma ve düzenleme
- Etkinlik detaylı bilgileri

⏰ BİLDİRİMLER
- Hassas zamanlanmış etkinlik hatırlatıcıları
- Cihaz yeniden başlatıldıktan sonra otomatik yeniden zamanlama
- Özelleştirilebilir bildirim ayarları

☁️ SİNKRONİZASYON
- Firebase bulut depolama ile verilerinizi güvenle saklayın
- Çoklu cihaz desteği
- Otomatik yedekleme

🔐 GÜVENLİK
- Google ile güvenli giriş
- Kullanıcı bazlı veri gizliliği

🎨 MODERN TASARIM
- Kullanıcı dostu arayüz
- Karanlık tema desteği
- Hızlı ve sorunsuz kullanım

🗂️ ORGANİZASYON
- Etkinlik kategorileri
- Arama ve filtreleme özellikleri
- PDF olarak dışa aktarma

İş programınızı hiç olmadığı kadar kolay yönetin! Herhangi bir sorunuz veya öneriniz varsa bizimle iletişime geçmekten çekinmeyin.
```

### Adım 4: Mağaza Profili
1. **Mağaza kullanıcı arayüzü** bölümüne gidin
2. Gerekli alanları doldurun:
   - Uygulama simgesi (512x512)
   - Özellik grafiği (1024x500)
   - Telefon ekran görüntüleri (minimum 2, önerilen 8)
   - Kısa açıklama
   - Uzun açıklama
   - Puanlama ve geri bildirim politikasına bağlılık
   - Veri güvenliği
   - Hedef kitle ve içerik

### Adım 5: Uygulama İçeriği
- **Veri güvenliği**: Kullandığınız izinler için açıklamalar
- **Gizlilik politikası**: URL ekleyin
- **İçerik derecelendirmesi**: Formu doldurun

### Adım 6: Test
- **Kontrol listesi**: Tüm maddeler ✓ olmalı
- **Erişilebilirlik**: Politikayı uygulayın

### Adım 7: Gönder
1. **Uygulamayı gönder** butonuna tıklayın
2. İnceleme süresi: 1-3 gün
3. Onay sonrası yayınlanır

---

## ⚠️ ÖNEMLİ UYARILAR

### 1. Keystore Yedekleme
- `release-key.jks` dosyasını YEDEKLEYİN
- `key.properties` içindeki şifreleri güvenli saklayın
- Keystore kaybedilirse uygulama güncellenemez

### 2. İlk Yayın Öncesi Test
- Internal Testing'de test edin
- Closed Testing'de beta kullanıcılarla test edin
- Production'a geçmeden önce her şeyin çalıştığından emin olun

### 3. VersionCode Artırma
Her yeni yüklemede `versionCode` artırılmalı:
```yaml
version: 1.0.0+1  # İlk yayın
version: 1.0.1+2  # İlk güncelleme
version: 1.1.0+3  # Yeni özellikler
```

### 4. ProGuard Uyarıları
İlk build sonrası crash log'ları kontrol edin. Gerekirse `proguard-rules.pro` dosyasına eklemeler yapın.

### 5. Firebase Yapılandırması
- `google-services.json` dosyası doğru yerde mi kontrol edin
- SHA-1 ve SHA-256 fingerprint'leri Play Console'da kayıtlı mı kontrol edin

---

## 📊 Yükleme Sonrası Checklist

- [ ] Google Play Console'da uygulama oluşturuldu
- [ ] Uygulama bilgileri (ad, açıklama, kategori) eklendi
- [ ] Ekran görüntüleri eklendi
- [ ] Gizlilik politikası URL'i eklendi
- [ ] Veri güvenliği bölümü dolduruldu
- [ ] İçerik derecelendirmesi tamamlandı
- [ ] AAB dosyası üretim yoluna yüklendi
- [ ] Sürüm notları yazıldı (300+ karakter)
- [ ] Kontrol listesi tamamlandı
- [ ] Uygulama gönderildi
- [ ] Keystore dosyası yedeklendi

---

## 🎯 Hızlı Başlangıç Özeti

```bash
# 1. Keystore oluştur
$JAVA_HOME/bin/keytool -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# 2. key.properties oluştur (yukarıdaki örnekteki gibi)

# 3. build.gradle.kts'i güncelle (yukarıdaki kodla)

# 4. Version'ı güncelle
# pubspec.yaml: version: 1.0.0+1

# 5. Build al
flutter clean
flutter pub get
flutter build appbundle --release

# 6. Google Play Console'a yükle
# build/app/outputs/bundle/release/app-release.aab
```

---

## 📞 Destek

Sorularınız için:
- Flutter Dokümantasyonu: https://flutter.dev/docs
- Google Play Console Yardım: https://support.google.com/googleplay/android-developer

**İyi şanslar! 🚀**

