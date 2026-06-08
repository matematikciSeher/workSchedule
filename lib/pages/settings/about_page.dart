import 'package:flutter/material.dart';
import '../../shared/widgets/decorative_background.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String appName = 'Çalışma Takvimi';
  static const String appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkında'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: DecorativeBackground(
        style: BackgroundStyle.elegant,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 52,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              appName,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sürüm $appVersion',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Görevlerinizi ve etkinliklerinizi tek bir yerden yönetmenizi sağlayan akıllı takvim uygulaması. '
              'Günlük planlamadan haftalık görünüme, hatırlatıcılardan bulut senkronizasyonuna kadar '
              'ihtiyacınız olan tüm araçlar elinizin altında.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Text(
              'Özellikler',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _FeatureTile(
              icon: Icons.task_alt,
              title: 'Görev Yönetimi',
              subtitle: 'Görev oluşturun, düzenleyin ve takip edin',
            ),
            _FeatureTile(
              icon: Icons.event,
              title: 'Etkinlik Takvimi',
              subtitle: 'Gün, hafta, ay ve yıl görünümleri',
            ),
            _FeatureTile(
              icon: Icons.notifications_active,
              title: 'Hatırlatıcılar',
              subtitle: 'Zamanında bildirimler alın',
            ),
            _FeatureTile(
              icon: Icons.cloud_sync,
              title: 'Bulut Senkronizasyonu',
              subtitle: 'Verilerinizi güvenle yedekleyin ve senkronize edin',
            ),
            _FeatureTile(
              icon: Icons.smart_toy_outlined,
              title: 'AI Asistan',
              subtitle: 'Programınız hakkında sorular sorun',
            ),
            _FeatureTile(
              icon: Icons.palette_outlined,
              title: 'Kişiselleştirme',
              subtitle: 'Tema renkleri ve yazı tipi boyutu',
            ),
            const SizedBox(height: 32),
            Card(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Geliştirici Notu',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bu uygulama Flutter ile geliştirilmiştir. '
                      'Geri bildirimleriniz ve önerileriniz bizim için değerlidir.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '© ${DateTime.now().year} $appName',
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

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
