import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/services/google_auth_service.dart';
import '../../../core/services/google_calendar_service.dart';
import 'events/calendar_sync_event.dart';
import 'states/calendar_sync_state.dart';

/// BLoC for managing Google Calendar synchronization
class CalendarSyncBloc extends Bloc<CalendarSyncEvent, CalendarSyncState> {
  final GoogleAuthService _authService;
  final GoogleCalendarService _calendarService;

  CalendarSyncBloc({
    GoogleAuthService? authService,
    GoogleCalendarService? calendarService,
  })  : _authService = authService ?? GoogleAuthService(),
        _calendarService = calendarService ?? GoogleCalendarService(),
        super(const CalendarSyncInitial()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoadCalendarsEvent>(_onLoadCalendars);
    on<FetchGoogleCalendarEventsEvent>(_onFetchGoogleCalendarEvents);
    on<FetchAllCalendarsEventsEvent>(_onFetchAllCalendarsEvents);
    on<CreateGoogleCalendarEvent>(_onCreateGoogleCalendarEvent);
    on<DeleteGoogleCalendarEvent>(_onDeleteGoogleCalendarEvent);
    on<SyncWithGoogleCalendarEvent>(_onSyncWithGoogleCalendar);
  }

  /// Google hesabı ile giriş yap
  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    emit(const CalendarSyncLoading());
    try {
      final GoogleSignInAccount? user = await _authService.signIn();
      
      if (user == null) {
        emit(const CalendarSyncNotAuthenticated());
        return;
      }

      emit(CalendarSyncAuthenticated(
        user: user,
        isSignedIn: true,
      ));
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Google girişi başarısız: $e',
        errorCode: 'SIGN_IN_ERROR',
      ));
    }
  }

  /// Google hesabından çıkış yap
  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    emit(const CalendarSyncLoading());
    try {
      await _authService.signOut();
      emit(const CalendarSyncNotAuthenticated());
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Çıkış yapılırken hata oluştu: $e',
        errorCode: 'SIGN_OUT_ERROR',
      ));
    }
  }

  /// Oturum durumunu kontrol et
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    try {
      final bool isSignedIn = await _authService.isSignedIn();
      
      if (isSignedIn) {
        final GoogleSignInAccount? user = await _authService.getUser();
        if (user != null) {
          emit(CalendarSyncAuthenticated(
            user: user,
            isSignedIn: true,
          ));
        } else {
          emit(const CalendarSyncNotAuthenticated());
        }
      } else {
        emit(const CalendarSyncNotAuthenticated());
      }
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Oturum durumu kontrol edilemedi: $e',
        errorCode: 'AUTH_CHECK_ERROR',
      ));
    }
  }

  /// Takvimleri listele
  Future<void> _onLoadCalendars(
    LoadCalendarsEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    emit(const CalendarSyncLoading());
    try {
      final List<cal.CalendarListEntry> calendars =
          await _calendarService.getCalendars();
      final cal.Calendar primaryCalendar =
          await _calendarService.getPrimaryCalendar();

      emit(CalendarsLoadedState(
        calendars: calendars,
        primaryCalendar: primaryCalendar,
      ));
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Takvimler yüklenemedi: $e',
        errorCode: 'LOAD_CALENDARS_ERROR',
      ));
    }
  }

  /// Google Calendar'dan etkinlikleri çek
  Future<void> _onFetchGoogleCalendarEvents(
    FetchGoogleCalendarEventsEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    emit(const CalendarSyncLoading());
    try {
      final List<cal.Event> events = await _calendarService.getEvents(
        calendarId: event.calendarId,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(CalendarEventsLoadedState(
        events: events,
        calendarId: event.calendarId ?? 'primary',
      ));
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Etkinlikler getirilemedi: $e',
        errorCode: 'FETCH_EVENTS_ERROR',
      ));
    }
  }

  /// Tüm takvimlerden etkinlikleri çek
  Future<void> _onFetchAllCalendarsEvents(
    FetchAllCalendarsEventsEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    emit(const CalendarSyncLoading());
    try {
      final Map<String, List<cal.Event>> eventsMap =
          await _calendarService.getAllCalendarsEvents(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(AllCalendarsEventsLoadedState(eventsMap: eventsMap));
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Tüm takvimlerden etkinlikler getirilemedi: $e',
        errorCode: 'FETCH_ALL_EVENTS_ERROR',
      ));
    }
  }

  /// Google Calendar'a etkinlik oluştur
  Future<void> _onCreateGoogleCalendarEvent(
    CreateGoogleCalendarEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    emit(const CalendarSyncLoading());
    try {
      final cal.Event createdEvent = await _calendarService.createEvent(
        calendarId: event.calendarId,
        summary: event.summary,
        start: event.start,
        end: event.end,
        description: event.description,
        location: event.location,
      );

      emit(CalendarEventCreatedState(event: createdEvent));
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Etkinlik oluşturulamadı: $e',
        errorCode: 'CREATE_EVENT_ERROR',
      ));
    }
  }

  /// Google Calendar'dan etkinlik sil
  Future<void> _onDeleteGoogleCalendarEvent(
    DeleteGoogleCalendarEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    emit(const CalendarSyncLoading());
    try {
      await _calendarService.deleteEvent(
        calendarId: event.calendarId,
        eventId: event.eventId,
      );

      emit(CalendarEventDeletedState(eventId: event.eventId));
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Etkinlik silinemedi: $e',
        errorCode: 'DELETE_EVENT_ERROR',
      ));
    }
  }

  /// Yerel takvim ile Google Calendar'ı senkronize et
  Future<void> _onSyncWithGoogleCalendar(
    SyncWithGoogleCalendarEvent event,
    Emitter<CalendarSyncState> emit,
  ) async {
    emit(const CalendarSyncLoading());
    try {
      int syncedCount = 0;

      if (event.syncDirection) {
        // Google Calendar'dan yerel veritabanına senkronize et
        final Map<String, List<cal.Event>> eventsMap =
            await _calendarService.getAllCalendarsEvents(
          startDate: event.startDate,
          endDate: event.endDate,
        );

        // Burada yerel veritabanına kaydetme işlemi yapılmalı
        // Örnek: Her event için yerel event oluştur
        for (final events in eventsMap.values) {
          syncedCount += events.length;
        }
      } else {
        // Yerel veritabanından Google Calendar'a senkronize et
        // Burada yerel veritabanından eventleri okuyup Google Calendar'a ekleme işlemi yapılmalı
      }

      emit(CalendarSyncCompletedState(
        syncedEventsCount: syncedCount,
        syncTime: DateTime.now(),
      ));
    } catch (e) {
      emit(CalendarSyncErrorState(
        message: 'Senkronizasyon başarısız: $e',
        errorCode: 'SYNC_ERROR',
      ));
    }
  }
}

