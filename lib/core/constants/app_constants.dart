/// Uygulama genelinde kullanılan sabitler
class AppConstants {
  // App Info
  static const String appName = 'Çalışma Takvimi';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'work_schedule.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String keyTheme = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyUserId = 'user_id';
  static const String keyFirstLaunch = 'first_launch';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Date Formats
  static const String dateFormat = 'dd.MM.yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd.MM.yyyy HH:mm';
}

