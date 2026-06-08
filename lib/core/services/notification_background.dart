import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_action_handler.dart';

/// Arka planda bildirim aksiyonlarını işler (uygulama kapalıyken)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  NotificationActionHandler.handleResponse(response);
}
