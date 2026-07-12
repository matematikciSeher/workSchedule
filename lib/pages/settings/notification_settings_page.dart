import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import '../../core/services/notification_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/decorative_background.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final NotificationService _notificationService = NotificationService();
  bool _hasPermission = false;
  bool _hasExactAlarm = false;
  bool _isLoading = true;
  List<PendingNotificationRequest> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    setState(() => _isLoading = true);
    try {
      final hasPermission = await _notificationService.hasPermission();
      final hasExactAlarm = await _notificationService.canScheduleExactAlarms();
      final pending = await _notificationService.getPendingNotifications();
      setState(() {
        _hasPermission = hasPermission;
        _hasExactAlarm = hasExactAlarm;
        _pendingNotifications = pending;
        _isLoading = false;
      });
    } catch (e) {
      print('Permission check error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    await _notificationService.requestExactAlarmsPermission();
    await _checkPermissionStatus();
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    if (_hasExactAlarm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.exactAlarmEnabledMsg),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.exactAlarmStillDisabledMsg),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  Future<void> _requestPermission() async {
    setState(() => _isLoading = true);
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationService
            .resolvePlatformSpecificImplementation();

        if (androidImplementation != null) {
          final bool? granted = await androidImplementation
              .requestNotificationsPermission();
          
          setState(() {
            _hasPermission = granted ?? false;
            _isLoading = false;
          });

          if (granted == true) {
            if (mounted) {
              final l10n = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.notificationPermissionGranted),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            if (mounted) {
              final l10n = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.notificationPermissionDenied),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      print('Permission request error: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorWithMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openAppSettings() async {
    try {
      if (Platform.isAndroid) {
        const platform = MethodChannel('app.settings/open');
        try {
          await platform.invokeMethod('openAppSettings');
        } catch (e) {
          if (mounted) {
            _showSettingsInfo();
          }
        }
      } else {
        _showSettingsInfo();
      }
    } catch (e) {
      _showSettingsInfo();
    }
  }

  void _showSettingsInfo() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.notificationPermissionDialogTitle),
        content: Text(l10n.notificationPermissionInstructions),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showExactAlarmHelp() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exactAlarmPermissionTitle),
        content: Text(l10n.exactAlarmInstructions),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildExactAlarmSection(ThemeData theme, AppLocalizations l10n) {
    final granted = _hasExactAlarm;
    final accent = granted
        ? theme.colorScheme.primary
        : theme.colorScheme.tertiary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: granted ? 0.35 : 0.5),
        ),
        color: accent.withValues(alpha: 0.08),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.alarm_on_outlined, size: 18, color: accent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.exactAlarmPermissionLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      granted
                          ? l10n.exactAlarmEnabledHint
                          : l10n.exactAlarmDisabledHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: granted
                      ? theme.colorScheme.primary.withValues(alpha: 0.15)
                      : theme.colorScheme.tertiary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  granted ? l10n.statusOn : l10n.statusOff,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (!granted) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: _requestExactAlarmPermission,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(l10n.requestPermission),
                ),
                TextButton(
                  onPressed: _openAppSettings,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(l10n.goToSettings),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _showExactAlarmHelp,
                  icon: const Icon(Icons.info_outline, size: 18),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  tooltip: l10n.howToEnable,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationSettings),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: DecorativeBackground(
        style: BackgroundStyle.elegant,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _hasPermission ? Icons.check_circle : Icons.error,
                          color: _hasPermission ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.notificationPermissionDialogTitle,
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _hasPermission
                          ? l10n.notificationGrantedActive
                          : l10n.notificationDeniedInactive,
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (!_hasPermission)
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _requestPermission,
                icon: const Icon(Icons.notifications_active),
                label: Text(l10n.requestNotificationPermission),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            
            if (!_hasPermission) const SizedBox(height: 8),

            if (!_hasPermission)
              OutlinedButton.icon(
                onPressed: _openAppSettings,
                icon: const Icon(Icons.settings),
                label: Text(l10n.goToSettings),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

            if (_hasPermission) const SizedBox(height: 16),

            if (_hasPermission)
              OutlinedButton.icon(
                onPressed: _checkPermissionStatus,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.refreshStatus),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.scheduledNotifications,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.scheduledNotificationsDesc,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    if (_pendingNotifications.isEmpty)
                      Text(
                        l10n.noPendingNotifications,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      )
                    else
                      ..._pendingNotifications.take(8).map(
                        (n) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '• ${n.title ?? l10n.notificationDefaultTitle} — ${n.body ?? ''}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _checkPermissionStatus,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text(l10n.refreshList),
                    ),
                  ],
                ),
              ),
            ),

            if (Platform.isAndroid) ...[
              const SizedBox(height: 12),
              _buildExactAlarmSection(theme, l10n),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            Card(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.infoTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.notificationInfoBlock,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
