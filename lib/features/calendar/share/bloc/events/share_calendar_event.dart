import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/event_entity.dart';

/// Paylaşım eventleri - BLoC pattern için
abstract class ShareCalendarEvent extends Equatable {
  const ShareCalendarEvent();

  @override
  List<Object?> get props => [];
}

/// Tek bir etkinliği paylaş
class ShareSingleEventEvent extends ShareCalendarEvent {
  final EventEntity event;
  final String? targetTimezone; // Alıcının zaman dilimi (opsiyonel)

  const ShareSingleEventEvent({
    required this.event,
    this.targetTimezone,
  });

  @override
  List<Object?> get props => [event, targetTimezone];
}

/// Tüm takvimi paylaş
class ShareAllEventsEvent extends ShareCalendarEvent {
  final List<EventEntity> events;
  final String? calendarName;
  final String? targetTimezone; // Alıcının zaman dilimi (opsiyonel)

  const ShareAllEventsEvent({
    required this.events,
    this.calendarName,
    this.targetTimezone,
  });

  @override
  List<Object?> get props => [events, calendarName, targetTimezone];
}

/// .ics dosyasını içe aktar
class ImportICalFileEvent extends ShareCalendarEvent {
  final String icalContent;
  final String? sourceTimezone; // Gönderenin zaman dilimi (opsiyonel)

  const ImportICalFileEvent({
    required this.icalContent,
    this.sourceTimezone,
  });

  @override
  List<Object?> get props => [icalContent, sourceTimezone];
}

/// Paylaşım formatını seç (e-posta, mesaj, dosya, vb.)
class SelectShareMethodEvent extends ShareCalendarEvent {
  final ShareMethod method;

  const SelectShareMethodEvent({required this.method});

  @override
  List<Object?> get props => [method];
}

/// Zaman dilimi değişikliği kontrolü
class CheckTimezoneDifferenceEvent extends ShareCalendarEvent {
  final DateTime eventTime;
  final String sourceTimezone;
  final String targetTimezone;

  const CheckTimezoneDifferenceEvent({
    required this.eventTime,
    required this.sourceTimezone,
    required this.targetTimezone,
  });

  @override
  List<Object?> get props => [eventTime, sourceTimezone, targetTimezone];
}

/// Paylaşım metodları
enum ShareMethod {
  email,
  message,
  socialMedia,
  file,
  deepLink,
}

