import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/event_entity.dart';
import '../events/share_calendar_event.dart';

/// Paylaşım state'leri - BLoC pattern için
abstract class ShareCalendarState extends Equatable {
  const ShareCalendarState();

  @override
  List<Object?> get props => [];
}

/// Başlangıç durumu
class ShareCalendarInitial extends ShareCalendarState {
  const ShareCalendarInitial();
}

/// Yükleniyor durumu
class ShareCalendarLoading extends ShareCalendarState {
  const ShareCalendarLoading();
}

/// .ics içeriği hazır
class ICalContentReady extends ShareCalendarState {
  final String icalContent;
  final String fileName;
  final String? timezoneWarning;

  const ICalContentReady({
    required this.icalContent,
    required this.fileName,
    this.timezoneWarning,
  });

  @override
  List<Object?> get props => [icalContent, fileName, timezoneWarning];
}

/// Paylaşım başarılı
class ShareCalendarSuccess extends ShareCalendarState {
  final ShareMethod method;
  final String message;

  const ShareCalendarSuccess({
    required this.method,
    required this.message,
  });

  @override
  List<Object?> get props => [method, message];
}

/// İçe aktarma başarılı
class ImportCalendarSuccess extends ShareCalendarState {
  final List<EventEntity> importedEvents;
  final String? timezoneWarning;

  const ImportCalendarSuccess({
    required this.importedEvents,
    this.timezoneWarning,
  });

  @override
  List<Object?> get props => [importedEvents, timezoneWarning];
}

/// Zaman dilimi farkı kontrol edildi
class TimezoneDifferenceChecked extends ShareCalendarState {
  final int differenceHours;
  final int differenceMinutes;
  final String warningMessage;
  final DateTime originalTime;
  final DateTime adjustedTime;

  const TimezoneDifferenceChecked({
    required this.differenceHours,
    required this.differenceMinutes,
    required this.warningMessage,
    required this.originalTime,
    required this.adjustedTime,
  });

  @override
  List<Object?> get props => [
        differenceHours,
        differenceMinutes,
        warningMessage,
        originalTime,
        adjustedTime,
      ];
}

/// Hata durumu
class ShareCalendarError extends ShareCalendarState {
  final String message;
  final String? errorCode;

  const ShareCalendarError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}
