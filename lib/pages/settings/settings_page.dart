import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/decorative_background.dart';
import 'about_page.dart';
import 'notification_settings_page.dart';
import 'privacy_policy_page.dart';
import 'widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
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
              title: l10n.sectionGeneral,
              children: [
                SettingsTile(
                  icon: Icons.cloud_sync_rounded,
                  iconColor: theme.colorScheme.primary,
                  title: l10n.syncSettings,
                  subtitle: l10n.syncSettingsSubtitle,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.syncSettings);
                  },
                ),
                SettingsTile(
                  icon: Icons.widgets_outlined,
                  iconColor: theme.colorScheme.secondary,
                  title: l10n.widgetPreview,
                  subtitle: l10n.widgetPreviewSubtitle,
                  showDivider: false,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.widgetPreview);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              title: l10n.sectionPersonalization,
              children: [
                SettingsTile(
                  icon: Icons.notifications_active_outlined,
                  iconColor: theme.colorScheme.tertiary,
                  title: l10n.notifications,
                  subtitle: l10n.notificationsSubtitle,
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
                  title: l10n.themeAndFont,
                  subtitle: l10n.themeAndFontSubtitle,
                  showDivider: false,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.themeSettings);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              title: l10n.sectionApp,
              children: [
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: const Color(0xFF2E7D32),
                  title: l10n.privacyPolicy,
                  subtitle: l10n.privacyPolicySubtitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: theme.colorScheme.primary,
                  title: l10n.about,
                  subtitle: l10n.aboutSubtitle,
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
    final l10n = AppLocalizations.of(context)!;

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
                  l10n.managePreferences,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsHeaderSubtitle,
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
