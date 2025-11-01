import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/icalendar_service.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/services/timezone_service.dart';
import '../../../../domain/entities/event_entity.dart';
import 'events/share_calendar_event.dart';
import 'states/share_calendar_state.dart';

/// Paylaşım BLoC - Takvim ve etkinlik paylaşımını yönetir
class ShareCalendarBloc extends Bloc<ShareCalendarEvent, ShareCalendarState> {
  final ICalendarService _icalService;
  final ShareService _shareService;
  final TimezoneService _timezoneService;

  ShareCalendarBloc({
    ICalendarService? icalService,
    ShareService? shareService,
    TimezoneService? timezoneService,
  })  : _icalService = icalService ?? ICalendarService(),
        _shareService = shareService ?? ShareService(),
        _timezoneService = timezoneService ?? TimezoneService(),
        super(const ShareCalendarInitial()) {
    on<ShareSingleEventEvent>(_onShareSingleEvent);
    on<ShareAllEventsEvent>(_onShareAllEvents);
    on<ImportICalFileEvent>(_onImportICalFile);
    on<SelectShareMethodEvent>(_onSelectShareMethod);
    on<CheckTimezoneDifferenceEvent>(_onCheckTimezoneDifference);
  }

  /// Tek bir etkinliği paylaş
  Future<void> _onShareSingleEvent(
    ShareSingleEventEvent event,
    Emitter<ShareCalendarState> emit,
  ) async {
    emit(const ShareCalendarLoading());

    try {
      // Cihazın zaman dilimini al
      final sourceTimezone = await _timezoneService.getLocalTimezone();
      String? timezoneWarning;

      // Zaman dilimi dönüşümü gerekli mi kontrol et
      EventEntity eventToShare = event.event;

      if (event.targetTimezone != null &&
          event.targetTimezone != sourceTimezone) {
        // Alıcının zaman dilimine göre ayarla
        final adjustedStartDate = await _timezoneService.convertUTCToTimezone(
          event.event.startDate.toUtc(),
          event.targetTimezone!,
        );
        final adjustedEndDate = await _timezoneService.convertUTCToTimezone(
          event.event.endDate.toUtc(),
          event.targetTimezone!,
        );

        // Uyarı mesajı oluştur
        timezoneWarning = await _timezoneService.getTimezoneChangeWarningMessage(
          event.event.startDate,
          sourceTimezone,
          event.targetTimezone!,
        );

        // Etkinliği yeni zaman dilimine göre güncelle
        eventToShare = event.event.copyWith(
          startDate: adjustedStartDate,
          endDate: adjustedEndDate,
        );
      }

      // .ics formatına çevir
      final icalContent = _icalService.exportEventToICal(eventToShare);

      emit(ICalContentReady(
        icalContent: icalContent,
        fileName: 'event_${event.event.id}',
        timezoneWarning: timezoneWarning,
      ));

      // Otomatik paylaş
      await _shareService.shareICalContent(
        icalContent,
        subject: eventToShare.title,
        text: 'Etkinlik: ${eventToShare.title}',
        fileName: 'event_${event.event.id}.ics',
      );

      emit(ShareCalendarSuccess(
        method: ShareMethod.file,
        message: 'Etkinlik başarıyla paylaşıldı',
      ));
    } catch (e) {
      emit(ShareCalendarError(
        message: 'Paylaşım hatası: ${e.toString()}',
        errorCode: 'SHARE_ERROR',
      ));
    }
  }

  /// Tüm etkinlikleri paylaş
  Future<void> _onShareAllEvents(
    ShareAllEventsEvent event,
    Emitter<ShareCalendarState> emit,
  ) async {
    emit(const ShareCalendarLoading());

    try {
      // Cihazın zaman dilimini al
      final sourceTimezone = await _timezoneService.getLocalTimezone();
      String? timezoneWarning;
      List<EventEntity> eventsToShare = event.events;

      // Zaman dilimi dönüşümü
      if (event.targetTimezone != null &&
          event.targetTimezone != sourceTimezone) {
        final adjustedEvents = <EventEntity>[];

        for (final evt in event.events) {
          final adjustedStartDate =
              await _timezoneService.convertUTCToTimezone(
            evt.startDate.toUtc(),
            event.targetTimezone!,
          );
          final adjustedEndDate =
              await _timezoneService.convertUTCToTimezone(
            evt.endDate.toUtc(),
            event.targetTimezone!,
          );

          adjustedEvents.add(evt.copyWith(
            startDate: adjustedStartDate,
            endDate: adjustedEndDate,
          ));
        }

        eventsToShare = adjustedEvents;

        // Uyarı mesajı
        if (eventsToShare.isNotEmpty) {
          timezoneWarning = await _timezoneService.getTimezoneChangeWarningMessage(
            eventsToShare.first.startDate,
            sourceTimezone,
            event.targetTimezone!,
          );
          timezoneWarning =
              '$timezoneWarning\n\n${eventsToShare.length} etkinlik zaman dilimine göre ayarlandı.';
        }
      }

      // .ics formatına çevir
      final icalContent = _icalService.exportEventsToICal(
        eventsToShare,
        calendarName: event.calendarName ?? 'WorkSchedule Takvimi',
      );

      emit(ICalContentReady(
        icalContent: icalContent,
        fileName: 'calendar_${DateTime.now().millisecondsSinceEpoch}',
        timezoneWarning: timezoneWarning,
      ));

      // Otomatik paylaş
      await _shareService.shareICalContent(
        icalContent,
        subject: event.calendarName ?? 'Takvim Paylaşımı',
        text: 'İşte tüm takviminiz',
        fileName: 'calendar_${DateTime.now().millisecondsSinceEpoch}.ics',
      );

      emit(ShareCalendarSuccess(
        method: ShareMethod.file,
        message: '${eventsToShare.length} etkinlik başarıyla paylaşıldı',
      ));
    } catch (e) {
      emit(ShareCalendarError(
        message: 'Paylaşım hatası: ${e.toString()}',
        errorCode: 'SHARE_ERROR',
      ));
    }
  }

