import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'core/routes/route_generator.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/services/notification_service.dart';
import 'core/services/notification_navigation_service.dart';
import 'core/services/task_due_worker.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_controller.dart';
import 'features/task/bloc/task_bloc.dart';
import 'data/local/database_helper.dart';
import 'features/task/data/datasources/task_local_datasource.dart';
import 'features/task/data/repositories/task_repository_impl.dart';
import 'features/calendar/share/bloc/share_calendar_bloc.dart';
import 'core/services/timezone_service.dart';
import 'pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize locale data for intl package
  await initializeDateFormatting('tr_TR', null);
  await initializeDateFormatting('en_US', null);

  // Bildirim servisini başlat ve izinleri iste
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.ensurePermissions();

  // Arka plan vade kontrolü
  await Workmanager().initialize(taskDueCallbackDispatcher);

  // Timezone servisini başlat
  await TimezoneService().initialize();

  // BLoC Observer setup
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppThemeController _themeController = AppThemeController();

  @override
  void initState() {
    super.initState();
    _themeController.load();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      controller: _themeController,
      child: ListenableBuilder(
        listenable: _themeController,
        builder: (context, _) {
          if (_themeController.isLoading) {
            return MaterialApp(
              title: 'Çalışma Takvimi',
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: Colors.white,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    final logoSize = constraints.maxWidth * 0.62;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/splash_logo.png',
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 32),
                          const CircularProgressIndicator(
                            color: Color(0xFFFF6B00),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }

          // Dependency Injection Setup - SQLite kullanıyor
          final databaseHelper = DatabaseHelper.instance;
          final taskLocalDataSource = TaskLocalDataSource(databaseHelper);
          final taskRepository = TaskRepositoryImpl(taskLocalDataSource);
          final taskBloc = TaskBloc(taskRepository);
          final shareCalendarBloc = ShareCalendarBloc();

          return MultiBlocProvider(
            providers: [
              BlocProvider<TaskBloc>.value(value: taskBloc),
              BlocProvider<ShareCalendarBloc>.value(value: shareCalendarBloc),
            ],
            child: MaterialApp(
              navigatorKey: NotificationNavigationService.navigatorKey,
              title: 'Çalışma Takvimi',
              debugShowCheckedModeBanner: false,
              locale: const Locale('tr', 'TR'),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('tr', 'TR'),
                Locale('en', 'US'),
              ],
              themeMode: _themeController.themeMode,
              theme: lightTheme(
                _themeController.textScaleFactor,
                themeModel: _themeController.currentTheme,
                fontFamily: _themeController.fontFamily,
              ),
              darkTheme: darkTheme(
                _themeController.textScaleFactor,
                themeModel: _themeController.currentTheme,
                fontFamily: _themeController.fontFamily,
              ),
              home: const HomePage(),
              onGenerateRoute: RouteGenerator.generateRoute,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      _themeController.textScaleFactor,
                    ),
                  ),
                  child: child!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
