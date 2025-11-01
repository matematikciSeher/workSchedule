import 'package:equatable/equatable.dart';

/// Base class for calendar sync events
abstract class CalendarSyncEvent extends Equatable {
  const CalendarSyncEvent();
  
  @override
  List<Object?> get props => [];
}

/// Google hesabı ile giriş yap
class SignInWithGoogleEvent extends CalendarSyncEvent {
  const SignInWithGoogleEvent();
}

/// Google hesabından çıkış yap
class SignOutEvent extends CalendarSyncEvent {
  const SignOutEvent();
}

/// Oturum durumunu kontrol et
class CheckAuthStatusEvent extends CalendarSyncEvent {
  const CheckAuthStatusEvent();
}

/// Google Calendar'dan etkinlikleri çek
class FetchGoogleCalendarEventsEvent extends CalendarSyncEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? calendarId;

  const FetchGoogleCalendarEventsEvent({
    required this.startDate,
    required this.endDate,
    this.calendarId,
  });

  @override
  List<Object?> get props => [startDate, endDate, calendarId];
}

/// Tüm takvimlerden etkinlikleri çek
class FetchAllCalendarsEventsEvent extends CalendarSyncEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FetchAllCalendarsEventsEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Takvimleri listele
class LoadCalendarsEvent extends CalendarSyncEvent {
  const LoadCalendarsEvent();
}

/// Google Calendar'a etkinlik oluştur
class CreateGoogleCalendarEvent extends CalendarSyncEvent {
  final String summary;
  final DateTime start;
  final DateTime end;
  final String? description;
  final String? location;
  final String? calendarId;

  const CreateGoogleCalendarEvent({
    required this.summary,
    required this.start,
    required this.end,
    this.description,
    this.location,
    this.calendarId,
  });

  @override
  List<Object?> get props => [
        summary,
        start,
        end,
        description,
        location,
        calendarId,
      ];
}

/// Google Calendar'dan etkinlik sil
class DeleteGoogleCalendarEvent extends CalendarSyncEvent {
  final String eventId;
  final String? calendarId;

  const DeleteGoogleCalendarEvent({
    required this.eventId,
    this.calendarId,
  });

  @override
  List<Object?> get props => [eventId, calendarId];
}

/// Yerel takvim ile Google Calendar'ı senkronize et
class SyncWithGoogleCalendarEvent extends CalendarSyncEvent {
  final DateTime startDate;
  final DateTime endDate;
  final bool syncDirection; // true: Google -> Local, false: Local -> Google

  const SyncWithGoogleCalendarEvent({
    required this.startDate,
    required this.endDate,
    this.syncDirection = true,
  });

  @override
  List<Object?> get props => [startDate, endDate, syncDirection];
}

