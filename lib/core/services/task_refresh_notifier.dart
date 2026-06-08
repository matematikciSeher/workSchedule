import 'package:flutter/foundation.dart';

/// Bildirimden görev değişince ana ekranı yenilemek için
class TaskRefreshNotifier {
  TaskRefreshNotifier._();

  static final ValueNotifier<int> tick = ValueNotifier(0);

  /// Erteleme sonrası takvimde odaklanılacak yeni tarih
  static DateTime? focusDate;

  static void notifySnoozed(DateTime newDueDate) {
    focusDate = newDueDate;
    tick.value++;
  }

  static void notifyReload() {
    focusDate = null;
    tick.value++;
  }
}
