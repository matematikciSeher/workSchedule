import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Dekoratif animasyonlu arka plan widget'ı
/// Sayfaların zeminini süslemek için animasyonlu gradient ve dekoratif şekiller içerir
class DecorativeBackground extends StatefulWidget {
  final Widget child;
  final bool showDecorations;
  final BackgroundStyle style;

  const DecorativeBackground({
    super.key,
    required this.child,
    this.showDecorations = true,
    this.style = BackgroundStyle.elegant,
  });

  @override
  State<DecorativeBackground> createState() => _DecorativeBackgroundState();
}

enum BackgroundStyle {
  elegant, // Şık - açık pastel tonlar
  vibrant, // Canlı - daha parlak tonlar
  calm, // Sakin - yumuşak tonlar
  modern, // Modern - kontrastlı tonlar
}

class _DecorativeBackgroundState extends State<DecorativeBackground>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animasyonu (nefes alma efekti)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Rotate animasyonu (döndürme)
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Scale animasyonu (büyüme-küçülme)
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // Fade animasyonu (fade in/out)
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Şık renk paletleri (beyaz dışında)
    final colors = _getBackgroundColors(theme, isDark);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _rotateController,
        _scaleController,
        _fadeController,
      ]),
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Animasyonlu dekoratif şekiller
              if (widget.showDecorations)
                ..._buildAnimatedDecorations(context, theme, isDark),
              // Ana içerik
              widget.child,
            ],
          ),
        );
      },
    );
  }

  List<Color> _getBackgroundColors(ThemeData theme, bool isDark) {
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final tertiary = theme.colorScheme.tertiary;

    switch (widget.style) {
      case BackgroundStyle.elegant:
        // Şık pastel tonlar - bej, açık mavi, açık mor
        if (isDark) {
          return [
            const Color(0xFF1A1B26), // Koyu lacivert
            const Color(0xFF2D2E3F), // Orta gri-mor
            const Color(0xFF1F2135), // Koyu mor-mavi
          ];
        } else {
          return [
            Color.lerp(primary, Colors.white, 0.85) ?? const Color(0xFFF8F6FF), // Açık mor-beyaz
            Color.lerp(secondary, Colors.white, 0.90) ?? const Color(0xFFFAF9FE), // Açık mavi-beyaz
            Color.lerp(tertiary, Colors.white, 0.88) ?? const Color(0xFFF9F7FF), // Açık cyan-beyaz
          ];
        }

      case BackgroundStyle.vibrant:
        // Canlı tonlar
        if (isDark) {
          return [
            primary.withOpacity(0.15),
            secondary.withOpacity(0.12),
            tertiary.withOpacity(0.18),
          ];
        } else {
          return [
            Color.lerp(primary, Colors.white, 0.75) ?? const Color(0xFFE8F4FD),
            Color.lerp(secondary, Colors.white, 0.80) ?? const Color(0xFFE8F9FC),
            Color.lerp(tertiary, Colors.white, 0.75) ?? const Color(0xFFE8F5FE),
          ];
        }

      case BackgroundStyle.calm:
        // Sakin, yumuşak tonlar - krem, açık bej
        if (isDark) {
          return [
            const Color(0xFF1E1F2A),
            const Color(0xFF252732),
            const Color(0xFF1F2029),
          ];
        } else {
          return [
            const Color(0xFFFFF8F0), // Krem-beyaz
            const Color(0xFFFFFCF5), // Çok açık krem
            const Color(0xFFFFF9F2), // Açık bej
          ];
        }

      case BackgroundStyle.modern:
        // Modern, kontrastlı tonlar
        if (isDark) {
          return [
            const Color(0xFF151520),
            const Color(0xFF1A1B28),
            const Color(0xFF181925),
          ];
        } else {
          return [
            const Color(0xFFF5F3F8), // Açık gri-mor
            const Color(0xFFF8F6FA), // Çok açık mor
            const Color(0xFFF7F5F9), // Açık gri-lavanta
          ];
        }
    }
  }

  List<Widget> _buildAnimatedDecorations(
      BuildContext context, ThemeData theme, bool isDark) {
    final size = MediaQuery.of(context).size;
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return [
      // Animasyonlu büyük daire (sağ üst)
      Positioned(
        right: -size.width * 0.2,
        top: -size.height * 0.1,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: size.width * 0.6,
                height: size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryColor.withOpacity(_fadeAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // Dönen orta daire (sol alt)
      Positioned(
        left: -size.width * 0.15,
        bottom: -size.height * 0.15,
        child: AnimatedBuilder(
          animation: _rotateAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateAnimation.value,
              child: Container(
                width: size.width * 0.5,
                height: size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      secondaryColor.withOpacity(_fadeAnimation.value * 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // Büyüyen-küçülen küçük daire (sağ orta)
      Positioned(
        right: size.width * 0.1,
        top: size.height * 0.3,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: size.width * 0.3,
                height: size.width * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      tertiaryColor.withOpacity(_fadeAnimation.value * 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // Ekstra animasyonlu küçük daire (sol üst)
      Positioned(
        left: size.width * 0.05,
        top: size.height * 0.15,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 / _pulseAnimation.value, // Ters pulse
              child: Container(
                width: size.width * 0.2,
                height: size.width * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primaryColor.withOpacity(_fadeAnimation.value * 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // Subtle animasyonlu grid pattern
      CustomPaint(
        size: size,
        painter: _AnimatedGridPatternPainter(
          color: primaryColor.withOpacity(
            isDark ? (_fadeAnimation.value * 0.03) : (_fadeAnimation.value * 0.02),
          ),
        ),
      ),
    ];
  }
}

/// Animasyonlu grid pattern painter
class _AnimatedGridPatternPainter extends CustomPainter {
  final Color color;

  _AnimatedGridPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // Dikey çizgiler
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Yatay çizgiler
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_AnimatedGridPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}
