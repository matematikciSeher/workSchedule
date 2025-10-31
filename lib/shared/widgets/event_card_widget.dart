import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Etkinlik kartı widget'ı
/// Modern tasarım, animasyonlar ve interaktif özellikler içerir
class EventCard extends StatefulWidget {
  /// Etkinlik başlığı
  final String title;
  
  /// Etkinlik tarihi ve saati
  final DateTime dateTime;
  
  /// Kategori simgesi
  final IconData categoryIcon;
  
  /// Renk etiketi (hex color)
  final String colorLabel;
  
  /// Kart'a tıklandığında çağrılacak callback
  final VoidCallback? onTap;
  
  /// Kart'a uzun basıldığında çağrılacak callback
  final VoidCallback? onLongPress;
  
  /// Kart'ın açıklaması (isteğe bağlı)
  final String? description;
  
  /// Kartın yüksekliği
  final double? height;

  const EventCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.categoryIcon,
    required this.colorLabel,
    this.onTap,
    this.onLongPress,
    this.description,
    this.height,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Animasyon controller'ı
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    // Scale animasyonu (tap efekti için)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Elevation animasyonu (hover efekti için)
    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Renk string'ini Color'a çevir
  Color _parseColor(String colorString) {
    try {
      // Hex color formatını temizle (# işareti varsa kaldır)
      String cleanColor = colorString.replaceAll('#', '');
      
      // 6 karakterli hex color
      if (cleanColor.length == 6) {
        return Color(int.parse('FF$cleanColor', radix: 16));
      }
      // 8 karakterli hex color (alpha dahil)
      else if (cleanColor.length == 8) {
        return Color(int.parse(cleanColor, radix: 16));
      }
    } catch (e) {
      // Parse hatası durumunda varsayılan renk kullan
      return AppColors.lightPrimary;
    }
    return AppColors.lightPrimary;
  }

  /// Tarih ve saat formatla
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    String dateStr;
    
    // Bugün mü kontrolü
    if (eventDate == today) {
      dateStr = 'Bugün';
    }
    // Yarın mı kontrolü
    else if (eventDate == today.add(const Duration(days: 1))) {
      dateStr = 'Yarın';
    }
    // Geçmiş tarihler için
    else if (eventDate.isBefore(today)) {
      final difference = today.difference(eventDate).inDays;
      if (difference == 1) {
        dateStr = 'Dün';
      } else {
        dateStr = '${difference} gün önce';
      }
    }
    // Gelecek tarihler için
    else {
      final difference = eventDate.difference(today).inDays;
      if (difference <= 7) {
        dateStr = '$difference gün sonra';
      } else {
        // Tarih formatla (ör: 15 Ocak 2024)
        dateStr = '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
      }
    }
    
    // Saat ekle
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$dateStr, $hour:$minute';
  }

  /// Ay ismini getir
  String _getMonthName(int month) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return months[month - 1];
  }

  /// Basılıyor animasyonu
  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  /// Basma bitti animasyonu
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap?.call();
  }

  /// Basma iptal animasyonu
  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: widget.height ?? 100,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? _parseColor(widget.colorLabel).withOpacity(0.3)
                        : (isDark ? AppColors.shadowDark : AppColors.shadowLight),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Sol tarafta renk etiketi çubuğu
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 6,
                          decoration: BoxDecoration(
                            color: _parseColor(widget.colorLabel),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      
                      // İçerik alanı
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Kategori simgesi
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _parseColor(widget.colorLabel)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                widget.categoryIcon,
                                color: _parseColor(widget.colorLabel),
                                size: 26,
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Metin içerikleri
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Başlık
                                  Text(
                                    widget.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.lightOnSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                  const SizedBox(height: 4),
                                  
                                  // Tarih/Saat
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: isDark
                                            ? AppColors.darkOnSurface.withOpacity(0.6)
                                            : AppColors.lightOnSurface.withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDateTime(widget.dateTime),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: isDark
                                              ? AppColors.darkOnSurface.withOpacity(0.6)
                                              : AppColors.lightOnSurface.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  // Açıklama varsa göster
                                  if (widget.description != null && widget.description!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.description!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: isDark
                                            ? AppColors.darkOnSurface.withOpacity(0.5)
                                            : AppColors.lightOnSurface.withOpacity(0.5),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Etkinlik kartı için örnek kullanım widget'ı
class EventCardExample extends StatelessWidget {
  const EventCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Kartı Örnekleri'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EventCard(
            title: 'Ekip Toplantısı',
            dateTime: DateTime.now(),
            categoryIcon: Icons.groups,
            colorLabel: 'FF2196F3',
            description: 'Aylık değerlendirme toplantısı',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ekip Toplantısı kartına tıklandı')),
              );
            },
          ),
          
          EventCard(
            title: 'Proje Sunumu',
            dateTime: DateTime.now().add(const Duration(days: 2)),
            categoryIcon: Icons.present_to_all,
            colorLabel: 'FFFF5722',
            description: 'Müşteri sunumu hazırlığı',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proje Sunumu kartına tıklandı')),
              );
            },
          ),
          
          EventCard(
            title: 'Ders Çalışma',
            dateTime: DateTime.now().subtract(const Duration(days: 1)),
            categoryIcon: Icons.school,
            colorLabel: 'FF4CAF50',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ders Çalışma kartına tıklandı')),
              );
            },
          ),
          
          EventCard(
            title: 'Randevu',
            dateTime: DateTime.now().add(const Duration(days: 5)),
            categoryIcon: Icons.event,
            colorLabel: 'FF9C27B0',
            description: 'Doktor randevusu',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Randevu kartına tıklandı')),
              );
            },
          ),
          
          EventCard(
            title: 'Alışveriş',
            dateTime: DateTime.now().add(const Duration(hours: 3)),
            categoryIcon: Icons.shopping_cart,
            colorLabel: 'FFFF9800',
            description: 'Market alışverişi yapılacak',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alışveriş kartına tıklandı')),
              );
            },
          ),
        ],
      ),
    );
  }
}

