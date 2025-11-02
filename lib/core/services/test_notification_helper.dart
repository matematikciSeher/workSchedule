import 'package:flutter/services.dart';
import 'notification_service.dart';

/// Test için bildirim yardımcı sınıfı
class TestNotificationHelper {
  final NotificationService _notificationService = NotificationService();

  /// Hemen bir test bildirimi gönder (1 saniye sonra)
  Future<void> sendTestNotificationNow() async {
    final now = DateTime.now();
    final testDate = now.add(const Duration(seconds: 1));
    
    print('🧪 Test bildirimi gönderiliyor - 1 saniye sonra');
    
    try {
      await _notificationService.scheduleEventNotification(
        id: 999999,
        title: 'Test Bildirimi',
        body: 'Bu bir test bildirimidir. Eğer bunu görüyorsanız bildirimler çalışıyor!',
        scheduledDate: testDate,
        payload: 'test',
      );
      print('✅ Test bildirimi zamanlandı!');
    } catch (e) {
      print('❌ Test bildirimi hatası: $e');
      rethrow;
    }
  }

  /// 1 dakika sonra test bildirimi gönder
  Future<void> sendTestNotificationIn1Minute() async {
    final now = DateTime.now();
    final testDate = now.add(const Duration(minutes: 1));
    
    print('🧪 Test bildirimi gönderiliyor - 1 dakika sonra: $testDate');
    
    try {
      await _notificationService.scheduleEventNotification(
        id: 999998,
        title: 'Test Bildirimi (1 Dakika)',
        body: 'Bu 1 dakika sonra gelen bir test bildirimidir.',
        scheduledDate: testDate,
        payload: 'test_1min',
      );
      print('✅ Test bildirimi zamanlandı! 1 dakika sonra gelecek.');
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        print('❌ Test bildirimi hatası: Exact alarm izni gerekli');
        print('Kullanıcıya bilgi veriliyor...');
        // Hata mesajını rethrow et ki UI'da gösterilebilsin
        rethrow;
      } else {
        print('❌ Test bildirimi hatası: $e');
        rethrow;
      }
    } catch (e) {
      print('❌ Test bildirimi hatası: $e');
      rethrow;
    }
  }
}

