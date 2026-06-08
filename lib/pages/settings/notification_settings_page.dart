import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import '../../core/services/notification_service.dart';
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
      print('İzin kontrolü hatası: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    await _notificationService.requestExactAlarmsPermission();
    await _checkPermissionStatus();
    if (!mounted) return;

    if (_hasExactAlarm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kesin alarm izni açık.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kesin alarm izni hâlâ kapalı. Açılan ayar ekranından "Kesin alarmlar"ı etkinleştirin.',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 6),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bildirim izni verildi!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bildirim izni reddedildi. Ayarlardan manuel olarak açabilirsiniz.'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      print('İzin isteği hatası: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openAppSettings() async {
    try {
      if (Platform.isAndroid) {
        // Android ayarlarını aç
        const platform = MethodChannel('app.settings/open');
        try {
          await platform.invokeMethod('openAppSettings');
        } catch (e) {
          // Method channel yoksa bilgi göster
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bildirim İzni'),
        content: const Text(
          'Lütfen cihaz ayarlarından "Work Schedule" uygulamasının bildirim izinlerini açın:\n\n'
          '1. Ayarlar uygulamasını açın\n'
          '2. "Uygulamalar" veya "Apps" seçeneğine gidin\n'
          '3. "Work Schedule" uygulamasını bulun\n'
          '4. "Bildirimler" (Notifications) seçeneğine gidin\n'
          '5. Bildirimleri etkinleştirin',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showExactAlarmHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kesin Alarm İzni'),
        content: const Text(
          'Zamanında hatırlatma için:\n\n'
          'Ayarlar → Uygulamalar → Work Schedule → İzinler → Saat ve Alarm → Kesin alarmlar',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  Widget _buildExactAlarmSection(ThemeData theme) {
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
                      'Kesin alarm izni',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      granted
                          ? 'Hatırlatıcılar zamanında gönderilebilir.'
                          : 'Kapalıysa bildirimler gecikebilir.',
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
                  granted ? 'Açık' : 'Kapalı',
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
                  child: const Text('İzin iste'),
                ),
                TextButton(
                  onPressed: _openAppSettings,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Ayarlara git'),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _showExactAlarmHelp,
                  icon: const Icon(Icons.info_outline, size: 18),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  tooltip: 'Nasıl açılır?',
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirim Ayarları'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: DecorativeBackground(
        style: BackgroundStyle.elegant,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // İzin Durumu Kartı
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
                          'Bildirim İzni',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _hasPermission
                          ? 'Bildirim izni verildi. Görev hatırlatıcıları aktif.'
                          : 'Bildirim izni verilmedi. Görev hatırlatıcıları çalışmayacak.',
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

            // İzin İste Butonu
            if (!_hasPermission)
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _requestPermission,
                icon: const Icon(Icons.notifications_active),
                label: const Text('Bildirim İzni İste'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            
            if (!_hasPermission) const SizedBox(height: 8),

            // Ayarlara Git Butonu
            if (!_hasPermission)
              OutlinedButton.icon(
                onPressed: _openAppSettings,
                icon: const Icon(Icons.settings),
                label: const Text('Ayarlara Git'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

            if (_hasPermission) const SizedBox(height: 16),

            // Yenile Butonu
            if (_hasPermission)
              OutlinedButton.icon(
                onPressed: _checkPermissionStatus,
                icon: const Icon(Icons.refresh),
                label: const Text('Durumu Yenile'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            // Bekleyen bildirimler
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zamanlanmış Bildirimler',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Görev bildirimleri 1 saat ve 30 dakika önce gelir; vade anında durum bildirilir.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    if (_pendingNotifications.isEmpty)
                      Text(
                        'Bekleyen bildirim yok. Tarih ve saatli görev ekleyin.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      )
                    else
                      ..._pendingNotifications.take(8).map(
                        (n) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '• ${n.title ?? 'Bildirim'} — ${n.body ?? ''}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _checkPermissionStatus,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Listeyi Yenile'),
                    ),
                  ],
                ),
              ),
            ),

            if (Platform.isAndroid) ...[
              const SizedBox(height: 12),
              _buildExactAlarmSection(theme),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Bilgi Kartı
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
                          'Bilgi',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Görev bildirimleri görev saatinden 1 saat ve 30 dakika önce gelir.\n'
                      '  Örnek: Görev 15:00 → 14:00 ve 14:30\n\n'
                      '• Vade anında tamamlanma durumu renkli bildirimle gösterilir.\n'
                      '  Yeşil: tamamlandı, Kırmızı: tamamlanmadı\n\n'
                      '• Bildirime dokunmak veya Ertele tuşu görevi 30 dk erteler.\n'
                      '  Yeni saat takvimde otomatik güncellenir.\n\n'
                      '• Saat seçilmezse görev 09:00 varsayılır.\n\n'
                      '• Bildirim izni + Kesin alarmlar izni birlikte açık olmalıdır.',
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

