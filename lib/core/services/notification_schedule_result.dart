/// Bildirim zamanlama sonucu
class NotificationScheduleResult {
  final bool success;
  final DateTime? reminderAt;
  final DateTime? dueAt;
  final String? errorMessage;
  final String? infoMessage;
  final bool needsExactAlarmPermission;
  final bool needsNotificationPermission;

  const NotificationScheduleResult({
    required this.success,
    this.reminderAt,
    this.dueAt,
    this.errorMessage,
    this.infoMessage,
    this.needsExactAlarmPermission = false,
    this.needsNotificationPermission = false,
  });

  String? get displayMessage => success ? infoMessage : errorMessage;

  String get userMessage {
    if (!success) {
      return errorMessage ?? 'Bildirim zamanlanamadı.';
    }
    if (infoMessage != null) return infoMessage!;
    if (reminderAt == null) return 'Bildirim zamanlandı.';
    return 'Bildirim ${_format(reminderAt!)} tarihinde gelecek.';
  }

  String _format(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day.$month.${dt.year} $hour:$minute';
  }
}
