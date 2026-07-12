import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../l10n/app_localizations.dart';
import '../../pages/home/home_page.dart';
import '../../pages/task/task_form_page.dart';
import '../../pages/task/task_snooze_page.dart';
import '../../pages/event/event_detail_page.dart';
import '../../pages/calendar/month_view_page.dart';
import '../../pages/calendar/week_view_page.dart';
import '../../pages/calendar/day_view_page.dart';
import '../../pages/calendar/year_view_page.dart';
import '../../pages/settings/settings_page.dart';
import '../../pages/settings/sync_settings_page.dart';
import '../../pages/settings/theme_settings_page.dart';
import '../../pages/widget_preview/widget_preview_page.dart';
import '../../pages/assistant/ai_assistant_page.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../features/event/data/datasources/event_remote_datasource.dart';
import '../../features/event/data/repositories/event_repository_impl.dart';
import '../../data/local/database_helper.dart';
import '../../features/task/data/datasources/task_local_datasource.dart';
import '../../features/task/data/repositories/task_repository_impl.dart';
import 'app_routes.dart';
import '../services/deep_link_service.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final routeName = settings.name;

    // Deep link kontrolü
    if (routeName != null) {
      final deepLinkResult = DeepLinkService().parseDeepLink(routeName);
      if (deepLinkResult != null) {
        return _handleDeepLink(deepLinkResult);
      }
    }

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

      case AppRoutes.taskSnooze:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => TaskSnoozePage(taskId: args),
          );
        }
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.error)),
              body: Center(child: Text(l10n.taskIdRequired)),
            );
          },
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
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.error)),
              body: Center(child: Text(l10n.eventIdRequired)),
            );
          },
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
          builder: (_) => YearViewPage(
            eventRepository: createEventRepository(),
          ),
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );

      case AppRoutes.syncSettings:
        return MaterialPageRoute(
          builder: (_) => const SyncSettingsPage(),
        );

      case AppRoutes.themeSettings:
        return MaterialPageRoute(
          builder: (_) => const ThemeSettingsPage(),
        );

      case AppRoutes.widgetPreview:
        return MaterialPageRoute(
          builder: (_) => const WidgetPreviewPage(),
        );

      case AppRoutes.aiAssistant:
        // Repository'leri oluştur ve asistan sayfasına geç
        final eventRepository = createEventRepository();
        final taskRepository = _createTaskRepository();
        return MaterialPageRoute(
          builder: (_) => AiAssistantPage(
            eventRepository: eventRepository,
            taskRepository: taskRepository,
          ),
        );

      case AppRoutes.shareEvent:
        // Deep link'ten gelen parametreleri kullan
        if (args is DeepLinkResult) {
          // Paylaşım sayfasına yönlendir (gelecekte oluşturulacak)
          return MaterialPageRoute(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return Scaffold(
                appBar: AppBar(title: Text(l10n.eventSharing)),
                body: Center(
                  child: Text(l10n.eventIdLabel(args.eventId ?? l10n.unknown)),
                ),
              );
            },
          );
        }
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.eventSharing)),
              body: Center(child: Text(l10n.eventInfoNotFound)),
            );
          },
        );

      case AppRoutes.shareCalendar:
      case AppRoutes.importCalendar:
        // Paylaşım/İçe aktarma sayfaları (gelecekte oluşturulacak)
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.calendarOperations)),
              body: Center(child: Text(l10n.featureComingSoon)),
            );
          },
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.pageNotFound)),
              body: Center(
                child: Text(l10n.pageNotFoundWithRoute(routeName)),
              ),
            );
          },
        );
    }
  }

  /// Deep link'i handle et
  static Route<dynamic> _handleDeepLink(DeepLinkResult result) {
    switch (result.route) {
      case AppRoutes.shareEvent:
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.eventSharing)),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.eventIdLabel(result.eventId ?? l10n.unknown)),
                    if (result.timezone != null)
                      Text(l10n.timezoneLabel(result.timezone!)),
                  ],
                ),
              ),
            );
          },
          settings: RouteSettings(
            name: result.route,
            arguments: result,
          ),
        );

      case AppRoutes.shareCalendar:
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.calendarSharing)),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (result.calendarName != null)
                      Text(l10n.calendarNameLabel(result.calendarName!)),
                    if (result.timezone != null)
                      Text(l10n.timezoneLabel(result.timezone!)),
                  ],
                ),
              ),
            );
          },
          settings: RouteSettings(
            name: result.route,
            arguments: result,
          ),
        );

      case AppRoutes.importCalendar:
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.calendarImport)),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.importingCalendar),
                    if (result.sourceTimezone != null)
                      Text(l10n.sourceTimezoneLabel(result.sourceTimezone!)),
                  ],
                ),
              ),
            );
          },
          settings: RouteSettings(
            name: result.route,
            arguments: result,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.error)),
              body: Center(child: Text(l10n.invalidDeepLink)),
            );
          },
        );
    }
  }

  /// Event Repository oluştur
  static EventRepository? createEventRepository() {
    try {
      final firestore = FirebaseFirestore.instance;
      final remoteDataSource = EventRemoteDataSource(firestore);
      return EventRepositoryImpl(remoteDataSource);
    } catch (e) {
      // Firebase başlatılmamışsa null döndür
      return null;
    }
  }

  /// Task Repository oluştur
  static TaskRepository? _createTaskRepository() {
    try {
      final databaseHelper = DatabaseHelper.instance;
      final taskLocalDataSource = TaskLocalDataSource(databaseHelper);
      return TaskRepositoryImpl(taskLocalDataSource);
    } catch (e) {
      return null;
    }
  }
}

