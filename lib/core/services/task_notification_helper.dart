import '../../domain/entities/task_entity.dart';
import 'notification_service.dart';

/// Görev bildirimlerini yöneten yardımcı sınıf
class TaskNotificationHelper {
  final NotificationService _notificationService = NotificationService();

  /// Görev için bildirim zamanla
  Future<void> scheduleTaskNotification(TaskEntity task) async {
    print('=== Görev Bildirimi Zamanlama Başlatıldı ===');
    print('Görev ID: ${task.id}');
    print('Görev Başlığı: ${task.title}');
    print('Due Date: ${task.dueDate}');
    print('Tamamlandı mı: ${task.isCompleted}');
    
    // Due date yoksa veya tamamlanmışsa bildirim gönderme
    if (task.dueDate == null) {
      print('⚠️ Bildirim atlandı: dueDate null');
      return;
    }
    
    if (task.isCompleted) {
      print('⚠️ Bildirim atlandı: Görev tamamlanmış');
      return;
    }

    // Due date'te saat yoksa (sadece tarih varsa, yani saat 00:00 ve saniye/milisaniye de 0)
    // varsayılan olarak 09:00'da bildirim gönder
    DateTime notificationDate = task.dueDate!;
    final now = DateTime.now();
    
    print('Orijinal notificationDate: $notificationDate');
    print('Şu anki zaman: $now');
    
    // Eğer saat 00:00:00 ise ve kullanıcı muhtemelen sadece tarih seçtiyse
    // (task_form_page.dart'da saat seçilmediğinde saat 0 olarak ayarlanıyor)
    // Varsayılan olarak 09:00 kullan
    if (notificationDate.hour == 0 && 
        notificationDate.minute == 0 && 
        notificationDate.second == 0 &&
        notificationDate.millisecond == 0) {
      notificationDate = DateTime(
        notificationDate.year,
        notificationDate.month,
        notificationDate.day,
        9, // 09:00
        0,
      );
      print('ℹ️ Saat seçilmemiş, varsayılan 09:00 kullanılıyor: $notificationDate');
    }

    // Geçmiş bir tarihse bildirim gönderme veya düzelt
    final difference = notificationDate.difference(now);
    final isPast = notificationDate.isBefore(now);
    
    if (isPast) {
      // Önce bugün mü kontrol et
      final isSameDay = notificationDate.year == now.year &&
                       notificationDate.month == now.month &&
                       notificationDate.day == now.day;
      
      print('🔍 Tarih kontrolü:');
      print('   Bildirim Tarihi: ${notificationDate.year}-${notificationDate.month}-${notificationDate.day} ${notificationDate.hour}:${notificationDate.minute}');
      print('   Şu Anki Tarih: ${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}');
      print('   Aynı Gün mü: $isSameDay');
      print('   Fark: ${difference.inMinutes.abs()} dakika');
      
      if (isSameDay) {
        // Bugün seçilmiş ama saat geçmiş - yarın aynı saatte gönder
        print('ℹ️ Bugün için saat geçmiş (${difference.inMinutes.abs()} dakika), yarın aynı saatte bildirim gönderiliyor');
        notificationDate = DateTime(
          now.year,
          now.month,
          now.day,
          notificationDate.hour,
          notificationDate.minute,
        ).add(const Duration(days: 1));
        print('✅ Yeni bildirim tarihi (yarın): $notificationDate');
      } else if (difference.inMinutes.abs() <= 60) {
        // Sadece 1 saatten az geçmişse, hemen (1 dakika sonra) gönder
        print('ℹ️ Bildirim tarihi 1 saatten az geçmiş (${difference.inMinutes.abs()} dakika), 1 dakika sonra gönderiliyor');
        notificationDate = now.add(const Duration(minutes: 1));
        print('✅ Yeni bildirim tarihi (1 dakika sonra): $notificationDate');
      } else {
        // Çok geçmiş tarihse bildirim gönderme
        print('⚠️ Bildirim atlandı: Geçmiş tarih (${difference.inMinutes.abs()} dakika). Şimdi: $now, Bildirim: $notificationDate');
        return;
      }
    }

    print('✅ Bildirim zamanlanıyor: $notificationDate');
    await _scheduleNotification(
      task: task,
      scheduledDate: notificationDate,
    );
    print('=== Görev Bildirimi Zamanlama Tamamlandı ===\n');
  }

  /// Bildirimi zamanla (tekrar eden veya tek seferlik)
  Future<void> _scheduleNotification({
    required TaskEntity task,
    required DateTime scheduledDate,
  }) async {
    // Bildirim içeriğini hazırla
    final title = 'Görev Hatırlatıcısı';
    final bodyBuilder = StringBuffer(task.title);
    if (task.description != null && task.description!.isNotEmpty) {
      bodyBuilder.write('\n${task.description}');
    }
    final body = bodyBuilder.toString();

    // Görev ID'sini payload olarak ekle
    final payload = task.id;

    // Tekrar eden görev mi?
    if (task.isRecurring && task.recurringPattern != null) {
      final pattern = _parseRecurringPattern(task.recurringPattern!);
      
      if (pattern != RecurringPattern.none) {
        // Tekrar eden bildirim zamanla
        try {
          await _notificationService.scheduleRecurringEventNotification(
            id: task.id.hashCode.abs() % 100000,
            title: title,
            body: body,
            firstDate: scheduledDate,
            pattern: pattern,
            payload: payload,
          );
          return;
        } catch (e) {
          // Bildirim hatası görev kaydını engellemesin
          print('Tekrar eden görev bildirimi zamanlama hatası (${task.id}): $e');
          return;
        }
      }
    }

    // Tek seferlik bildirim zamanla
    try {
      final notificationId = task.id.hashCode.abs() % 100000;
      print('Bildirim ID: $notificationId');
      print('Bildirim Başlığı: $title');
      print('Bildirim İçeriği: $body');
      print('Zamanlanan Tarih: $scheduledDate');
      
      await _notificationService.scheduleEventNotification(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payload: payload,
      );
      
      print('✅ Bildirim başarıyla zamanlandı!');
    } catch (e, stackTrace) {
      // Bildirim hatası görev kaydını engellemesin
      print('❌ Görev bildirimi zamanlama hatası (${task.id}): $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Görev için bildirimleri iptal et
  Future<void> cancelTaskNotifications(TaskEntity task) async {
    await _notificationService.cancelEventNotifications(task.id);
  }

  /// Görev güncellendiğinde bildirimleri yeniden zamanla
  Future<void> updateTaskNotification(TaskEntity task) async {
    // Önce eski bildirimleri iptal et
    await cancelTaskNotifications(task);
    
    // Yeni bildirimleri zamanla (sadece tamamlanmamışsa)
    if (!task.isCompleted) {
      await scheduleTaskNotification(task);
    }
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

