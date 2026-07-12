import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/decorative_background.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const String dataController = 'Seher Aydın';
  static const String contactEmail = 'seheraydin4241@gmail.com';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: DecorativeBackground(
        style: BackgroundStyle.elegant,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              l10n.appName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.lastUpdatedLabel(l10n.privacyLastUpdatedDate),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            _PolicySection(
              title: l10n.privacyIntroTitle,
              content: l10n.privacyIntroBody,
            ),
            _PolicySection(
              title: l10n.privacyDataControllerTitle,
              bullets: [
                l10n.privacyDataControllerBullet1(dataController),
                l10n.privacyDataControllerBullet2,
                l10n.privacyDataControllerBullet3,
                l10n.privacyDataControllerBullet4(contactEmail),
              ],
            ),
            _PolicySection(
              title: l10n.privacyDataCollectedTitle,
              content: l10n.privacyDataCollectedIntro,
              bullets: [
                l10n.privacyDataCollectedBullet1,
                l10n.privacyDataCollectedBullet2,
                l10n.privacyDataCollectedBullet3,
                l10n.privacyDataCollectedBullet4,
                l10n.privacyDataCollectedBullet5,
                l10n.privacyDataCollectedBullet6,
                l10n.privacyDataCollectedBullet7,
              ],
            ),
            _PolicySection(
              title: l10n.privacyDataUseTitle,
              bullets: [
                l10n.privacyDataUseBullet1,
                l10n.privacyDataUseBullet2,
                l10n.privacyDataUseBullet3,
                l10n.privacyDataUseBullet4,
                l10n.privacyDataUseBullet5,
                l10n.privacyDataUseBullet6,
                l10n.privacyDataUseBullet7,
                l10n.privacyDataUseBullet8,
              ],
            ),
            _PolicySection(
              title: l10n.privacyLegalBasisTitle,
              content: l10n.privacyLegalBasisBody,
            ),
            _PolicySection(
              title: l10n.privacyStorageTitle,
              bullets: [
                l10n.privacyStorageBullet1,
                l10n.privacyStorageBullet2,
                l10n.privacyStorageBullet3,
                l10n.privacyStorageBullet4,
              ],
              content: l10n.privacyStorageBody,
            ),
            _PolicySection(
              title: l10n.privacyThirdPartyTitle,
              bullets: [
                l10n.privacyThirdPartyBullet1,
                l10n.privacyThirdPartyBullet2,
                l10n.privacyThirdPartyBullet3,
              ],
              content: l10n.privacyThirdPartyBody,
            ),
            _PolicySection(
              title: l10n.privacyPermissionsTitle,
              bullets: [
                l10n.privacyPermissionsBullet1,
                l10n.privacyPermissionsBullet2,
                l10n.privacyPermissionsBullet3,
                l10n.privacyPermissionsBullet4,
                l10n.privacyPermissionsBullet5,
              ],
              content: l10n.privacyPermissionsBody,
            ),
            _PolicySection(
              title: l10n.privacyAiTitle,
              content: l10n.privacyAiBody,
            ),
            _PolicySection(
              title: l10n.privacySecurityTitle,
              content: l10n.privacySecurityBody,
            ),
            _PolicySection(
              title: l10n.privacySharingTitle,
              content: l10n.privacySharingBody,
            ),
            _PolicySection(
              title: l10n.privacyRightsTitle,
              bullets: [
                l10n.privacyRightsBullet1,
                l10n.privacyRightsBullet2,
                l10n.privacyRightsBullet3,
                l10n.privacyRightsBullet4,
                l10n.privacyRightsBullet5,
                l10n.privacyRightsBullet6,
              ],
              content: l10n.privacyRightsBody(contactEmail),
            ),
            _PolicySection(
              title: l10n.privacyChildrenTitle,
              content: l10n.privacyChildrenBody,
            ),
            _PolicySection(
              title: l10n.privacyTransferTitle,
              content: l10n.privacyTransferBody,
            ),
            _PolicySection(
              title: l10n.privacyChangesTitle,
              content: l10n.privacyChangesBody,
            ),
            _PolicySection(
              title: l10n.privacyContactTitle,
              content: l10n.privacyContactBody(dataController, contactEmail),
            ),
            const SizedBox(height: 16),
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
