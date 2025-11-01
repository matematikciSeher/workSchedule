import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/event_entity.dart';
import '../bloc/share_calendar_bloc.dart';
import '../bloc/events/share_calendar_event.dart';
import '../bloc/states/share_calendar_state.dart';
import '../widgets/share_event_dialog.dart';
import '../widgets/share_calendar_dialog.dart';
import '../widgets/import_calendar_dialog.dart';

/// Paylaşım özelliklerinin kullanım örnekleri
class ShareCalendarExample extends StatelessWidget {
  const ShareCalendarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takvim Paylaşım Örnekleri'),
      ),
      body: BlocListener<ShareCalendarBloc, ShareCalendarState>(
        listener: (context, state) {
          if (state is ShareCalendarSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ShareCalendarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ImportCalendarSuccess) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('İçe Aktarma Başarılı'),
                content: Text(
                  '${state.importedEvents.length} etkinlik başarıyla içe aktarıldı.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Tamam'),
                  ),
                ],
              ),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Örnek etkinlik
            _buildExampleEventCard(context),
            const SizedBox(height: 16),
            // Paylaşım butonları
            _buildShareButtons(context),
            const SizedBox(height: 16),
            // İçe aktarma butonu
            _buildImportButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleEventCard(BuildContext context) {
    final exampleEvent = EventEntity(
      id: 'example-1',
      title: 'Örnek Toplantı',
      description: 'Bu bir örnek etkinliktir',
      startDate: DateTime.now().add(const Duration(hours: 2)),
      endDate: DateTime.now().add(const Duration(hours: 3)),
      location: 'İstanbul, Türkiye',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exampleEvent.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (exampleEvent.description != null)
              Text(exampleEvent.description!),
            const SizedBox(height: 8),
            Text(
              'Başlangıç: ${exampleEvent.startDate.toString()}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButtons(BuildContext context) {
    final exampleEvent = EventEntity(
      id: 'example-1',
      title: 'Örnek Toplantı',
      description: 'Bu bir örnek etkinliktir',
      startDate: DateTime.now().add(const Duration(hours: 2)),
      endDate: DateTime.now().add(const Duration(hours: 3)),
      location: 'İstanbul, Türkiye',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final exampleEvents = [
      exampleEvent,
      exampleEvent.copyWith(
        id: 'example-2',
        title: 'Başka Bir Toplantı',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 1, hours: 1)),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ShareEventDialog(
                event: exampleEvent,
              ),
            );
          },
          icon: const Icon(Icons.share),
          label: const Text('Tek Etkinlik Paylaş'),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ShareCalendarDialog(
                events: exampleEvents,
                calendarName: 'Örnek Takvim',
              ),
            );
          },
          icon: const Icon(Icons.calendar_today),
          label: const Text('Tüm Takvimi Paylaş'),
        ),
      ],
    );
  }

  Widget _buildImportButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const ImportCalendarDialog(),
        );
      },
      icon: const Icon(Icons.upload_file),
      label: const Text('Takvim İçe Aktar'),
    );
  }
}

/// Programatik kullanım örneği
class ProgrammaticShareExample {
  final ShareCalendarBloc shareBloc;

  ProgrammaticShareExample(this.shareBloc);

  /// Tek etkinlik paylaş
  Future<void> shareEvent(EventEntity event, {String? targetTimezone}) async {
    shareBloc.add(
      ShareSingleEventEvent(
        event: event,
        targetTimezone: targetTimezone,
      ),
    );
  }

  /// Tüm takvimi paylaş
  Future<void> shareCalendar(
    List<EventEntity> events, {
    String? calendarName,
    String? targetTimezone,
  }) async {
    shareBloc.add(
      ShareAllEventsEvent(
        events: events,
        calendarName: calendarName,
        targetTimezone: targetTimezone,
      ),
    );
  }

  /// .ics içeriğini içe aktar
  Future<void> importICal(String icalContent, {String? sourceTimezone}) async {
    shareBloc.add(
      ImportICalFileEvent(
        icalContent: icalContent,
        sourceTimezone: sourceTimezone,
      ),
    );
  }

  /// Zaman dilimi farkını kontrol et
  Future<void> checkTimezoneDifference(
    DateTime eventTime,
    String sourceTimezone,
    String targetTimezone,
  ) async {
    shareBloc.add(
      CheckTimezoneDifferenceEvent(
        eventTime: eventTime,
        sourceTimezone: sourceTimezone,
        targetTimezone: targetTimezone,
      ),
    );
  }
}

