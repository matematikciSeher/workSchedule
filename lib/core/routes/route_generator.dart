import 'package:flutter/material.dart';
import '../../pages/home/home_page.dart';
import '../../pages/task/task_form_page.dart';
import '../../pages/event/event_detail_page.dart';
import '../../pages/calendar/month_view_page.dart';
import '../../pages/calendar/week_view_page.dart';
import '../../pages/calendar/day_view_page.dart';
import '../../pages/calendar/year_view_page.dart';
import '../../pages/settings/settings_page.dart';
import '../../pages/settings/sync_settings_page.dart';
import '../../pages/widget_preview/widget_preview_page.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final routeName = settings.name;

    switch (routeName) {
      case AppRoutes.home:
      case AppRoutes.homeCalendar:
      case null:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.taskForm:
        return MaterialPageRoute(
          builder: (_) => const TaskFormPage(),
        );

      case AppRoutes.taskEdit:
        return MaterialPageRoute(
          builder: (_) => TaskFormPage(
            taskId: args is String ? args : null,
          ),
        );

      case AppRoutes.eventDetail:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => EventDetailPage(
              eventId: args,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Hata')),
            body: const Center(
              child: Text('Etkinlik ID gerekli'),
            ),
          ),
        );

      case AppRoutes.monthView:
        return MaterialPageRoute(
          builder: (_) => const MonthViewPage(),
        );

      case AppRoutes.weekView:
        return MaterialPageRoute(
          builder: (_) => const WeekViewPage(),
        );

      case AppRoutes.dayView:
        return MaterialPageRoute(
          builder: (_) => const DayViewPage(),
        );

      case AppRoutes.yearView:
        return MaterialPageRoute(
          builder: (_) => const YearViewPage(),
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );

      case AppRoutes.syncSettings:
        return MaterialPageRoute(
          builder: (_) => const SyncSettingsPage(),
        );

      case AppRoutes.widgetPreview:
        return MaterialPageRoute(
          builder: (_) => const WidgetPreviewPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Sayfa Bulunamadı')),
            body: Center(
              child: Text('Sayfa bulunamadı: $routeName'),
            ),
          ),
        );
    }
  }
}

