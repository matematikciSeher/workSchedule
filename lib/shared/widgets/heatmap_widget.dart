import 'package:flutter/material.dart';

/// GitHub contributions graph benzeri ısı haritası widget'ı
/// Yıllık etkinlik yoğunluğunu görselleştirir
class HeatmapWidget extends StatelessWidget {
  final int year;
  final Map<DateTime, int> eventCounts; // Tarih -> etkinlik sayısı
  final Function(DateTime)? onDayTap;
  final double cellSize;
  final double spacing;

  const HeatmapWidget({
    super.key,
    required this.year,
    required this.eventCounts,
    this.onDayTap,
    this.cellSize = 12.0,
    this.spacing = 3.0,
  });

  /// Günün yoğunluğuna göre renk döndürür
  Color _getIntensityColor(int count, int maxCount) {
    if (count == 0) return Colors.grey[200]!;
    
    // Yoğunluk seviyeleri (0-4 arası)
    final intensity = (count / (maxCount / 4)).clamp(0.0, 4.0).floor();
    
    switch (intensity) {
      case 0:
        return Colors.blue[100]!; // Çok az
      case 1:
        return Colors.blue[300]!; // Az
      case 2:
        return Colors.blue[500]!; // Orta
      case 3:
        return Colors.blue[700]!; // Yoğun
      default:
        return Colors.blue[900]!; // Çok yoğun
    }
  }

  /// Yılın tüm günlerini oluşturur (hafta bazında organize edilmiş)
  List<List<DateTime?>> _generateYearDays() {
    final days = <List<DateTime?>>[];
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);
    
    // İlk günün haftanın hangi günü olduğunu bul (0=Pazar, 1=Pazartesi, ...)
    int firstDayOfWeek = startDate.weekday % 7; // Pazartesi=0, Pazar=6
    
    // İlk hafta için boş günler ekle
    final firstWeek = <DateTime?>[];
    for (int i = 0; i < firstDayOfWeek; i++) {
      firstWeek.add(null);
    }
    
    // Yılın tüm günlerini ekle
    DateTime currentDate = startDate;
    
    while (currentDate.isBefore(endDate) || 
           currentDate.isAtSameMomentAs(endDate)) {
      if (firstWeek.length == 7) {
        days.add(List.from(firstWeek));
        firstWeek.clear();
      }
      
      firstWeek.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    // Son haftayı tamamla
    while (firstWeek.length < 7) {
      firstWeek.add(null);
    }
    if (firstWeek.any((day) => day != null)) {
      days.add(firstWeek);
    }
    
    return days;
  }

  /// Ay etiketleri için hafta pozisyonlarını hesaplar
  Map<int, int> _getMonthPositions() {
    final monthPositions = <int, int>{};
    final startDate = DateTime(year, 1, 1);
    
    for (int month = 1; month <= 12; month++) {
      final monthStart = DateTime(year, month, 1);
      final daysDiff = monthStart.difference(startDate).inDays;
      final firstDayOfWeek = startDate.weekday % 7;
      final weekPosition = ((daysDiff + firstDayOfWeek) / 7).floor();
      
      if (!monthPositions.containsKey(month)) {
        monthPositions[month] = weekPosition;
      }
    }
    
    return monthPositions;
  }

  @override
  Widget build(BuildContext context) {
    final yearDays = _generateYearDays();
    final maxCount = eventCounts.values.isEmpty 
        ? 1 
        : eventCounts.values.reduce((a, b) => a > b ? a : b);
    final monthPositions = _getMonthPositions();
    
    final monthNames = [
      'Oc', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
    ];
    
    final dayNames = ['Pzt', 'Çar', 'Cum', 'Paz'];
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık ve açıklama
          Text(
            '$year Yılı - Etkinlik Yoğunluğu',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Günlük etkinlik sayısına göre renklendirilmiş yıllık takvim',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Isı haritası
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gün etiketleri (solda)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20), // Ay etiketleri için boşluk
                    ...dayNames.asMap().entries.map((entry) {
                      return Container(
                        width: 40,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(width: 8),
                
                // Ana ısı haritası
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ay etiketleri (üstte)
                    SizedBox(
                      height: 20,
                      width: (cellSize + spacing) * yearDays.length.toDouble(),
                      child: Stack(
                        children: monthNames.asMap().entries.map((entry) {
                          final month = entry.key + 1;
                          final position = monthPositions[month] ?? 0;
                          return Positioned(
                            left: position * (cellSize + spacing),
                            child: Text(
                              entry.value,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Gün kareleri
                    ...yearDays.map((week) {
                      return Row(
                        children: week.map((day) {
                          if (day == null) {
                            return SizedBox(
                              width: cellSize,
                              height: cellSize,
                            );
                          }
                          
                          // Tarihi normalize et (sadece tarih kısmı)
                          final normalizedDate = DateTime(day.year, day.month, day.day);
                          final count = eventCounts[normalizedDate] ?? 0;
                          final color = _getIntensityColor(count, maxCount);
                          
                          return GestureDetector(
                            onTap: onDayTap != null 
                                ? () => onDayTap!(normalizedDate)
                                : null,
                            child: Tooltip(
                              message: '${day.day}/${day.month}/${day.year}\n'
                                      '$count etkinlik',
                              child: Container(
                                width: cellSize,
                                height: cellSize,
                                margin: EdgeInsets.all(spacing / 2),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Renk legend (açıklama)
          Row(
            children: [
              Text(
                'Az',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              _buildLegendItem(Colors.blue[100]!),
              _buildLegendItem(Colors.blue[300]!),
              _buildLegendItem(Colors.blue[500]!),
              _buildLegendItem(Colors.blue[700]!),
              _buildLegendItem(Colors.blue[900]!),
              const SizedBox(width: 8),
              Text(
                'Çok',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color) {
    return Container(
      width: cellSize,
      height: cellSize,
      margin: EdgeInsets.all(spacing / 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 0.5,
        ),
      ),
    );
  }
}

