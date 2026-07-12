import 'dart:ui';

/// Sistem diline göre uygulama locale'ini belirler.
/// Türkçe → tr_TR, diğer tüm diller → en_US.
class AppLocale {
  AppLocale._();

  static const turkish = Locale('tr', 'TR');
  static const english = Locale('en', 'US');

  static const supportedLocales = [turkish, english];

  static Locale resolve(Locale? deviceLocale) {
    if (deviceLocale != null &&
        deviceLocale.languageCode.toLowerCase() == 'tr') {
      return turkish;
    }
    return english;
  }

  static Locale get systemLocale =>
      resolve(PlatformDispatcher.instance.locale);

  static String dateFormatLocale(Locale locale) =>
      locale.languageCode == 'tr' ? 'tr_TR' : 'en_US';

  static Locale? localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    return resolve(locale);
  }
}
