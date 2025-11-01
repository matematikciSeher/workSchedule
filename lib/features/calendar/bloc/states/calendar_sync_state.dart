import 'package:equatable/equatable.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';

/// Base class for calendar sync states
abstract class CalendarSyncState extends Equatable {
  const CalendarSyncState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class CalendarSyncInitial extends CalendarSyncState {
  const CalendarSyncInitial();
}

/// Loading state
class CalendarSyncLoading extends CalendarSyncState {
  const CalendarSyncLoading();
}

/// Authenticated state
class CalendarSyncAuthenticated extends CalendarSyncState {
  final GoogleSignInAccount user;
  final bool isSignedIn;

  const CalendarSyncAuthenticated({
    required this.user,
    required this.isSignedIn,
  });

  @override
  List<Object?> get props => [user, isSignedIn];
}

/// Not authenticated state
class CalendarSyncNotAuthenticated extends CalendarSyncState {
  const CalendarSyncNotAuthenticated();
}

/// Calendars loaded state
class CalendarsLoadedState extends CalendarSyncState {
  final List<cal.CalendarListEntry> calendars;
  final cal.Calendar? primaryCalendar;

  const CalendarsLoadedState({
    required this.calendars,
    this.primaryCalendar,
  });

  @override
  List<Object?> get props => [calendars, primaryCalendar];
}

/// Events loaded state
class CalendarEventsLoadedState extends CalendarSyncState {
  final List<cal.Event> events;
  final String calendarId;

  const CalendarEventsLoadedState({
    required this.events,
    required this.calendarId,
  });

  @override
  List<Object?> get props => [events, calendarId];
}

/// All calendars events loaded state
class AllCalendarsEventsLoadedState extends CalendarSyncState {
  final Map<String, List<cal.Event>> eventsMap;

  const AllCalendarsEventsLoadedState({
    required this.eventsMap,
  });

  @override
  List<Object?> get props => [eventsMap];
}

/// Event created state
class CalendarEventCreatedState extends CalendarSyncState {
  final cal.Event event;

  const CalendarEventCreatedState({
    required this.event,
  });

  @override
  List<Object?> get props => [event];
}

/// Event deleted state
class CalendarEventDeletedState extends CalendarSyncState {
  final String eventId;

  const CalendarEventDeletedState({
    required this.eventId,
  });

  @override
  List<Object?> get props => [eventId];
}

/// Sync completed state
class CalendarSyncCompletedState extends CalendarSyncState {
  final int syncedEventsCount;
  final DateTime syncTime;

  const CalendarSyncCompletedState({
    required this.syncedEventsCount,
    required this.syncTime,
  });

  @override
  List<Object?> get props => [syncedEventsCount, syncTime];
}

/// Error state
class CalendarSyncErrorState extends CalendarSyncState {
  final String message;
  final String? errorCode;

  const CalendarSyncErrorState({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

