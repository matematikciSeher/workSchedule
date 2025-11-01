import 'package:flutter/foundation.dart';
import '../routes/app_routes.dart';

/// Deep link servisi - Paylaşım linklerini parse eder ve yönlendirme yapar
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  /// Deep link'i parse et ve route + parametreler döndür
  DeepLinkResult? parseDeepLink(String? url) {
    if (url == null || url.isEmpty) return null;

    try {
      // workschedule:// prefix'ini temizle
      if (url.startsWith(AppRoutes.deepLinkBase)) {
        final uri = Uri.parse(url);
        final path = uri.path;
        final queryParams = uri.queryParameters;

        // Share event
        if (path.startsWith('/share/event')) {
          final eventId = queryParams['eventId'];
          final timezone = queryParams['timezone'];
          
          return DeepLinkResult(
            route: AppRoutes.shareEvent,
            eventId: eventId,
            timezone: timezone,
            icalContent: queryParams['ical'],
          );
        }

        // Share calendar
        if (path.startsWith('/share/calendar')) {
          final timezone = queryParams['timezone'];
          final calendarName = queryParams['calendarName'];
          
          return DeepLinkResult(
            route: AppRoutes.shareCalendar,
            timezone: timezone,
            calendarName: calendarName,
            icalContent: queryParams['ical'],
          );
        }

        // Import calendar
        if (path.startsWith('/import/calendar')) {
          final icalContent = queryParams['ical'];
          final sourceTimezone = queryParams['sourceTimezone'];
          
          return DeepLinkResult(
            route: AppRoutes.importCalendar,
            icalContent: icalContent,
            sourceTimezone: sourceTimezone,
          );
        }
      }

      // HTTP/HTTPS linklerini kontrol et (web için)
      if (url.startsWith('http://') || url.startsWith('https://')) {
        final uri = Uri.parse(url);
        
        // workschedule.com veya benzeri domain kontrolü
        if (uri.host.contains('workschedule') || uri.host.contains('localhost')) {
          return parseDeepLink(uri.toString().replaceFirst('http', 'workschedule'));
        }
      }
    } catch (e) {
      debugPrint('Deep link parse hatası: $e');
    }

    return null;
  }

  /// Etkinlik için deep link oluştur
  String createEventDeepLink({
    required String eventId,
    String? icalContent,
    String? timezone,
  }) {
    final uri = Uri(
      scheme: 'workschedule',
      host: 'share',
      path: '/event',
      queryParameters: {
        if (eventId.isNotEmpty) 'eventId': eventId,
        if (icalContent != null && icalContent.isNotEmpty) 'ical': icalContent,
        if (timezone != null) 'timezone': timezone,
      },
    );
    return uri.toString();
  }

  /// Takvim için deep link oluştur
  String createCalendarDeepLink({
    String? icalContent,
    String? timezone,
    String? calendarName,
  }) {
    final uri = Uri(
      scheme: 'workschedule',
      host: 'share',
      path: '/calendar',
      queryParameters: {
        if (icalContent != null && icalContent.isNotEmpty) 'ical': icalContent,
        if (timezone != null) 'timezone': timezone,
        if (calendarName != null) 'calendarName': calendarName,
      },
    );
    return uri.toString();
  }

  /// İçe aktarma için deep link oluştur
  String createImportDeepLink({
    required String icalContent,
    String? sourceTimezone,
  }) {
    final uri = Uri(
      scheme: 'workschedule',
      host: 'import',
      path: '/calendar',
      queryParameters: {
        'ical': icalContent,
        if (sourceTimezone != null) 'sourceTimezone': sourceTimezone,
      },
    );
    return uri.toString();
  }
}

/// Deep link parse sonucu
class DeepLinkResult {
  final String route;
  final String? eventId;
  final String? timezone;
  final String? sourceTimezone;
  final String? calendarName;
  final String? icalContent;

  DeepLinkResult({
    required this.route,
    this.eventId,
    this.timezone,
    this.sourceTimezone,
    this.calendarName,
    this.icalContent,
  });

  @override
  String toString() {
    return 'DeepLinkResult(route: $route, eventId: $eventId, timezone: $timezone)';
  }
}

