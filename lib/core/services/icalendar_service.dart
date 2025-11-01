import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/event_entity.dart';

/// iCalendar formatında (.ics) export/import servisi
/// RFC 5545 standardına uygun .ics dosyaları oluşturur ve okur
class ICalendarService {
  static final ICalendarService _instance = ICalendarService._internal();
  factory ICalendarService() => _instance;
  ICalendarService._internal();

  /// DateTime'ı iCalendar formatına çevir (UTC)
  /// Format: YYYYMMDDTHHmmssZ
  String _formatICalDateTime(DateTime dateTime) {
    return DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'').format(
      dateTime.toUtc(),
    );
  }

  /// Metin içindeki özel karakterleri escape et
  String _escapeText(String? text) {
    if (text == null || text.isEmpty) return '';
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '');
  }

  /// Uzun satırları 75 karaktere böl (iCalendar RFC standardı)
  String _foldLine(String line) {
    const maxLength = 75;
    if (line.length <= maxLength) return line;

    final buffer = StringBuffer();
    int currentIndex = 0;

    while (currentIndex < line.length) {
      if (currentIndex > 0) {
        buffer.write(' ');
      }
      final endIndex = (currentIndex + maxLength).clamp(0, line.length);
      buffer.write(line.substring(currentIndex, endIndex));
      if (endIndex < line.length) {
        buffer.writeln();
      }
      currentIndex = endIndex;
    }

    return buffer.toString();
  }

  /// Tek bir etkinliği .ics formatına çevir
  String _eventToICal(EventEntity event) {
    final buffer = StringBuffer();

    // BEGIN:VEVENT
    buffer.writeln('BEGIN:VEVENT');

    // UID (benzersiz kimlik)
    buffer.writeln('UID:${event.id}@workschedule.app');

    // DTSTAMP (oluşturulma zamanı - UTC)
    buffer.writeln('DTSTAMP:${_formatICalDateTime(DateTime.now())}');

    // DTSTART (başlangıç zamanı)
    if (event.isAllDay) {
      // Tüm günlük etkinlikler için sadece tarih
      final dateStr = DateFormat('yyyyMMdd').format(event.startDate.toUtc());
      buffer.writeln('DTSTART;VALUE=DATE:$dateStr');
    } else {
      // Zamanlı etkinlikler için UTC zaman
      buffer.writeln('DTSTART:${_formatICalDateTime(event.startDate)}');
    }

    // DTEND (bitiş zamanı)
    if (event.isAllDay) {
      final dateStr = DateFormat('yyyyMMdd').format(event.endDate.toUtc());
      buffer.writeln('DTEND;VALUE=DATE:$dateStr');
    } else {
      buffer.writeln('DTEND:${_formatICalDateTime(event.endDate)}');
    }

    // SUMMARY (başlık)
    if (event.title.isNotEmpty) {
      buffer.writeln('SUMMARY:${_escapeText(event.title)}');
    }

    // DESCRIPTION (açıklama)
    if (event.description != null && event.description!.isNotEmpty) {
      buffer.writeln('DESCRIPTION:${_escapeText(event.description)}');
    }

    // LOCATION (konum)
    if (event.location != null && event.location!.isNotEmpty) {
      buffer.writeln('LOCATION:${_escapeText(event.location)}');
    }

    // ATTENDEE (katılımcılar)
    for (final attendee in event.attendees) {
      if (attendee.isNotEmpty) {
        // E-posta formatında olmayabilir, ama iCalendar standardına uygun
        buffer.writeln('ATTENDEE;CN=${_escapeText(attendee)}:mailto:$attendee');
      }
    }

    // CREATED (oluşturulma zamanı)
    buffer.writeln('CREATED:${_formatICalDateTime(event.createdAt)}');

    // LAST-MODIFIED (son güncelleme zamanı)
    buffer.writeln('LAST-MODIFIED:${_formatICalDateTime(event.updatedAt)}');

    // STATUS
    if (event.hasEnded) {
      buffer.writeln('STATUS:COMPLETED');
    } else if (event.isOngoing) {
      buffer.writeln('STATUS:CONFIRMED');
    } else {
      buffer.writeln('STATUS:CONFIRMED');
    }

    // RECURRENCE (tekrarlayan etkinlikler için - gelecekte genişletilebilir)
    if (event.isRecurring && event.recurringPattern != null) {
      // RRULE örneği: FREQ=DAILY;INTERVAL=1 (günlük, her 1 günde bir)
      String? rrule;
      switch (event.recurringPattern!.toLowerCase()) {
        case 'daily':
          rrule = 'FREQ=DAILY;INTERVAL=1';
          break;
        case 'weekly':
          rrule = 'FREQ=WEEKLY;INTERVAL=1';
          break;
        case 'monthly':
          rrule = 'FREQ=MONTHLY;INTERVAL=1';
          break;
      }
      if (rrule != null) {
        buffer.writeln('RRULE:$rrule');
      }
    }

    // END:VEVENT
    buffer.writeln('END:VEVENT');

    return buffer.toString();
  }

  /// Etkinlik listesini .ics formatına çevir (tüm takvim)
  String exportEventsToICal(List<EventEntity> events, {String? calendarName}) {
    final buffer = StringBuffer();

    // BEGIN:VCALENDAR
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('PRODID:-//WorkSchedule//Calendar//TR');
    buffer.writeln('CALSCALE:GREGORIAN');
    buffer.writeln('METHOD:PUBLISH');

    // CALENDAR NAME
    if (calendarName != null && calendarName.isNotEmpty) {
      buffer.writeln('X-WR-CALNAME:${_escapeText(calendarName)}');
    }

    // TIMEZONE (UTC kullanıyoruz)
    buffer.writeln('BEGIN:VTIMEZONE');
    buffer.writeln('TZID:UTC');
    buffer.writeln('BEGIN:STANDARD');
    buffer.writeln('DTSTART:19700101T000000Z');
    buffer.writeln('TZOFFSETFROM:+0000');
    buffer.writeln('TZOFFSETTO:+0000');
    buffer.writeln('TZNAME:UTC');
    buffer.writeln('END:STANDARD');
    buffer.writeln('END:VTIMEZONE');

    // Etkinlikleri ekle
    for (final event in events) {
      buffer.write(_eventToICal(event));
    }

    // END:VCALENDAR
    buffer.writeln('END:VCALENDAR');

    // Satırları katla (RFC standardı)
    return _foldLine(buffer.toString());
  }

  /// Tek bir etkinliği .ics formatına çevir
  String exportEventToICal(EventEntity event) {
    final buffer = StringBuffer();

    // BEGIN:VCALENDAR
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('PRODID:-//WorkSchedule//Calendar//TR');
    buffer.writeln('CALSCALE:GREGORIAN');
    buffer.writeln('METHOD:PUBLISH');

    // TIMEZONE
    buffer.writeln('BEGIN:VTIMEZONE');
    buffer.writeln('TZID:UTC');
    buffer.writeln('BEGIN:STANDARD');
    buffer.writeln('DTSTART:19700101T000000Z');
    buffer.writeln('TZOFFSETFROM:+0000');
    buffer.writeln('TZOFFSETTO:+0000');
    buffer.writeln('TZNAME:UTC');
    buffer.writeln('END:STANDARD');
    buffer.writeln('END:VTIMEZONE');

    // Etkinlik
    buffer.write(_eventToICal(event));

    // END:VCALENDAR
    buffer.writeln('END:VCALENDAR');

    return _foldLine(buffer.toString());
  }

  /// .ics dosyasını parse edip EventEntity listesine çevir
  Future<List<EventEntity>> importEventsFromICal(String icalContent) async {
    final events = <EventEntity>[];
    final lines = icalContent.split('\n');

    EventEntity? currentEvent;
    Map<String, dynamic>? currentEventData;
    bool inEvent = false;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // BEGIN:VEVENT
      if (line == 'BEGIN:VEVENT') {
        inEvent = true;
        currentEventData = {};
        continue;
      }

      // END:VEVENT
      if (line == 'END:VEVENT') {
        if (currentEventData != null) {
          currentEvent = _parseEventData(currentEventData);
          if (currentEvent != null) {
            events.add(currentEvent);
          }
        }
        inEvent = false;
        currentEventData = null;
        continue;
      }

      if (inEvent && currentEventData != null) {
        // Property:value formatını parse et
        final colonIndex = line.indexOf(':');
        if (colonIndex > 0) {
          final property = line.substring(0, colonIndex).split(';')[0];
          final value = line.substring(colonIndex + 1);

          switch (property) {
            case 'UID':
              currentEventData['id'] = value.split('@')[0];
              break;
            case 'DTSTART':
              currentEventData['startDate'] = _parseICalDateTime(line);
              currentEventData['isAllDay'] = line.contains('VALUE=DATE');
              break;
            case 'DTEND':
              currentEventData['endDate'] = _parseICalDateTime(line);
              break;
            case 'SUMMARY':
              currentEventData['title'] = _unescapeText(value);
              break;
            case 'DESCRIPTION':
              currentEventData['description'] = _unescapeText(value);
              break;
            case 'LOCATION':
              currentEventData['location'] = _unescapeText(value);
              break;
            case 'ATTENDEE':
              final attendees = currentEventData['attendees'] as List<String>? ?? [];
              // mailto:email formatından e-posta çıkar
              final email = value.contains('mailto:')
                  ? value.split('mailto:')[1].split(';')[0]
                  : value;
              attendees.add(email);
              currentEventData['attendees'] = attendees;
              break;
          }
        }
      }
    }

    return events;
  }

  /// .ics dosyasından tek bir etkinlik parse et
  Future<EventEntity?> importEventFromICal(String icalContent) async {
    final events = await importEventsFromICal(icalContent);
    return events.isNotEmpty ? events.first : null;
  }

  /// iCalendar DateTime formatını parse et
  DateTime _parseICalDateTime(String line) {
    try {
      // VALUE=DATE formatı (tüm günlük etkinlikler)
      if (line.contains('VALUE=DATE')) {
        final dateStr = line.split(':')[1];
        if (dateStr.length == 8) {
          // YYYYMMDD formatı
          final year = int.parse(dateStr.substring(0, 4));
          final month = int.parse(dateStr.substring(4, 6));
          final day = int.parse(dateStr.substring(6, 8));
          return DateTime.utc(year, month, day);
        }
      }

      // Normal DateTime formatı (YYYYMMDDTHHmmssZ)
      final dateStr = line.split(':')[1];
      if (dateStr.length >= 15) {
        final year = int.parse(dateStr.substring(0, 4));
        final month = int.parse(dateStr.substring(4, 6));
        final day = int.parse(dateStr.substring(6, 8));
        final hour = int.parse(dateStr.substring(9, 11));
        final minute = int.parse(dateStr.substring(11, 13));
        final second = dateStr.length >= 15 ? int.parse(dateStr.substring(13, 15)) : 0;

        if (dateStr.endsWith('Z')) {
          return DateTime.utc(year, month, day, hour, minute, second);
        } else {
          return DateTime(year, month, day, hour, minute, second);
        }
      }
    } catch (e) {
      // Hata durumunda şu anki zamanı döndür
    }
    return DateTime.now();
  }

  /// Parse edilen event data'dan EventEntity oluştur
  EventEntity? _parseEventData(Map<String, dynamic> data) {
    try {
      return EventEntity(
        id: data['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: data['title'] as String? ?? 'İçe Aktarılan Etkinlik',
        description: data['description'] as String?,
        startDate: data['startDate'] as DateTime? ?? DateTime.now(),
        endDate: data['endDate'] as DateTime? ?? DateTime.now(),
        isAllDay: data['isAllDay'] as bool? ?? false,
        location: data['location'] as String?,
        attendees: data['attendees'] as List<String>? ?? [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Escape edilmiş metni geri çevir
  String _unescapeText(String text) {
    return text
        .replaceAll('\\n', '\n')
        .replaceAll('\\,', ',')
        .replaceAll('\\;', ';')
        .replaceAll('\\\\', '\\');
  }

  /// .ics içeriğini dosyaya kaydet
  Future<File> saveICalToFile(String icalContent, String fileName) async {
    final directory = await _getDocumentsDirectory();
    final file = File('${directory.path}/$fileName.ics');
    await file.writeAsString(icalContent);
    return file;
  }

  /// .ics dosyasını oku
  Future<String> readICalFromFile(File file) async {
    return await file.readAsString();
  }

  /// Documents directory'yi al
  Future<Directory> _getDocumentsDirectory() async {
    // path_provider kullanarak documents directory al
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }
}

