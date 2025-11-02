import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:io' show Platform;

/// Bildirim servisi - Yerel bildirimleri yönetir
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _permissionGranted = false;

  /// Bildirim servisini başlat
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Timezone verilerini yükle
      tz.initializeTimeZones();

      // Cihazın zaman dilimini al ve ayarla
      try {
        final String timeZoneName =
            await FlutterNativeTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      } catch (e) {
        // Varsayılan olarak UTC kullan
        tz.setLocalLocation(tz.getLocation('UTC'));
      }

      // Android ayarları
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS ayarları
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final bool? initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == true) {
        _initialized = true;
        
        // Android 13+ için bildirim iznini kontrol et ve iste
        if (Platform.isAndroid) {
          await _requestAndroidNotificationPermission();
        }
      } else {
        throw Exception('Bildirim servisi başlatılamadı');
      }
    } catch (e) {
      // Hata olsa bile devam et, ama logla
      print('Bildirim servisi başlatma hatası: $e');
      _initialized = false;
    }
  }

  /// Android 13+ için bildirim izni iste
  Future<void> _requestAndroidNotificationPermission() async {
    try {
      // Android 13+ için POST_NOTIFICATIONS izni gerekli
      // flutter_local_notifications paketi bu izni otomatik olarak ister
      // Ama manuel kontrol için AndroidNotificationPermission kullanılabilir
      
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _notifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        if (androidImplementation != null) {
          final bool? granted = await androidImplementation
              .requestNotificationsPermission();
          _permissionGranted = granted ?? false;
        }
      }
    } catch (e) {
      print('Bildirim izni hatası: $e');
      _permissionGranted = false;
    }
  }

  /// Bildirim izni verildi mi kontrol et
  Future<bool> hasPermission() async {
    if (!_initialized) await initialize();
    
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? granted = await androidImplementation
            .areNotificationsEnabled();
        return granted ?? false;
      }
    }
    return _permissionGranted;
  }

  /// Android notification plugin'e erişim (public)
  AndroidFlutterLocalNotificationsPlugin? 
      resolvePlatformSpecificImplementation() {
    return _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
  }

  /// Bildirime tıklandığında çağrılır
  void _onNotificationTapped(NotificationResponse response) {
    // Bildirime tıklandığında yapılacak işlemler
    // (örneğin, etkinlik detay sayfasına yönlendirme)
  }

  /// Tek seferlik bildirim zamanla
  Future<void> scheduleEventNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    // Geçmiş bir tarihse bildirim gönderme
    // Ama 5 dakika tolerans ver (kullanıcı kaydetme sırasında birkaç saniye geçebilir)
    final now = DateTime.now();
    final difference = scheduledDate.difference(now);
    if (difference.isNegative && difference.inMinutes.abs() > 5) {
      print('⚠️ Bildirim atlandı: Geçmiş tarih (5 dakikadan fazla). Şimdi: $now, Bildirim: $scheduledDate');
      return;
    }
    
    // Eğer geçmiş ama 5 dakikadan azsa, hemen bildirim gönder (veya 1 dakika sonra)
    DateTime finalScheduledDate = scheduledDate;
    if (scheduledDate.isBefore(now)) {
      print('ℹ️ Bildirim tarihi geçmiş ama 5 dakikadan az, 10 saniye sonra gönderiliyor');
      finalScheduledDate = now.add(const Duration(seconds: 10));
    }

    try {
      // Android'de bildirim iznini kontrol et
      if (Platform.isAndroid) {
        final hasPermission = await this.hasPermission();
        if (!hasPermission) {
          print('Bildirim izni verilmemiş, izin isteniyor...');
          await _requestAndroidNotificationPermission();
          // Tekrar kontrol et
          final hasPermissionAfterRequest = await this.hasPermission();
          if (!hasPermissionAfterRequest) {
            print('Bildirim izni reddedildi, bildirim zamanlanamadı');
            return;
          }
        }
      }

      final androidDetails = AndroidNotificationDetails(
        'event_reminders',
        'Hatırlatıcı Bildirimleri',
        channelDescription: 'Etkinlikler ve görevler için hatırlatıcı bildirimleri',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        channelShowBadge: true,
        styleInformation: BigTextStyleInformation(body),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // finalScheduledDate kullan (geçmiş tarih kontrolü yapılmış)
      DateTime dateToSchedule = finalScheduledDate;
      final tzScheduledDate = tz.TZDateTime.from(dateToSchedule, tz.local);
      final tzNow = tz.TZDateTime.now(tz.local);
      final timeUntilNotification = tzScheduledDate.difference(tzNow);
      
      print('📅 Bildirim zamanlanıyor:');
      print('   ID: $id');
      print('   Başlık: $title');
      print('   İçerik: $body');
      print('   Yerel Zaman: $tzNow');
      print('   Zamanlanan Tarih: $tzScheduledDate');
      print('   Kalan Süre: ${timeUntilNotification.inSeconds} saniye (${timeUntilNotification.inMinutes} dakika)');
      
      try {
        // Android 12+ için exact alarm iznini kontrol et
        bool canScheduleExactAlarms = true;
        if (Platform.isAndroid) {
          try {
            final androidImplementation = resolvePlatformSpecificImplementation();
            if (androidImplementation != null) {
              // Android 12+ (API 31+) için canScheduleExactAlarms kontrolü
              canScheduleExactAlarms = await androidImplementation.canScheduleExactNotifications() ?? false;
              print('📋 Exact alarm izni durumu: $canScheduleExactAlarms');
            }
          } catch (e) {
            print('⚠️ Exact alarm izni kontrolü yapılamadı: $e');
            canScheduleExactAlarms = false;
          }
        }
        
        // Exact alarm izni varsa androidAllowWhileIdle: true kullan (daha güvenilir)
        // Yoksa androidAllowWhileIdle: false kullan
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDate,
          notificationDetails,
          payload: payload,
          androidAllowWhileIdle: canScheduleExactAlarms, // İzin varsa true, yoksa false
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } on PlatformException catch (e) {
        // Android 12+ için SCHEDULE_EXACT_ALARM izni gerekli
        if (e.code == 'exact_alarms_not_permitted') {
          print('⚠️ Exact alarm izni verilmemiş!');
          print('Android 12+ için SCHEDULE_EXACT_ALARM izni gerekli.');
          print('Kullanıcıyı ayarlara yönlendirin:');
          print('Ayarlar > Uygulamalar > Work Schedule > İzinler > Saat ve Alarm > Kesin alarmlar');
          
          // İzin yoksa androidAllowWhileIdle: false ile tekrar dene
          print('🔄 androidAllowWhileIdle: false ile tekrar deneniyor...');
          try {
            await _notifications.zonedSchedule(
              id,
              title,
              body,
              tzScheduledDate,
              notificationDetails,
              payload: payload,
              androidAllowWhileIdle: false,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
            print('✅ Bildirim androidAllowWhileIdle: false ile zamanlandı');
          } catch (e2) {
            print('❌ Alternatif yöntem de başarısız: $e2');
            throw PlatformException(
              code: 'exact_alarms_not_permitted',
              message: 'Exact alarm izni gerekli. Lütfen ayarlardan açın.',
              details: 'Ayarlar > Uygulamalar > Work Schedule > İzinler > Saat ve Alarm > Kesin alarmlar',
            );
          }
        } else {
          rethrow;
        }
      }
      
      print('✅ Bildirim başarıyla zamanlandı - ID: $id');
      
      // Test için: Bekleyen bildirimleri kontrol et
      try {
        final pendingNotifications = await _notifications.pendingNotificationRequests();
        print('📋 Toplam bekleyen bildirim sayısı: ${pendingNotifications.length}');
        if (pendingNotifications.isNotEmpty) {
          for (final notification in pendingNotifications.take(10)) {
            print('   - ID: ${notification.id}, Başlık: ${notification.title ?? "N/A"}');
            if (notification.body != null) {
              print('     İçerik: ${notification.body}');
            }
          }
        } else {
          print('   ⚠️ Bekleyen bildirim yok!');
        }
      } catch (e) {
        print('⚠️ Bekleyen bildirimler kontrol edilemedi: $e');
      }
      
      // Bildirim ID'sini logla (hata durumunda bulmak için)
      print('🔔 Bildirim ID: $id');
    } catch (e) {
      print('Bildirim zamanlama hatası: $e');
      print('Hata detayı - ID: $id, Tarih: $scheduledDate, Zaman dilimi: ${tz.local.name}');
      // Hata olsa bile uygulama çalışmaya devam etmeli
      rethrow;
    }
  }

  /// Tekrar eden bildirim zamanla
  /// Not: flutter_local_notifications paketi tekrar eden bildirimleri doğrudan desteklemediği için,
  /// belirli bir süre için (örn. 1 yıl) tekrar eden bildirimleri manuel olarak zamanlıyoruz
  Future<void> scheduleRecurringEventNotification({
    required int id,
    required String title,
    required String body,
    required DateTime firstDate,
    required RecurringPattern pattern,
    String? payload,
    int maxRecurrences = 365, // Maksimum tekrar sayısı (günlük için 1 yıl)
  }) async {
    if (!_initialized) await initialize();

    // İlk bildirimi zamanla
    await scheduleEventNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: firstDate,
      payload: payload,
    );

    // Tekrar eden bildirimleri zamanla
    List<DateTime> nextDates = [];

    if (pattern == RecurringPattern.daily) {
      // Günlük tekrar için her gün aynı saatte bildirim gönder
      nextDates = _generateDailyRecurrences(firstDate, maxRecurrences);
    } else if (pattern == RecurringPattern.weekly) {
      // Haftalık tekrar için her hafta aynı gün ve saatte bildirim gönder
      nextDates =
          _generateWeeklyRecurrences(firstDate, (maxRecurrences / 7).ceil());
    } else if (pattern == RecurringPattern.monthly) {
      // Aylık tekrar için her ay aynı gün ve saatte bildirim gönder
      nextDates =
          _generateMonthlyRecurrences(firstDate, (maxRecurrences / 30).ceil());
    }

    // Sadece gelecek tarihleri zamanla
    final now = DateTime.now();
    int index = 1;
    for (final date in nextDates) {
      if (date.isAfter(now)) {
        await scheduleEventNotification(
          id: id + index,
          title: title,
          body: body,
          scheduledDate: date,
          payload: payload,
        );
        index++;
      }
    }
  }

  /// Günlük tekrarlar için tarihler oluştur
  List<DateTime> _generateDailyRecurrences(DateTime startDate, int count) {
    final dates = <DateTime>[];
    for (int i = 1; i <= count; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  /// Haftalık tekrarlar için tarihler oluştur
  List<DateTime> _generateWeeklyRecurrences(DateTime startDate, int count) {
    final dates = <DateTime>[];
    for (int i = 1; i <= count; i++) {
      dates.add(startDate.add(Duration(days: i * 7)));
    }
    return dates;
  }

  /// Aylık tekrarlar için tarihler oluştur
  List<DateTime> _generateMonthlyRecurrences(DateTime startDate, int count) {
    final dates = <DateTime>[];
    DateTime currentDate = startDate;
    for (int i = 0; i < count; i++) {
      // Bir sonraki ayın aynı gününü hesapla
      int nextMonth = currentDate.month + 1;
      int nextYear = currentDate.year;
      if (nextMonth > 12) {
        nextMonth = 1;
        nextYear++;
      }

      // Ayın son gününü kontrol et (örneğin 31 Ocak -> 28/29 Şubat)
      int day = currentDate.day;
      final daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
      if (day > daysInNextMonth) {
        day = daysInNextMonth;
      }

      currentDate = DateTime(
        nextYear,
        nextMonth,
        day,
        currentDate.hour,
        currentDate.minute,
      );
      dates.add(currentDate);
    }
    return dates;
  }

  /// Bildirimi iptal et
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Belirli bir etkinliğe ait tüm bildirimleri iptal et
  Future<void> cancelEventNotifications(String eventId) async {
    // Event ID'sine göre bildirim ID'lerini hesapla
    // Basit bir hash fonksiyonu kullanıyoruz
    final baseId = eventId.hashCode.abs() % 100000;

    // Tekrar eden bildirimler için maksimum 1000 ID iptal et
    for (int i = 0; i < 1000; i++) {
      await _notifications.cancel(baseId + i);
    }
  }

  /// Tüm bildirimleri iptal et
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Bekleyen bildirimleri getir
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_initialized) await initialize();
    return await _notifications.pendingNotificationRequests();
  }

  /// Bildirim zamanlamasını test et (hemen gönder)
  Future<void> sendImmediateTestNotification() async {
    if (!_initialized) await initialize();
    
    const androidDetails = AndroidNotificationDetails(
      'event_reminders',
      'Hatırlatıcı Bildirimleri',
      channelDescription: 'Etkinlikler ve görevler için hatırlatıcı bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        999997,
        'Test Bildirimi',
        'Eğer bunu görüyorsanız bildirimler çalışıyor!',
        notificationDetails,
      );
      print('✅ Anında test bildirimi gönderildi');
    } catch (e) {
      print('❌ Anında test bildirimi hatası: $e');
      rethrow;
    }
  }
}

/// Tekrar eden hatırlatma desenleri
enum RecurringPattern {
  none, // Tek seferlik
  daily, // Günlük
  weekly, // Haftalık
  monthly, // Aylık
}
