import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import '../../core/services/notification_service.dart';
import '../../core/services/test_notification_helper.dart';
import '../../shared/widgets/decorative_background.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final NotificationService _notificationService = NotificationService();
  final TestNotificationHelper _testHelper = TestNotificationHelper();
  bool _hasPermission = false;
  bool _isLoading = true;
  bool _isTestingNotification = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    setState(() => _isLoading = true);
    try {
      final hasPermission = await _notificationService.hasPermission();
      setState(() {
        _hasPermission = hasPermission;
        _isLoading = false;
      });
    } catch (e) {
      print('İzin kontrolü hatası: $e');
      setState(() => _isLoading = false);
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

  Future<void> _sendTestNotification() async {
    setState(() => _isTestingNotification = true);
    try {
      // Önce izin durumunu kontrol et
      final hasPermission = await _notificationService.hasPermission();
      print('🔍 Bildirim izni durumu: $hasPermission');
      
      await _testHelper.sendTestNotificationIn1Minute();
      
      // Bekleyen bildirimleri kontrol et
      final pending = await _notificationService.getPendingNotifications();
      print('📋 Bekleyen bildirim sayısı: ${pending.length}');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test bildirimi zamanlandı! 1 dakika sonra gelecek.\nBekleyen bildirim: ${pending.length}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Kesin Alarm İzni Gerekli'),
              content: Text(
                'Test bildirimi göndermek için "Kesin alarmlar" izni gereklidir.\n\n'
                '${e.details ?? ''}\n\n'
                'Lütfen ayarlardan bu izni açın.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tamam'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSettingsInfo();
                  },
                  child: const Text('Ayarlara Git'),
                ),
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Test bildirimi hatası: ${e.message ?? e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test bildirimi hatası: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isTestingNotification = false);
    }
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

            // Test Bildirimi Bölümü
            Text(
              'Test',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Bildirimi Gönder',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '1 dakika sonra bir test bildirimi göndererek bildirimlerin çalışıp çalışmadığını kontrol edin.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _hasPermission && !_isTestingNotification
                          ? _sendTestNotification
                          : null,
                      icon: _isTestingNotification
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isTestingNotification ? 'Gönderiliyor...' : 'Test Bildirimi Gönder (1 dk)'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _hasPermission && !_isTestingNotification
                          ? () async {
                              setState(() => _isTestingNotification = true);
                              try {
                                await _notificationService.sendImmediateTestNotification();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Anında test bildirimi gönderildi! Kontrol edin.'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Test bildirimi hatası: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                setState(() => _isTestingNotification = false);
                              }
                            }
                          : null,
                      icon: const Icon(Icons.notifications_active, size: 16),
                      label: const Text('Anında Test Bildirimi Gönder'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            // Exact Alarm Uyarısı (Android 12+)
            if (Platform.isAndroid)
              Card(
                color: theme.colorScheme.errorContainer.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_outlined,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Kesin Alarm İzni (Android 12+)',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hassas zamanlanmış bildirimler için ek bir izin gereklidir:\n\n'
                        '1. Ayarlar > Uygulamalar > Work Schedule\n'
                        '2. İzinler > Saat ve Alarm\n'
                        '3. "Kesin alarmlar" (Exact alarms) seçeneğini açın\n\n'
                        'Bu izin olmadan bildirimler zamanında gelmeyebilir.',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Kesin Alarm İzni'),
                                    content: const Text(
                                      'Bu izni açmak için:\n\n'
                                      '1. Ayarlar uygulamasını açın\n'
                                      '2. "Uygulamalar" veya "Apps" seçeneğine gidin\n'
                                      '3. "Work Schedule" uygulamasını bulun\n'
                                      '4. "İzinler" (Permissions) seçeneğine gidin\n'
                                      '5. "Saat ve Alarm" (Alarms & reminders) seçeneğine gidin\n'
                                      '6. "Kesin alarmlar" (Exact alarms) seçeneğini açın\n\n'
                                      '⚠️ Bu izin olmadan bildirimler zamanında gelmeyebilir veya hiç gelmeyebilir!',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Tamam'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.help_outline, size: 16),
                              label: const Text('Nasıl Açılır?'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.error,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _openAppSettings();
                              },
                              icon: const Icon(Icons.settings, size: 16),
                              label: const Text('Ayarlara Git'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                foregroundColor: theme.colorScheme.onError,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

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
                      '• Bildirim izni, görev hatırlatıcılarının çalışması için gereklidir.\n\n'
                      '• Android 13 ve üzeri için bildirim izni gereklidir.\n\n'
                      '• Android 12+ için ek olarak "Kesin alarmlar" izni gereklidir.\n\n'
                      '• İzin verilmediyse, cihaz ayarlarından manuel olarak açabilirsiniz.',
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

