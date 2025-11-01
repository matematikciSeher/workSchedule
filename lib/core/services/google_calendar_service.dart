import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'google_auth_service.dart';

/// Google Calendar API servisi - Takvim verilerini çekme ve senkronize etme
class GoogleCalendarService {
  static final GoogleCalendarService _instance = GoogleCalendarService._internal();
  factory GoogleCalendarService() => _instance;
  GoogleCalendarService._internal();

  final GoogleAuthService _authService = GoogleAuthService();
  cal.CalendarApi? _calendarApi;

  /// Calendar API'yi başlat
  Future<void> initialize() async {
    final String? accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Google hesabı ile giriş yapılmamış');
    }

    final GoogleSignInAccount? account = await _authService.getUser();
    if (account == null) {
      throw Exception('Google hesabı bulunamadı');
    }

    // HTTP client oluştur
    final http.Client client = http.Client();
    
    // Authenticated HTTP client oluştur
    final authenticatedClient = _AuthenticatedClient(client, accessToken);

    // Calendar API instance oluştur
    _calendarApi = cal.CalendarApi(authenticatedClient);
  }

  /// Calendar API instance'ı kontrol et ve başlat
  Future<void> _ensureInitialized() async {
    if (_calendarApi == null) {
      await initialize();
    }
  }

  /// Kullanıcının tüm takvimlerini getir
  Future<List<cal.CalendarListEntry>> getCalendars() async {
    await _ensureInitialized();
    try {
      final cal.CalendarList response = await _calendarApi!.calendarList.list();
      return response.items ?? [];
    } catch (e) {
      throw Exception('Takvimler getirilemedi: $e');
    }
  }

  /// Birincil takvimi getir (primary calendar)
  Future<cal.Calendar> getPrimaryCalendar() async {
    await _ensureInitialized();
    try {
      return await _calendarApi!.calendars.get('primary');
    } catch (e) {
      throw Exception('Birincil takvim getirilemedi: $e');
    }
  }

  /// Belirli bir tarih aralığındaki etkinlikleri getir
  /// [startDate] ve [endDate] parametreleri için DateTime kullanılır
  Future<List<cal.Event>> getEvents({
    String? calendarId,
    required DateTime startDate,
    required DateTime endDate,
    int maxResults = 250,
    bool singleEvents = true,
  }) async {
    await _ensureInitialized();
    try {
      calendarId ??= 'primary';

      final cal.Events response = await _calendarApi!.events.list(
        calendarId,
        timeMin: startDate.toUtc(),
        timeMax: endDate.toUtc(),
        maxResults: maxResults,
        singleEvents: singleEvents,
        orderBy: 'startTime',
      );

      return response.items ?? [];
    } catch (e) {
      throw Exception('Etkinlikler getirilemedi: $e');
    }
  }

  /// Tüm takvimlerden belirli bir tarih aralığındaki etkinlikleri getir
  Future<Map<String, List<cal.Event>>> getAllCalendarsEvents({
    required DateTime startDate,
    required DateTime endDate,
    int maxResults = 250,
  }) async {
    await _ensureInitialized();
    try {
      final List<cal.CalendarListEntry> calendars = await getCalendars();
      final Map<String, List<cal.Event>> eventsMap = {};

      for (final calendar in calendars) {
        try {
          final List<cal.Event> events = await getEvents(
            calendarId: calendar.id,
            startDate: startDate,
            endDate: endDate,
            maxResults: maxResults,
          );
          eventsMap[calendar.id ?? 'unknown'] = events;
        } catch (e) {
          // Bir takvimde hata olsa bile diğerlerini getirmeye devam et
          print('Takvim ${calendar.id} için etkinlikler getirilemedi: $e');
        }
      }

      return eventsMap;
    } catch (e) {
      throw Exception('Tüm takvimlerden etkinlikler getirilemedi: $e');
    }
  }

  /// Yeni bir etkinlik oluştur
  Future<cal.Event> createEvent({
    String? calendarId,
    required String summary,
    required DateTime start,
    required DateTime end,
    String? description,
    String? location,
    List<String>? attendees,
    cal.EventReminder? reminder,
  }) async {
    await _ensureInitialized();
    try {
      calendarId ??= 'primary';

      final cal.Event event = cal.Event(
        summary: summary,
        description: description,
        location: location,
        start: cal.EventDateTime(
          dateTime: start.toUtc(),
          timeZone: 'UTC',
        ),
        end: cal.EventDateTime(
          dateTime: end.toUtc(),
          timeZone: 'UTC',
        ),
        attendees: attendees?.map((email) => cal.EventAttendee(email: email)).toList(),
        reminders: reminder != null
            ? cal.EventReminders(
                useDefault: false,
                overrides: [reminder],
              )
            : null,
      );

      final cal.Event createdEvent =
          await _calendarApi!.events.insert(event, calendarId);
      return createdEvent;
    } catch (e) {
      throw Exception('Etkinlik oluşturulamadı: $e');
    }
  }

  /// Mevcut bir etkinliği güncelle
  Future<cal.Event> updateEvent({
    String? calendarId,
    required String eventId,
    required cal.Event event,
  }) async {
    await _ensureInitialized();
    try {
      calendarId ??= 'primary';

      final cal.Event updatedEvent =
          await _calendarApi!.events.update(event, calendarId, eventId);
      return updatedEvent;
    } catch (e) {
      throw Exception('Etkinlik güncellenemedi: $e');
    }
  }

  /// Bir etkinliği sil
  Future<void> deleteEvent({
    String? calendarId,
    required String eventId,
  }) async {
    await _ensureInitialized();
    try {
      calendarId ??= 'primary';
      await _calendarApi!.events.delete(calendarId, eventId);
    } catch (e) {
      throw Exception('Etkinlik silinemedi: $e');
    }
  }

  /// Etkinliği ID ile getir
  Future<cal.Event> getEvent({
    String? calendarId,
    required String eventId,
  }) async {
    await _ensureInitialized();
    try {
      calendarId ??= 'primary';
      return await _calendarApi!.events.get(calendarId, eventId);
    } catch (e) {
      throw Exception('Etkinlik getirilemedi: $e');
    }
  }
}

/// Authenticated HTTP client - OAuth token ile istekleri yapar
class _AuthenticatedClient extends http.BaseClient {
  final http.Client _client;
  final String _accessToken;

  _AuthenticatedClient(this._client, this._accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _client.send(request);
  }
}

