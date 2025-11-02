class AppRoutes {
  // Ana sayfalar
  static const String home = '/';
  static const String homeCalendar = '/home';

  // Görev sayfaları
  static const String taskForm = '/task/form';
  static const String taskEdit = '/task/edit';

  // Etkinlik sayfaları
  static const String eventDetail = '/event/detail';

  // Takvim görünüm sayfaları
  static const String monthView = '/calendar/month';
  static const String weekView = '/calendar/week';
  static const String dayView = '/calendar/day';
  static const String yearView = '/calendar/year';

  // Ayarlar sayfaları
  static const String settings = '/settings';
  static const String syncSettings = '/settings/sync';
  static const String themeSettings = '/settings/theme';

  // Widget önizleme
  static const String widgetPreview = '/widget/preview';

  // AI Asistan
  static const String aiAssistant = '/assistant';

  // Paylaşım ve içe aktarma
  static const String shareEvent = '/share/event';
  static const String shareCalendar = '/share/calendar';
  static const String importCalendar = '/import/calendar';

  // Auth sayfaları
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Deep link base URL
  static const String deepLinkBase = 'workschedule://';
  static const String deepLinkShareEvent = '${deepLinkBase}share/event';
  static const String deepLinkShareCalendar = '${deepLinkBase}share/calendar';
  static const String deepLinkImportCalendar = '${deepLinkBase}import/calendar';
}