  /// .ics dosyasını içe aktar
  Future<void> _onImportICalFile(
    ImportICalFileEvent event,
    Emitter<ShareCalendarState> emit,
  ) async {
    emit(const ShareCalendarLoading());

    try {
      // .ics dosyasını parse et
      final importedEvents = await _icalService.importEventsFromICal(
        event.icalContent,
      );

      String? timezoneWarning;

      // Zaman dilimi dönüşümü gerekli mi?
      if (event.sourceTimezone != null && importedEvents.isNotEmpty) {
        final localTimezone = await _timezoneService.getLocalTimezone();

        if (event.sourceTimezone != localTimezone) {
          // Gönderenin zaman diliminden yerel zaman dilimine çevir
          final adjustedEvents = <EventEntity>[];

          for (final evt in importedEvents) {
            final adjustedStartDate =
                await _timezoneService.convertToTimezone(
              evt.startDate,
              localTimezone,
            );
            final adjustedEndDate = await _timezoneService.convertToTimezone(
              evt.endDate,
              localTimezone,
            );

            adjustedEvents.add(evt.copyWith(
              startDate: adjustedStartDate,
              endDate: adjustedEndDate,
            ));
          }

          timezoneWarning =
              '${importedEvents.length} etkinlik zaman diliminize göre ayarlandı.';

          emit(ImportCalendarSuccess(
            importedEvents: adjustedEvents,
            timezoneWarning: timezoneWarning,
          ));
          return;
        }
      }

      emit(ImportCalendarSuccess(
        importedEvents: importedEvents,
        timezoneWarning: timezoneWarning,
      ));
    } catch (e) {
      emit(ShareCalendarError(
        message: 'İçe aktarma hatası: ${e.toString()}',
        errorCode: 'IMPORT_ERROR',
      ));
    }
  }

  /// Paylaşım metodunu seç
  Future<void> _onSelectShareMethod(
    SelectShareMethodEvent event,
    Emitter<ShareCalendarState> emit,
  ) async {
    // Bu event şu an için sadece state'i günceller
    // Gerçek paylaşım ShareService üzerinden yapılıyor
    emit(const ShareCalendarInitial());
  }

  /// Zaman dilimi farkını kontrol et
  Future<void> _onCheckTimezoneDifference(
    CheckTimezoneDifferenceEvent event,
    Emitter<ShareCalendarState> emit,
  ) async {
    try {
      final diffHours = await _timezoneService.getTimezoneDifferenceHours(
        event.sourceTimezone,
        event.targetTimezone,
      );
      final diffMinutes = await _timezoneService.getTimezoneDifferenceMinutes(
        event.sourceTimezone,
        event.targetTimezone,
      );

      final warningMessage =
          await _timezoneService.getTimezoneChangeWarningMessage(
        event.eventTime,
        event.sourceTimezone,
        event.targetTimezone,
      );

      final adjustedTime = await _timezoneService.adjustEventTimeForReceiver(
        event.eventTime,
        event.sourceTimezone,
        event.targetTimezone,
      );

      emit(TimezoneDifferenceChecked(
        differenceHours: diffHours,
        differenceMinutes: diffMinutes,
        warningMessage: warningMessage,
        originalTime: event.eventTime,
        adjustedTime: adjustedTime,
      ));
    } catch (e) {
      emit(ShareCalendarError(
        message: 'Zaman dilimi kontrol hatası: ${e.toString()}',
        errorCode: 'TIMEZONE_ERROR',
      ));
    }
  }
}

