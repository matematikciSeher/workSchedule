import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/widgets/decorative_background.dart';
import 'about_page.dart';
import 'notification_settings_page.dart';
import 'widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: DecorativeBackground(
        style: BackgroundStyle.elegant,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _SettingsHeader(theme: theme),
            const SizedBox(height: 28),
            SettingsSection(
              title: 'Genel',
              children: [
                SettingsTile(
                  icon: Icons.cloud_sync_rounded,
                  iconColor: theme.colorScheme.primary,
                  title: 'Senkronizasyon Ayarları',
                  subtitle: 'Bulut senkronizasyon ve yedekleme',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.syncSettings);
                  },
                ),
                SettingsTile(
                  icon: Icons.widgets_outlined,
                  iconColor: theme.colorScheme.secondary,
                  title: 'Widget Önizleme',
                  subtitle: 'Ana ekran widget\'ını önizle',
                  showDivider: false,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.widgetPreview);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              title: 'Kişiselleştirme',
              children: [
                SettingsTile(
                  icon: Icons.notifications_active_outlined,
                  iconColor: theme.colorScheme.tertiary,
                  title: 'Bildirimler',
                  subtitle: 'Bildirim izinleri ve ayarları',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingsPage(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.palette_outlined,
                  iconColor: const Color(0xFF9C27B0),
                  title: 'Tema ve Yazı Tipi',
                  subtitle: 'Tema renkleri ve yazı tipi boyutu',
                  showDivider: false,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.themeSettings);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              title: 'Uygulama',
              children: [
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: theme.colorScheme.primary,
                  title: 'Hakkında',
                  subtitle: 'Uygulama bilgileri ve sürüm',
                  showDivider: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.55),
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tercihlerinizi Yönetin',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Senkronizasyon, bildirimler ve görünüm ayarlarını buradan düzenleyin.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
