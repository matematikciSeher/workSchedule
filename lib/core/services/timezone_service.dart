import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

/// Timezone ve location tabanlı zaman dilimi yönetim servisi
/// UTC standardını kullanır ve zaman dilimi dönüşümlerini yönetir
class TimezoneService {
  static final TimezoneService _instance = TimezoneService._internal();
  factory TimezoneService() => _instance;
  TimezoneService._internal();

  bool _initialized = false;
  tz.Location? _localLocation;

  /// Servisi başlat (timezone verilerini yükle)
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Timezone verilerini yükle
      tz.initializeTimeZones();

      // Cihazın yerel zaman dilimini al
      final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
      _localLocation = tz.getLocation(timeZoneName);
      tz.setLocalLocation(_localLocation!);

      _initialized = true;
    } catch (e) {
      // Hata durumunda UTC kullan
      _localLocation = tz.getLocation('UTC');
      tz.setLocalLocation(_localLocation!);
      _initialized = true;
    }
  }

  /// Cihazın mevcut zaman dilimini al
  Future<String> getLocalTimezone() async {
    await initialize();
    try {
      return await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      return 'UTC';
    }
  }

  /// UTC offset'ini saat cinsinden al (+3, -5, vb.)
  Future<int> getUTCOffsetHours() async {
    await initialize();
    final now = tz.TZDateTime.now(_localLocation!);
    final utcNow = now.toUtc();
    final offset = now.difference(utcNow);
    return offset.inHours;
  }

  /// UTC offset'ini dakika cinsinden al
  Future<int> getUTCOffsetMinutes() async {
    await initialize();
    final now = tz.TZDateTime.now(_localLocation!);
    final utcNow = now.toUtc();
    final offset = now.difference(utcNow);
    return offset.inMinutes;
  }

  /// UTC offset string'i al (örn: "+03:00", "-05:00")
  Future<String> getUTCOffsetString() async {
    final offsetMinutes = await getUTCOffsetMinutes();
    final hours = offsetMinutes ~/ 60;
    final minutes = offsetMinutes.abs() % 60;
    final sign = hours >= 0 ? '+' : '-';
    return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// DateTime'ı UTC'ye çevir
  DateTime toUTC(DateTime localDateTime) {
    return localDateTime.toUtc();
  }

  /// UTC DateTime'ı yerel zamana çevir
  DateTime fromUTC(DateTime utcDateTime) {
    return utcDateTime.toLocal();
  }

  /// DateTime'ı belirli bir zaman dilimine çevir
  Future<DateTime> convertToTimezone(DateTime dateTime, String targetTimezone) async {
    await initialize();
    try {
      final targetLocation = tz.getLocation(targetTimezone);
      final sourceTZDateTime = tz.TZDateTime(
        _localLocation!,
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
      final targetTZDateTime = tz.TZDateTime.from(
        sourceTZDateTime,
        targetLocation,
      );
      return DateTime(
        targetTZDateTime.year,
        targetTZDateTime.month,
        targetTZDateTime.day,
        targetTZDateTime.hour,
        targetTZDateTime.minute,
        targetTZDateTime.second,
      );
    } catch (e) {
      // Hata durumunda orijinal DateTime'ı döndür
      return dateTime;
    }
  }

  /// UTC DateTime'ı hedef zaman dilimine çevir
  Future<DateTime> convertUTCToTimezone(DateTime utcDateTime, String targetTimezone) async {
    await initialize();
    try {
      final targetLocation = tz.getLocation(targetTimezone);
      final utcTZDateTime = tz.TZDateTime.from(utcDateTime, tz.UTC);
      final targetTZDateTime = tz.TZDateTime.from(utcTZDateTime, targetLocation);
      return DateTime(
        targetTZDateTime.year,
        targetTZDateTime.month,
        targetTZDateTime.day,
        targetTZDateTime.hour,
        targetTZDateTime.minute,
        targetTZDateTime.second,
      );
    } catch (e) {
      return utcDateTime.toLocal();
    }
  }

  /// İki zaman dilimi arasındaki farkı saat cinsinden al
  Future<int> getTimezoneDifferenceHours(String timezone1, String timezone2) async {
    await initialize();
    try {
      final location1 = tz.getLocation(timezone1);
      final location2 = tz.getLocation(timezone2);

      final now = tz.TZDateTime.now(tz.UTC);
      final tz1DateTime = tz.TZDateTime.from(now, location1);
      final tz2DateTime = tz.TZDateTime.from(now, location2);

      final diff = tz1DateTime.difference(tz2DateTime);
      return diff.inHours;
    } catch (e) {
      return 0;
    }
  }

  /// Zaman dilimi farkını dakika cinsinden al
  Future<int> getTimezoneDifferenceMinutes(String timezone1, String timezone2) async {
    await initialize();
    try {
      final location1 = tz.getLocation(timezone1);
      final location2 = tz.getLocation(timezone2);

      final now = tz.TZDateTime.now(tz.UTC);
      final tz1DateTime = tz.TZDateTime.from(now, location1);
      final tz2DateTime = tz.TZDateTime.from(now, location2);

      final diff = tz1DateTime.difference(tz2DateTime);
      return diff.inMinutes;
    } catch (e) {
      return 0;
    }
  }

  /// DateTime'ı formatla (zaman dilimi bilgisiyle)
  Future<String> formatDateTimeWithTimezone(DateTime dateTime, String timezone) async {
    await initialize();
    try {
      final location = tz.getLocation(timezone);
      final tzDateTime = tz.TZDateTime.from(dateTime, location);
      final offset = tzDateTime.timeZoneOffset;
      final offsetHours = offset.inHours;
      final offsetMinutes = (offset.inMinutes % 60).abs();
      final sign = offsetHours >= 0 ? '+' : '-';
      final offsetStr = '$sign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';

      return DateFormat('yyyy-MM-dd HH:mm:ss $offsetStr').format(dateTime);
    } catch (e) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }
  }

  /// Etkinlik saatlerini alıcının zaman dilimine göre ayarla
  /// Kaynak: gönderenin zaman dilimi
  /// Hedef: alıcının zaman dilimi
  Future<DateTime> adjustEventTimeForReceiver(
    DateTime eventTime,
    String sourceTimezone,
    String targetTimezone,
  ) async {
    // Event time zaten UTC olarak saklanmalı
    // Bu durumda direkt hedef timezone'a çevir
    return await convertUTCToTimezone(eventTime, targetTimezone);
  }

  /// Zaman dilimi değişikliği uyarısı için mesaj oluştur
  Future<String> getTimezoneChangeWarningMessage(
    DateTime originalTime,
    String sourceTimezone,
    String targetTimezone,
  ) async {
    final diffHours = await getTimezoneDifferenceHours(sourceTimezone, targetTimezone);
    final diffMinutes = await getTimezoneDifferenceMinutes(sourceTimezone, targetTimezone);

    if (diffHours == 0 && diffMinutes == 0) {
      return 'Zaman dilimleri aynı, saat değişmeyecek.';
    }

    final adjustedTime = await adjustEventTimeForReceiver(originalTime, sourceTimezone, targetTimezone);
    final originalTimeStr = DateFormat('HH:mm').format(originalTime);
    final adjustedTimeStr = DateFormat('HH:mm').format(adjustedTime);

    final direction = diffHours > 0 ? 'ileri' : 'geri';
    final diffAbs = diffHours.abs();

    return 'Zaman dilimi farkı: $diffAbs saat $direction\n'
           'Orijinal saat: $originalTimeStr ($sourceTimezone)\n'
           'Yeni saat: $adjustedTimeStr ($targetTimezone)';
  }

  /// Popüler zaman dilimlerinin listesi
  static const Map<String, String> popularTimezones = {
    'Europe/Istanbul': 'İstanbul (GMT+3)',
    'Europe/Berlin': 'Berlin (GMT+1/+2)',
    'Europe/London': 'Londra (GMT+0/+1)',
    'America/New_York': 'New York (GMT-5/-4)',
    'America/Los_Angeles': 'Los Angeles (GMT-8/-7)',
    'Asia/Tokyo': 'Tokyo (GMT+9)',
    'Asia/Shanghai': 'Şangay (GMT+8)',
    'Australia/Sydney': 'Sidney (GMT+10/+11)',
    'UTC': 'UTC (GMT+0)',
  };

  /// Zaman dilimi adından kullanıcı dostu isim al
  String getTimezoneDisplayName(String timezone) {
    return popularTimezones[timezone] ?? timezone;
  }
}

