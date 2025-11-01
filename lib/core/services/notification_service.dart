import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

/// Bildirim servisi - Yerel bildirimleri yönetir
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Bildirim servisini başlat
  Future<void> initialize() async {
    if (_initialized) return;

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

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
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
    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'event_reminders',
      'Etkinlik Hatırlatıcıları',
      channelDescription: 'Etkinlikler için hatırlatıcı bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
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

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
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
    return await _notifications.pendingNotificationRequests();
  }
}

/// Tekrar eden hatırlatma desenleri
enum RecurringPattern {
  none, // Tek seferlik
  daily, // Günlük
  weekly, // Haftalık
  monthly, // Aylık
}
