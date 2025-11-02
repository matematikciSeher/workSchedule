a# 🔥 Firebase Email/Password Authentication Kurulum Rehberi

Bu rehber, Firebase Console'da Email/Password authentication özelliğini nasıl etkinleştireceğinizi adım adım anlatmaktadır.

## 📋 Gereksinimler

- Firebase projesi oluşturulmuş olmalı
- Firebase Console'a erişim yetkiniz olmalı
- Proje ID: `workschedule-f01ad`

---

## 🚀 Adım Adım Kurulum

### ADIM 1: Firebase Console'a Giriş Yapın

1. Web tarayıcınızı açın (Chrome, Firefox, Edge, Safari vb.)
2. Aşağıdaki adrese gidin:
   ```
   https://console.firebase.google.com
   ```
3. Google hesabınızla giriş yapın
   - Firebase projenizi oluştururken kullandığınız Google hesabıyla giriş yapmalısınız

---

### ADIM 2: Doğru Projeyi Seçin

1. Firebase Console ana sayfasında, üst kısımdaki proje seçici menüden projenizi bulun
2. **`workschedule-f01ad`** projesine tıklayın
   - Eğer projeyi göremiyorsanız, "All projects" yazısına tıklayarak tüm projeleri listeleyebilirsiniz

![Proje Seçimi](https://firebase.google.com/docs/projects/images/select-project.png)

---

### ADIM 3: Authentication Bölümüne Gidin

1. Sol taraftaki menüden (hamburger menü) şu sekmeleri görürsünüz:
   - Build
   - Engage
   - Extend
   - **Authentication** ← Bunu seçin
   
2. **Authentication** yazısına tıklayın

![Authentication Menü](https://firebase.google.com/docs/auth/images/auth-console.png)

---

### ADIM 4: Sign-in Method Sayfasını Açın

1. Authentication sayfasına geldiğinizde üst kısımda birkaç sekme göreceksiniz:
   - **Users** sekmesi (varsayılan olarak açık olabilir)
   - **Sign-in method** sekmesi ← **Bunu seçin**
   
2. **Sign-in method** sekmesine tıklayın

![Sign-in Method Sekmesi](https://firebase.google.com/docs/auth/images/sign-in-methods.png)

---

### ADIM 5: Email/Password Provider'ı Bulun

1. Sign-in method sayfasında, birçok authentication sağlayıcısı listelenir:
   - Email/Password ← **Bunu bulun**
   - Google
   - Facebook
   - Twitter
   - GitHub
   - vb.

2. **Email/Password** satırını bulun
   - Genellikle listenin en üstünde veya ikinci sırasında yer alır
   - Durumu muhtemelen **"Disabled"** (Devre Dışı) olarak görünüyor

![Email/Password Provider](https://firebase.google.com/docs/auth/images/email-password-provider.png)

---

### ADIM 6: Email/Password'u Etkinleştirin

1. **Email/Password** satırına tıklayın
   - Tıklayınca bir popup/dialog penceresi açılacak

2. Açılan pencerede şunları göreceksiniz:
   - **Enable** toggle (açma/kapama düğmesi) ← **Bunu açın**
   - **Email link (passwordless sign-in)** seçeneği (isteğe bağlı)

3. **Enable** toggle'ını **AÇIK** konuma getirin (sağa kaydırın)
   - Toggle mavi veya yeşil renkte olacak

4. **Email link (passwordless sign-in)** seçeneği:
   - Bu seçeneği şimdilik **KAPALI** bırakabilirsiniz
   - Sadece Email/Password ile giriş yapmak istiyorsak bunu açmanıza gerek yok

![Email/Password Enable Dialog](https://firebase.google.com/docs/auth/images/enable-email-password.png)

---

### ADIM 7: Ayarları Kaydedin

1. Dialog penceresinin alt kısmında **Save** (Kaydet) butonuna tıklayın
   - Eğer Save butonu görünmüyorsa, Enable toggle'ını açtıktan sonra otomatik olarak görünür

2. Kaydetme işlemi tamamlandığında:
   - Dialog penceresi kapanacak
   - Email/Password satırının durumu **"Enabled"** (Etkin) olarak değişecek
   - Yeşil bir işaret veya "Enabled" yazısı görünecek

![Email/Password Enabled](https://firebase.google.com/docs/auth/images/email-password-enabled.png)

---

### ADIM 8: Doğrulama

1. Sign-in method sayfasında **Email/Password** satırını kontrol edin
2. Durumun **"Enabled"** olduğundan emin olun
3. Eğer hala "Disabled" görünüyorsa:
   - Sayfayı yenileyin (F5 veya Ctrl+R)
   - Tekrar Adım 5-7'yi tekrarlayın

---

## ✅ Tamamlandı!

Artık Firebase Console'da Email/Password authentication etkin. Şimdi Flutter uygulamanızda kayıt ve giriş yapabilirsiniz.

---

## 🔄 Sonraki Adımlar

### Flutter Uygulamanızda Test Edin

1. **Uygulamayı tamamen kapatın**
   - Android Studio'da çalıştırıyorsanız, uygulamayı durdurun
   - Telefonda çalıştırıyorsanız, uygulamayı tamamen kapatın

2. **Uygulamayı yeniden başlatın**
   - Hot reload yeterli değil, tam yeniden başlatma gerekli

3. **Kayıt sayfasını açın**
   - "Üye Ol" butonuna tıklayın

4. **Test bilgileri girin:**
   - Email: `test@example.com` (veya gerçek bir email)
   - Şifre: `123456` (en az 6 karakter)
   - Şifre Tekrar: `123456`

5. **"Üye Ol" butonuna tıklayın**

6. **Başarılı olursa:**
   - Ana sayfaya yönlendirileceksiniz
   - Yeşil bir başarı mesajı göreceksiniz

---

## ❌ Sorun Giderme

### Sorun 1: Email/Password seçeneği görünmüyor
**Çözüm:**
- Sayfayı yenileyin (F5)
- Farklı bir tarayıcı deneyin
- Tarayıcı önbelleğini temizleyin

### Sorun 2: Enable toggle açılmıyor
**Çözüm:**
- Tarayıcı JavaScript'inin etkin olduğundan emin olun
- Ad blocker eklentisini geçici olarak kapatın
- Farklı bir tarayıcı deneyin

### Sorun 3: Save butonuna tıklayınca hata alıyorum
**Çözüm:**
- İnternet bağlantınızı kontrol edin
- Firebase Console'da proje yetkilerinizin olduğundan emin olun
- Sayfayı yenileyip tekrar deneyin

### Sorun 4: Etkinleştirdim ama hala hata alıyorum
**Çözüm:**
1. Firebase Console'da Email/Password'un gerçekten "Enabled" olduğunu kontrol edin
2. Uygulamayı **tamamen kapatıp yeniden açın** (hot reload yeterli değil)
3. Telefonda/emülatörde internet bağlantısını kontrol edin
4. Firebase Console'da başka bir auth yöntemi (Google) deneyin - eğer o da çalışmıyorsa genel bir sorun olabilir

### Sorun 5: "CONFIGURATION_NOT_FOUND" hatası devam ediyor
**Çözüm:**
1. Firebase Console'da Authentication > Sign-in method sayfasına gidin
2. Email/Password'un **Enabled** olduğunu doğrulayın
3. Birkaç saniye bekleyin (Firebase'in ayarları uygulaması zaman alabilir)
4. Flutter uygulamanızı **tamamen kapatıp yeniden başlatın**
5. Firebase proje ID'nin doğru olduğundan emin olun: `workschedule-f01ad`

---

## 📸 Görsel Referanslar

Eğer görsel yardıma ihtiyacınız varsa, Firebase'in resmi dokümantasyonunu ziyaret edebilirsiniz:

- [Firebase Authentication Dokümantasyonu](https://firebase.google.com/docs/auth)
- [Email/Password Authentication](https://firebase.google.com/docs/auth/web/password-auth)

---

## 🎯 Özet Checklist

- [ ] Firebase Console'a giriş yaptım
- [ ] Doğru projeyi seçtim (`workschedule-f01ad`)
- [ ] Authentication bölümüne gittim
- [ ] Sign-in method sekmesini açtım
- [ ] Email/Password provider'ını buldum
- [ ] Enable toggle'ını AÇIK yaptım
- [ ] Save butonuna tıkladım
- [ ] Email/Password'un "Enabled" olduğunu doğruladım
- [ ] Flutter uygulamasını tamamen kapattım ve yeniden açtım
- [ ] Kayıt yapmayı denedim

---

## 💡 İpuçları

1. **Firebase Console'u tarayıcıda açık tutun** - Ayarları kontrol etmek için hızlı erişim sağlar

2. **Firebase proje ID'nizi not alın** - `workschedule-f01ad` - İleride ihtiyacınız olabilir

3. **Test email'leri kullanın** - Gerçek email adresleriyle test ederken, e-posta doğrulama linkini kontrol etmeyi unutmayın

4. **Firebase Console'da Users sekmesini kontrol edin** - Kayıt olduktan sonra kullanıcılarınızı burada görebilirsiniz

5. **Firestore Rules kontrolü** - Eğer veri kaydetmeye çalışıyorsanız, Firestore Rules'ın doğru yapılandırıldığından emin olun

---

## 📞 Yardım

Eğer hala sorun yaşıyorsanız:

1. Firebase Console ekran görüntüsü alın
2. Hata mesajının tam halini kopyalayın
3. Flutter console log'larını kontrol edin
4. Internet bağlantınızı test edin

**Başarılar! 🚀**


