/// Genel input validasyon fonksiyonları
class InputValidators {
  /// Email validasyonu
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
  
  /// Phone validasyonu (Türkiye formatı)
  static bool isValidPhone(String phone) {
    return RegExp(r'^(0|\+90)?[5][0-9]{9}$').hasMatch(
      phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''),
    );
  }
  
  /// Boş olmayan string kontrolü
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
  
  /// Minimum karakter kontrolü
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }
  
  /// Tarih validasyonu
  static bool isValidDate(String date) {
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// URL validasyonu
  static bool isValidUrl(String url) {
    return RegExp(
      r'^https?://([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*/?$',
    ).hasMatch(url);
  }
}

