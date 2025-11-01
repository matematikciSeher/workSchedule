import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/event_entity.dart';
import '../../../../core/services/timezone_service.dart';
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
        _timezoneWarningMessage =
            '$warningMessage\n\n${widget.events.length} etkinlik zaman dilimine göre ayarlanacak.';
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
              const Text(
                'Takvimi Paylaş',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.events.length} etkinlik paylaşılacak',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              if (widget.calendarName != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Takvim: ${widget.calendarName}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'Alıcının Zaman Dilimi (Opsiyonel)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTimezone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Zaman dilimi seçin',
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
                        child: const Text('İptal'),
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
                            : const Text('Paylaş'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Zaman Dilimi Uyarısı'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}

