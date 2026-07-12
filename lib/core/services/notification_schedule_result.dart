import 'package:intl/intl.dart';

import '../locale/app_localizations_helper.dart';

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
    final l10n = systemL10n;
    if (!success) {
      return errorMessage ?? l10n.notificationCannotBeScheduled;
    }
    if (infoMessage != null) return infoMessage!;
    if (reminderAt == null) return l10n.notificationScheduled;
    return l10n.newReminderAt(_format(reminderAt!));
  }

  String _format(DateTime dt) {
    return DateFormat('dd.MM.yyyy HH:mm', systemDateFormatLocale()).format(dt);
  }
}
