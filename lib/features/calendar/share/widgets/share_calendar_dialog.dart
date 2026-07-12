import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/event_entity.dart';
import '../../../../core/services/timezone_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/share_calendar_bloc.dart';
import '../bloc/events/share_calendar_event.dart';
import '../bloc/states/share_calendar_state.dart';

/// Tüm takvimi paylaşma dialog'u
class ShareCalendarDialog extends StatefulWidget {
  final List<EventEntity> events;
  final String? calendarName;

  const ShareCalendarDialog({
    super.key,
    required this.events,
    this.calendarName,
  });

  @override
  State<ShareCalendarDialog> createState() => _ShareCalendarDialogState();
}

class _ShareCalendarDialogState extends State<ShareCalendarDialog> {
  String? _selectedTimezone;
  final List<String> _availableTimezones = [
    'Europe/Istanbul',
    'Europe/Berlin',
    'Europe/London',
    'America/New_York',
    'America/Los_Angeles',
    'Asia/Tokyo',
    'UTC',
  ];
  bool _showTimezoneWarning = false;
  String? _timezoneWarningMessage;

  @override
  void initState() {
    super.initState();
    _loadLocalTimezone();
  }

  Future<void> _loadLocalTimezone() async {
    final timezoneService = TimezoneService();
    final localTimezone = await timezoneService.getLocalTimezone();
    setState(() {
      _selectedTimezone = localTimezone;
    });
    _checkTimezoneDifference();
  }

  Future<void> _checkTimezoneDifference() async {
    if (_selectedTimezone == null || widget.events.isEmpty) return;

    final timezoneService = TimezoneService();
    final localTimezone = await timezoneService.getLocalTimezone();

    if (_selectedTimezone != localTimezone) {
      final firstEvent = widget.events.first;
      final warningMessage =
          await timezoneService.getTimezoneChangeWarningMessage(
        firstEvent.startDate,
        localTimezone,
        _selectedTimezone!,
      );

      setState(() {
        _timezoneWarningMessage = AppLocalizations.of(context)!
            .eventsTimezoneAdjustWarning(warningMessage, widget.events.length);
        _showTimezoneWarning = true;
      });
    } else {
      setState(() {
        _showTimezoneWarning = false;
        _timezoneWarningMessage = null;
      });
    }
  }

  Future<void> _shareCalendar(BuildContext context) async {
    context.read<ShareCalendarBloc>().add(
          ShareAllEventsEvent(
            events: widget.events,
            calendarName: widget.calendarName,
            targetTimezone: _selectedTimezone,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ShareCalendarBloc, ShareCalendarState>(
      listener: (context, state) {
        if (state is ShareCalendarSuccess) {
          Navigator.of(context).pop();
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
        } else if (state is ICalContentReady && state.timezoneWarning != null) {
          _showTimezoneWarningDialog(context, state.timezoneWarning!);
        }
      },
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.shareCalendar,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.eventsWillBeShared(widget.events.length),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              if (widget.calendarName != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.calendarNameLabel(widget.calendarName!),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                l10n.recipientTimezoneOptional,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTimezone,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l10n.selectTimezone,
                ),
                items: _availableTimezones.map((tz) {
                  final displayName =
                      TimezoneService.popularTimezones[tz] ?? tz;
                  return DropdownMenuItem(
                    value: tz,
                    child: Text(displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTimezone = value;
                  });
                  _checkTimezoneDifference();
                },
              ),
              if (_showTimezoneWarning && _timezoneWarningMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning, color: Colors.orange[800]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _timezoneWarningMessage!,
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              BlocBuilder<ShareCalendarBloc, ShareCalendarState>(
                builder: (context, state) {
                  final isLoading = state is ShareCalendarLoading;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _shareCalendar(context),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.share),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimezoneWarningDialog(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.timezoneWarning),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
