import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'icalendar_service.dart';

/// Paylaşım servisi - share_plus paketi ile entegrasyon
class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  final ICalendarService _icalService = ICalendarService();

  /// .ics içeriğini paylaş (e-posta, mesaj, sosyal medya)
  Future<void> shareICalContent(
    String icalContent, {
    String? subject,
    String? text,
    String? fileName,
  }) async {
    try {
      // Geçici dosya oluştur
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${fileName ?? 'calendar.ics'}');
      await file.writeAsString(icalContent);

      // Paylaş
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: subject ?? 'Takvim Paylaşımı',
        text: text ?? 'İşte takviminiz (.ics formatında)',
      );
    } catch (e) {
      throw Exception('Paylaşım hatası: $e');
    }
  }

  /// .ics dosyasını e-posta ile paylaş
  Future<void> shareICalViaEmail(
    String icalContent, {
    String? subject,
    String? body,
    String? fileName,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${fileName ?? 'calendar.ics'}');
      await file.writeAsString(icalContent);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: subject ?? 'Takvim Paylaşımı',
        text: body,
      );
    } catch (e) {
      throw Exception('E-posta paylaşım hatası: $e');
    }
  }

  /// .ics dosyasını mesaj ile paylaş
  Future<void> shareICalViaMessage(
    String icalContent, {
    String? text,
    String? fileName,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${fileName ?? 'calendar.ics'}');
      await file.writeAsString(icalContent);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: text ?? 'İşte takviminiz',
      );
    } catch (e) {
      throw Exception('Mesaj paylaşım hatası: $e');
    }
  }

  /// Metin paylaş (deep link için)
  Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(
        text,
        subject: subject,
      );
    } catch (e) {
      throw Exception('Metin paylaşım hatası: $e');
    }
  }

  /// Deep link oluştur ve paylaş
  Future<void> shareDeepLink(
    String deepLink, {
    String? subject,
    String? text,
  }) async {
    try {
      final shareText = text != null 
          ? '$text\n\n$deepLink'
          : 'Takvimi görüntülemek için bağlantıya tıklayın:\n$deepLink';

      await Share.share(
        shareText,
        subject: subject ?? 'Takvim Paylaşımı',
      );
    } catch (e) {
      throw Exception('Deep link paylaşım hatası: $e');
    }
  }
}

