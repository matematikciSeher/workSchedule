/// Görev bildirim ID'leri — her görev için ayrı slotlar
class TaskNotificationIds {
  static int base(String taskId) => taskId.hashCode.abs() % 100000;

  /// 1 saat önce hatırlatıcı
  static int oneHour(String taskId) => base(taskId);

  /// 30 dakika önce hatırlatıcı
  static int halfHour(String taskId) => base(taskId) + 1;

  /// Vade anı durum bildirimi
  static int dueStatus(String taskId) => base(taskId) + 2;

  /// Geri bildirim bildirimleri
  static int feedback(String taskId) => base(taskId) + 50000;
}
