# Shared Widgets

Bu klasör, uygulama genelinde kullanılan paylaşımlı widget'ları içerir.

## 📦 Widget'lar

### 1. EventCard

Etkinlikleri temsil eden modern ve interaktif kart widget'ı.

#### Özellikler

- ✨ **Modern Tasarım**: Material 3 tasarım prensipleriyle hazırlanmış
- 🎨 **Renk Etiketli**: Sol tarafta renkli çubuk ile kategori görselleştirmesi
- 📅 **Akıllı Tarih Formatı**: Tarih gösterimi (Bugün, Yarın, X gün önce/sonra)
- 🎭 **Animasyonlar**: Hover ve tap animasyonları
- 🌓 **Tema Desteği**: Light ve Dark mode desteği
- 📱 **Responsive**: Tüm ekran boyutlarına uyumlu
- ♿ **Erişilebilirlik**: Semantic widgets kullanımı

#### Parametreler

```dart
EventCard({
  required String title,              // Etkinlik başlığı
  required DateTime dateTime,         // Tarih ve saat
  required IconData categoryIcon,     // Kategori simgesi
  required String colorLabel,         // Hex renk kodu (örn: 'FF2196F3')
  VoidCallback? onTap,               // Tıklama callback'i
  VoidCallback? onLongPress,         // Uzun basma callback'i
  String? description,               // Açıklama (isteğe bağlı)
  double? height,                    // Kart yüksekliği (isteğe bağlı)
})
```

#### Kullanım Örneği

```dart
EventCard(
  title: 'Ekip Toplantısı',
  dateTime: DateTime.now(),
  categoryIcon: Icons.groups,
  colorLabel: 'FF2196F3',
  description: 'Aylık değerlendirme toplantısı',
  onTap: () {
    // Kart'a tıklandığında yapılacak işlem
    print('Kart tıklandı');
  },
  onLongPress: () {
    // Uzun basıldığında yapılacak işlem
    print('Kart uzun basıldı');
  },
)
```

#### Animasyon Detayları

- **Scale Animasyon**: Tıklama anında kart %97 ölçeğine küçülür
- **Elevation Animasyon**: Üst gölge efekti artar (2 → 8)
- **Süre**: 150ms (smooth transition)

#### Tema Özellikleri

- Light mode: Açık renkli kartlar, koyu metinler
- Dark mode: Koyu renkli kartlar, açık metinler
- Dinamik gölge efektleri

#### Renk Formatı

Hex renk formatında (6 veya 8 karakter):
- `FF2196F3` - Alpha dahil (8 karakter)
- `2196F3` - Alpha yok (6 karakter, varsayılan alpha: FF)

#### Tarih Formatı

Tarih gösterimi otomatik olarak şu formatları kullanır:

- **Bugün**: "Bugün, 14:30"
- **Yarın**: "Yarın, 09:00"
- **Dün**: "Dün, 16:45"
- **Geçmiş**: "3 gün önce, 10:15"
- **Yakın gelecek**: "2 gün sonra, 11:00"
- **Uzak gelecek**: "15 Ocak 2024, 13:00"

### 2. EventCardExample

Etkinlik kartı widget'ının örnek kullanım sayfası.

Birçok farklı etkinlik kartı örneği içerir:
- Toplantı
- Sunum
- Eğitim
- Randevu
- Alışveriş

#### Kullanım

```dart
import 'package:work_schedule/shared/widgets/event_card_widget.dart';

// Doğrudan kullanabilirsiniz
EventCardExample()
```

## 🔗 Diğer Widget'lar

### LoadingWidget
Yükleme animasyonu gösterir.

### ErrorWidget
Hata mesajı gösterir.

### EmptyStateWidget
Boş durum ekranı gösterir.

### CustomAppBar
Özelleştirilmiş app bar widget'ı.

## 📝 Notlar

- Tüm widget'lar BLoC mimarisi ile uyumludur
- Widget'lar stateless/stateful olarak optimize edilmiştir
- Responsive tasarım prensipleri uygulanmıştır
- Performans optimizasyonları yapılmıştır

## 🚀 Geliştirme

Yeni widget eklerken:

1. Bu klasöre widget dosyasını ekleyin
2. README'yi güncelleyin
3. Örnek kullanım ekleyin
4. Testleri yazın
5. Dokümantasyonu tamamlayın

