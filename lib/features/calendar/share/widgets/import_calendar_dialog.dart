import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/services/icalendar_service.dart';
import '../../../../core/services/timezone_service.dart';
import '../bloc/share_calendar_bloc.dart';
import '../bloc/events/share_calendar_event.dart';
import '../bloc/states/share_calendar_state.dart';

/// Takvim içe aktarma dialog'u
class ImportCalendarDialog extends StatefulWidget {
  const ImportCalendarDialog({super.key});

  @override
  State<ImportCalendarDialog> createState() => _ImportCalendarDialogState();
}

class _ImportCalendarDialogState extends State<ImportCalendarDialog> {
  final ICalendarService _icalService = ICalendarService();
  String? _selectedSourceTimezone;
  final List<String> _availableTimezones = [
    'Europe/Istanbul',
    'Europe/Berlin',
    'Europe/London',
    'America/New_York',
    'America/Los_Angeles',
    'Asia/Tokyo',
    'UTC',
  ];

  Future<void> _pickFileAndImport(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ics'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final icalContent = await _icalService.readICalFromFile(
          await _getFileFromPath(filePath),
        );

        // BLoC'a import event'i gönder
        context.read<ShareCalendarBloc>().add(
              ImportICalFileEvent(
                icalContent: icalContent,
                sourceTimezone: _selectedSourceTimezone,
              ),
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dosya seçim hatası: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<io.File> _getFileFromPath(String path) async {
    return io.File(path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareCalendarBloc, ShareCalendarState>(
      listener: (context, state) {
        if (state is ImportCalendarSuccess) {
          Navigator.of(context).pop();
          
          final message = state.importedEvents.isNotEmpty
              ? '${state.importedEvents.length} etkinlik başarıyla içe aktarıldı!'
              : 'Etkinlik içe aktarılamadı.';

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('İçe Aktarma Başarılı'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                  if (state.timezoneWarning != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info, color: Colors.blue[800], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.timezoneWarning!,
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tamam'),
                ),
              ],
            ),
          );
        } else if (state is ShareCalendarError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
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
                'Takvim İçe Aktar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '.ics formatında bir takvim dosyası seçin',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kaynak Zaman Dilimi (Opsiyonel)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSourceTimezone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Gönderenin zaman dilimi',
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Otomatik Tespit'),
                  ),
                  ..._availableTimezones.map((tz) {
                    final displayName =
                        TimezoneService.popularTimezones[tz] ?? tz;
                    return DropdownMenuItem(
                      value: tz,
                      child: Text(displayName),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSourceTimezone = value;
                  });
                },
              ),
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
                      ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _pickFileAndImport(context),
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.upload_file),
                        label: const Text('Dosya Seç'),
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
}

