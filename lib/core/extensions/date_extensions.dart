import 'package:intl/intl.dart';

/// Tarih işlemleri için extension'lar
extension DateExtensions on DateTime {
  /// Tarihi string formatına çevir (dd.MM.yyyy)
  String toDateString() {
    return DateFormat('dd.MM.yyyy').format(this);
  }
  
  /// Saati string formatına çevir (HH:mm)
  String toTimeString() {
    return DateFormat('HH:mm').format(this);
  }
  
  /// Tarih ve saati string formatına çevir
  String toDateTimeString() {
    return DateFormat('dd.MM.yyyy HH:mm').format(this);
  }
  
  /// Sadece tarihi döndür (saat bilgisi olmadan)
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }
  
  /// Bugün mü kontrol et
  bool get isToday {
    final now = DateTime.now().dateOnly;
    return dateOnly == now;
  }
  
  /// Yarın mı kontrol et
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1)).dateOnly;
    return dateOnly == tomorrow;
  }
  
  /// Dün mü kontrol et
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).dateOnly;
    return dateOnly == yesterday;
  }
  
  /// Haftanın ilk günü (Pazartesi)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).dateOnly;
  }
  
  /// Haftanın son günü (Pazar)
  DateTime get endOfWeek {
    final daysToSunday = 7 - weekday;
    return add(Duration(days: daysToSunday)).dateOnly;
  }
  
  /// Ayın ilk günü
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }
  
  /// Ayın son günü
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0);
  }
}

