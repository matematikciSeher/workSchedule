import 'package:flutter/material.dart';

/// String işlemleri için extension'lar
extension StringExtensions on String {
  /// İlk harfi büyük yap
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  /// Tüm kelimelerin ilk harfini büyük yap
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  /// Boş veya null ise varsayılan değer döndür
  String orDefault(String defaultValue) {
    return isEmpty ? defaultValue : this;
  }
  
  /// Color'a çevir
  Color toColor() {
    String hex = replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add alpha if not present
    }
    return Color(int.parse(hex, radix: 16));
  }
  
  /// ID safe string (URL'de kullanım için)
  String get toSafeId {
    return replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
  }
  
  /// Kelime sayısı
  int get wordCount {
    if (isEmpty) return 0;
    return split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }
  
  /// Masked string (ör: 5551234567 -> 555***4567)
  String masked({int start = 3, int end = 4}) {
    if (length <= start + end) return this;
    final visibleStart = substring(0, start);
    final visibleEnd = substring(length - end);
    final masked = '*' * (length - start - end);
    return '$visibleStart$masked$visibleEnd';
  }
}

