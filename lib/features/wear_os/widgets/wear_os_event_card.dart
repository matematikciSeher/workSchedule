import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/wear_os_models.dart';

/// Wear OS için etkinlik kartı
class WearOsEventCard extends StatelessWidget {
  final WearOsEvent event;
  final bool isCompact;

  const WearOsEventCard({
    super.key,
    required this.event,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('HH:mm');
    final isNowOrPassed = event.startDate.isBefore(DateTime.now());

    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNowOrPassed ? Colors.red : Colors.blue,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!event.isAllDay)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isNowOrPassed ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    timeFormatter.format(event.startDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          if (!isCompact) ...[
            const SizedBox(height: 8),

            // Lokasyon
            if (event.location != null) ...[
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],

            // Tarih bilgisi
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text(
                  event.isAllDay
                      ? 'Tüm Gün'
                      : '${timeFormatter.format(event.startDate)} - ${timeFormatter.format(event.endDate)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
