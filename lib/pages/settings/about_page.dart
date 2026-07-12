import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/decorative_background.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
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
              l10n.appName,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.versionLabel(appVersion),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.aboutDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Text(
              l10n.features,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _FeatureTile(
              icon: Icons.task_alt,
              title: l10n.featureTaskManagement,
              subtitle: l10n.featureTaskManagementSubtitle,
            ),
            _FeatureTile(
              icon: Icons.event,
              title: l10n.featureEventCalendar,
              subtitle: l10n.featureEventCalendarSubtitle,
            ),
            _FeatureTile(
              icon: Icons.notifications_active,
              title: l10n.featureReminders,
              subtitle: l10n.featureRemindersSubtitle,
            ),
            _FeatureTile(
              icon: Icons.cloud_sync,
              title: l10n.featureCloudSync,
              subtitle: l10n.featureCloudSyncSubtitle,
            ),
            _FeatureTile(
              icon: Icons.smart_toy_outlined,
              title: l10n.aiAssistant,
              subtitle: l10n.featureAiAssistantSubtitle,
            ),
            _FeatureTile(
              icon: Icons.palette_outlined,
              title: l10n.featurePersonalization,
              subtitle: l10n.featurePersonalizationSubtitle,
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
                          l10n.developerNote,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.developerNoteBody,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.copyright(DateTime.now().year, l10n.appName),
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
