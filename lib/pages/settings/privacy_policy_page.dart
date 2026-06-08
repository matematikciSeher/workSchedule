import 'package:flutter/material.dart';
import '../../shared/widgets/decorative_background.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const String lastUpdated = '8 Haziran 2026';
  static const String dataController = 'Seher Aydın';
  static const String contactEmail = 'seheraydin4241@gmail.com';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gizlilik Politikası'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: DecorativeBackground(
        style: BackgroundStyle.elegant,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              'Çalışma Takvimi',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Son güncelleme: $lastUpdated',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            const _PolicySection(
              title: 'Giriş',
              content:
                  'Bu Gizlilik Politikası, Çalışma Takvimi mobil uygulamasını kullandığınızda '
                  'kişisel verilerinizin nasıl toplandığını, kullanıldığını, saklandığını ve '
                  'korunduğunu açıklar. Uygulamayı kullanarak bu politikayı kabul etmiş sayılırsınız.',
            ),
            _PolicySection(
              title: 'Veri Sorumlusu',
              bullets: [
                'Veri sorumlusu: $dataController',
                'Uygulama: Çalışma Takvimi',
                'Paket adı: com.Appworkschedule.app',
                'İletişim: $contactEmail',
              ],
            ),
            const _PolicySection(
              title: 'Toplanan Veriler',
              content: 'Uygulama aşağıdaki veri kategorilerini toplayabilir:',
              bullets: [
                'Hesap bilgileri: e-posta, şifre (Firebase tarafından güvenli işlenir), Google profil bilgileri',
                'Görev ve etkinlik verileri: başlık, açıklama, tarihler, öncelik, konum, katılımcılar',
                'Etkinlik ekleri: fotoğraf ve dosyalar',
                'Google Takvim verileri (senkronizasyon etkinse)',
                'Tercihler: tema, bildirim ve senkronizasyon ayarları',
                'Cihaz saat dilimi (hatırlatıcılar için)',
                '“Beni hatırla” seçeneğiyle kaydedilen giriş bilgileri (cihazda yerel)',
              ],
            ),
            const _PolicySection(
              title: 'Verilerin Kullanım Amaçları',
              bullets: [
                'Hesap oluşturma ve kimlik doğrulama',
                'Görev ve etkinlik yönetimi',
                'Hatırlatıcı ve bildirim gönderimi',
                'Bulut senkronizasyonu ve yedekleme',
                'Google Takvim senkronizasyonu',
                'Takvim paylaşımı ve dışa aktarma',
                'AI Asistan ile program bilgisi sunma',
                'Uygulama güvenliği',
              ],
            ),
            const _PolicySection(
              title: 'Hukuki Dayanak (KVKK)',
              content:
                  'Kişisel verileriniz KVKK kapsamında sözleşmenin ifası, meşru menfaat ve '
                  'açık rızanız (Google bağlantısı, bildirim, kamera/galeri izinleri) '
                  'hukuki sebeplerine dayanılarak işlenir.',
            ),
            const _PolicySection(
              title: 'Verilerin Saklanması',
              bullets: [
                'Görev ve etkinlikler cihazınızdaki SQLite veritabanında saklanır',
                'Senkronizasyon etkinse veriler Google Firebase (Firestore) üzerinde saklanır',
                'Ayarlar SharedPreferences ile cihazınızda saklanır',
                'Ekler uygulama belgeler dizininde saklanır',
              ],
              content:
                  'Verileriniz hesabınız aktif olduğu sürece saklanır. Hesap silme talebinde '
                  'yasal yükümlülükler saklı kalmak kaydıyla verileriniz silinir.',
            ),
            const _PolicySection(
              title: 'Üçüncü Taraf Hizmetler',
              bullets: [
                'Google Firebase (kimlik doğrulama ve bulut veritabanı)',
                'Google Sign-In ve Google Takvim API (isteğe bağlı)',
                'Google Fonts (yazı tipleri; IP adresi iletilebilir)',
              ],
              content:
                  'Bu hizmet sağlayıcılar kendi gizlilik politikalarına tabidir.',
            ),
            const _PolicySection(
              title: 'Cihaz İzinleri',
              bullets: [
                'Bildirimler: hatırlatıcılar için',
                'Kamera ve galeri: etkinlik fotoğrafları için',
                'Dosya erişimi: içe/dışa aktarma için',
                'İnternet: bulut senkronizasyonu için',
                'Cihaz yeniden başlatma: hatırlatıcıları yeniden planlamak için',
              ],
              content: 'İzinleri cihaz ayarlarınızdan istediğiniz zaman geri alabilirsiniz.',
            ),
            const _PolicySection(
              title: 'AI Asistan',
              content:
                  'AI Asistan varsayılan olarak yerel modda çalışır; görev ve etkinlik verilerinize '
                  'erişir ancak bunları üçüncü taraflara göndermez. Harici bir yapay zeka API’si '
                  'yapılandırılırsa soru metniniz ilgili sağlayıcıya iletilebilir.',
            ),
            const _PolicySection(
              title: 'Veri Güvenliği',
              content:
                  'Verilerinizi korumak için endüstri standardı güvenlik önlemleri uygulanır. '
                  'Firebase iletişimi şifrelenmiş bağlantılar (HTTPS/TLS) üzerinden gerçekleştirilir.',
            ),
            const _PolicySection(
              title: 'Veri Paylaşımı',
              content:
                  'Kişisel verilerinizi satmayız. Veriler yalnızca hizmet sunumu için gerekli '
                  'sağlayıcılarla, sizin talebinizle (paylaşım/dışa aktarma) veya yasal '
                  'zorunluluk halinde paylaşılabilir.',
            ),
            const _PolicySection(
              title: 'Kullanıcı Haklarınız (KVKK Madde 11)',
              bullets: [
                'Verilerinizin işlenip işlenmediğini öğrenme',
                'İşlenmişse bilgi talep etme',
                'Eksik veya yanlış verilerin düzeltilmesini isteme',
                'Verilerin silinmesini veya yok edilmesini isteme',
                'Otomatik analiz sonuçlarına itiraz etme',
                'Zararın giderilmesini talep etme',
              ],
              content:
                  'Haklarınızı kullanmak için $contactEmail adresine başvurabilirsiniz. '
                  'Talebiniz en geç 30 gün içinde yanıtlanacaktır.',
            ),
            const _PolicySection(
              title: 'Çocukların Gizliliği',
              content:
                  'Uygulama 13 yaşın altındaki çocuklara yönelik değildir. Bilerek bu yaş '
                  'grubundan kişisel veri toplamıyoruz.',
            ),
            const _PolicySection(
              title: 'Uluslararası Veri Aktarımı',
              content:
                  'Firebase ve Google hizmetleri verilerinizi Türkiye dışındaki sunucularda '
                  'işleyebilir. Bu aktarım KVKK’nın 9. maddesi kapsamındaki güvenceler '
                  'çerçevesinde gerçekleşir.',
            ),
            const _PolicySection(
              title: 'Politika Değişiklikleri',
              content:
                  'Bu politika zaman zaman güncellenebilir. Önemli değişikliklerde uygulama '
                  'içi bildirim veya güncellenmiş tarih ile bilgilendirilirsiniz.',
            ),
            _PolicySection(
              title: 'İletişim',
              content:
                  'Gizlilik politikası veya kişisel verileriniz hakkında sorularınız için '
                  'veri sorumlusu $dataController ($contactEmail) adresine yazabilirsiniz.',
            ),
            const SizedBox(height: 16),
            Text(
              '© ${DateTime.now().year} Çalışma Takvimi',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({
    required this.title,
    this.content,
    this.bullets = const [],
  });

  final String title;
  final String? content;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (content != null) ...[
            const SizedBox(height: 8),
            Text(
              content!,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
          if (bullets.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...bullets.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
