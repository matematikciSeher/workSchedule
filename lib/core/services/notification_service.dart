import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io' show Platform;
import '../../domain/entities/task_entity.dart';
import 'notification_action_handler.dart';
import 'notification_background.dart';
import 'task_notification_helper.dart';
import 'task_notification_ids.dart';

/// Bildirim servisi - Yerel bildirimleri yönetir
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _permissionGranted = false;

  static const String completeActionId = 'complete_task';
  static const String snoozeActionId = 'snooze_task';
  static const String taskReminderChannelId = 'task_reminders';

  /// Bildirim servisini başlat
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Timezone verilerini yükle
      tz.initializeTimeZones();

      // Cihazın zaman dilimini al ve ayarla
      try {
        final String timeZoneName =
            (await FlutterTimezone.getLocalTimezone()).identifier;
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
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      if (initialized == true) {
        _initialized = true;

        if (Platform.isAndroid) {
          await _createAndroidChannels();
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

  Future<void> _createAndroidChannels() async {
    final android = resolvePlatformSpecificImplementation();
    if (android == null) return;

    const channels = [
      AndroidNotificationChannel(
        taskReminderChannelId,
        'Görev Hatırlatıcıları',
        description: 'Görevler için 1 saat ve 30 dakika önce hatırlatma',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
      AndroidNotificationChannel(
        'event_reminders',
        'Hatırlatıcı Bildirimleri',
        description: 'Etkinlik hatırlatıcıları',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
      AndroidNotificationChannel(
        'task_feedback',
        'Görev Bildirimleri',
        description: 'Tamamlama ve erteleme bildirimleri',
        importance: Importance.defaultImportance,
      ),
    ];

    for (final channel in channels) {
      await android.createNotificationChannel(channel);
    }
  }

  /// Bildirim + kesin alarm izinlerini kontrol et / iste
  Future<bool> ensurePermissions({bool requestExactAlarm = true}) async {
    if (!_initialized) await initialize();

    if (!Platform.isAndroid) return true;

    var hasNotifications = await hasPermission();
    if (!hasNotifications) {
      await _requestAndroidNotificationPermission();
      hasNotifications = await hasPermission();
    }

    if (!hasNotifications) return false;

    if (requestExactAlarm) {
      final canExact = await canScheduleExactAlarms();
      if (!canExact) {
        await requestExactAlarmsPermission();
      }
    }

    return hasNotifications;
  }

  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    final android = resolvePlatformSpecificImplementation();
    if (android == null) return false;
    return await android.canScheduleExactNotifications() ?? false;
  }

  Future<void> requestExactAlarmsPermission() async {
    if (!Platform.isAndroid) return;
    final android = resolvePlatformSpecificImplementation();
    await android?.requestExactAlarmsPermission();
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

  /// Bildirime tıklandığında veya aksiyon seçildiğinde çağrılır
  void _onNotificationTapped(NotificationResponse response) {
    NotificationActionHandler.handleResponse(response);
  }

  /// Görev hatırlatıcısı bildirimi (1 saat / 30 dakika önce)
  Future<DateTime> scheduleTaskReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String taskId,
    TaskNotificationSlot slot = TaskNotificationSlot.oneHour,
  }) async {
    return scheduleEventNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: 'task:$taskId:reminder',
      channelId: taskReminderChannelId,
      channelName: 'Görev Hatırlatıcıları',
      channelDescription:
          'Görevler için 1 saat ve 30 dakika önce hatırlatma bildirimleri',
      withTaskActions: true,
    );
  }

  /// Vade anında görev durumunu renkli bildirimle göster
  Future<void> showTaskDueStatusNotification({
    required TaskEntity task,
  }) async {
    if (!_initialized) await initialize();

    final isCompleted = task.isCompleted;
    final statusColor =
        isCompleted ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F);

    final title =
        isCompleted ? 'Görev Tamamlandı ✓' : 'Görev Tamamlanmadı';
    final dueTime = task.dueDate != null
        ? '${task.dueDate!.hour.toString().padLeft(2, '0')}:${task.dueDate!.minute.toString().padLeft(2, '0')}'
        : '';
    final body = isCompleted
        ? '"${task.title}" $dueTime için zamanında tamamlanmış.'
        : '"${task.title}" süresi doldu ($dueTime). Henüz tamamlanmadı.';

    final androidDetails = AndroidNotificationDetails(
      taskReminderChannelId,
      'Görev Hatırlatıcıları',
      channelDescription: 'Görev vade durumu bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      color: statusColor,
      colorized: true,
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.reminder,
      styleInformation: BigTextStyleInformation(body),
      actions: isCompleted
          ? null
          : <AndroidNotificationAction>[
              const AndroidNotificationAction(
                snoozeActionId,
                'Ertele',
                showsUserInterface: true,
                cancelNotification: true,
              ),
              const AndroidNotificationAction(
                completeActionId,
                'Tamamla',
                showsUserInterface: false,
                cancelNotification: true,
              ),
            ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _notifications.show(
      TaskNotificationIds.dueStatus(task.id),
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: 'task:${task.id}:due',
    );
  }

  /// Tamamlandı / ertelendi gibi geri bildirim bildirimi
  Future<void> showFeedbackNotification({
    required int id,
    required String title,
    required String body,
    bool isSuccess = true,
    bool isSnooze = false,
  }) async {
    if (!_initialized) await initialize();

    final color = isSnooze
        ? const Color(0xFFC79100)
        : isSuccess
            ? const Color(0xFF2E7D32)
            : const Color(0xFFD32F2F);

    final androidDetails = AndroidNotificationDetails(
      'task_feedback',
      'Görev Bildirimleri',
      channelDescription: 'Görev tamamlama ve erteleme bildirimleri',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      visibility: NotificationVisibility.public,
      color: color,
      colorized: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  /// Tek seferlik bildirim zamanla — gerçek zamanlanan tarihi döndürür
  Future<DateTime> scheduleEventNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = 'event_reminders',
    String channelName = 'Hatırlatıcı Bildirimleri',
    String channelDescription =
        'Etkinlikler ve görevler için hatırlatıcı bildirimleri',
    bool withTaskActions = false,
  }) async {
    if (!_initialized) await initialize();

    // Geçmiş bir tarihse bildirim gönderme
    // Ama 5 dakika tolerans ver (kullanıcı kaydetme sırasında birkaç saniye geçebilir)
    final now = DateTime.now();
    final difference = scheduledDate.difference(now);
    if (difference.isNegative && difference.inMinutes.abs() > 5) {
      throw Exception('Bildirim zamanı geçmiş: $scheduledDate');
    }
    
    // Eğer geçmiş ama 5 dakikadan azsa, hemen bildirim gönder (veya 1 dakika sonra)
    DateTime finalScheduledDate = scheduledDate;
    if (scheduledDate.isBefore(now)) {
      print('ℹ️ Bildirim tarihi geçmiş ama 5 dakikadan az, 10 saniye sonra gönderiliyor');
      finalScheduledDate = now.add(const Duration(seconds: 10));
    }

    try {
      if (Platform.isAndroid) {
        final granted = await ensurePermissions();
        if (!granted) {
          throw Exception(
            'Bildirim izni verilmedi. Ayarlar > Bildirimler bölümünden izin verin.',
          );
        }
      }

      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        channelShowBadge: true,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.reminder,
        styleInformation: BigTextStyleInformation(body),
        actions: withTaskActions
            ? <AndroidNotificationAction>[
                const AndroidNotificationAction(
                  snoozeActionId,
                  'Ertele',
                  showsUserInterface: true,
                  cancelNotification: true,
                ),
              ]
            : null,
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

      final dateToSchedule = finalScheduledDate;
      final tzScheduledDate = tz.TZDateTime(
        tz.local,
        dateToSchedule.year,
        dateToSchedule.month,
        dateToSchedule.day,
        dateToSchedule.hour,
        dateToSchedule.minute,
        dateToSchedule.second,
      );
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
        
        final scheduleMode = canScheduleExactAlarms
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle;

        await _notifications.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDate,
          notificationDetails,
          payload: payload,
          androidScheduleMode: scheduleMode,
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
          
          print('🔄 inexactAllowWhileIdle ile tekrar deneniyor...');
          try {
            await _notifications.zonedSchedule(
              id,
              title,
              body,
              tzScheduledDate,
              notificationDetails,
              payload: payload,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
            print('✅ Bildirim inexactAllowWhileIdle ile zamanlandı');
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
      
      print('🔔 Bildirim ID: $id');
      return dateToSchedule;
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
