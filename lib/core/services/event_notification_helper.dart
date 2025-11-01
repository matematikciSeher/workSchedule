import '../../domain/entities/event_entity.dart';
import 'notification_service.dart';

/// Etkinlik bildirimlerini yöneten yardımcı sınıf
class EventNotificationHelper {
  final NotificationService _notificationService = NotificationService();

  /// Etkinlik için bildirim zamanla
  Future<void> scheduleEventNotification(EventEntity event) async {
    // Hatırlatma ayarı yoksa bildirim gönderme
    if (event.reminderBeforeMinutes == null || event.reminderBeforeMinutes! <= 0) {
      return;
    }

    // Bildirim zamanını hesapla (etkinlik başlangıcından X dakika önce)
    final notificationDate = event.startDate.subtract(
      Duration(minutes: event.reminderBeforeMinutes!),
    );

    // Geçmiş bir tarihse bildirim gönderme
    if (notificationDate.isBefore(DateTime.now())) {
      return;
    }

    // Bildirim içeriğini hazırla
    final title = 'Etkinlik Hatırlatıcısı';
    final bodyBuilder = StringBuffer(event.title);
    if (event.location != null && event.location!.isNotEmpty) {
      bodyBuilder.write(' - ${event.location}');
    }
    if (event.description != null && event.description!.isNotEmpty) {
      bodyBuilder.write('\n${event.description}');
    }
    final body = bodyBuilder.toString();

    // Etkinlik ID'sini payload olarak ekle
    final payload = event.id;

    // Tekrar eden bildirim mi?
    if (event.isRecurring && event.recurringPattern != null) {
      final pattern = _parseRecurringPattern(event.recurringPattern!);
      
      if (pattern != RecurringPattern.none) {
        // Tekrar eden bildirim zamanla
        await _notificationService.scheduleRecurringEventNotification(
          id: event.id.hashCode.abs() % 100000,
          title: title,
          body: body,
          firstDate: notificationDate,
          pattern: pattern,
          payload: payload,
        );
        return;
      }
    }

    // Tek seferlik bildirim zamanla
    await _notificationService.scheduleEventNotification(
      id: event.id.hashCode.abs() % 100000,
      title: title,
      body: body,
      scheduledDate: notificationDate,
      payload: payload,
    );
  }

  /// Etkinlik için bildirimleri iptal et
  Future<void> cancelEventNotifications(EventEntity event) async {
    await _notificationService.cancelEventNotifications(event.id);
  }

  /// Etkinlik güncellendiğinde bildirimleri yeniden zamanla
  Future<void> updateEventNotification(EventEntity event) async {
    // Önce eski bildirimleri iptal et
    await cancelEventNotifications(event);
    
    // Yeni bildirimleri zamanla
    await scheduleEventNotification(event);
  }

  /// Recurring pattern string'ini enum'a çevir
  RecurringPattern _parseRecurringPattern(String pattern) {
    switch (pattern.toLowerCase()) {
      case 'daily':
        return RecurringPattern.daily;
      case 'weekly':
        return RecurringPattern.weekly;
      case 'monthly':
        return RecurringPattern.monthly;
      default:
        return RecurringPattern.none;
    }
  }
}

