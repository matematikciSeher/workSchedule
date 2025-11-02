import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'core/routes/route_generator.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/services/notification_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_models.dart';
import 'features/task/bloc/task_bloc.dart';
import 'data/local/database_helper.dart';
import 'features/task/data/datasources/task_local_datasource.dart';
import 'features/task/data/repositories/task_repository_impl.dart';
import 'features/calendar/share/bloc/share_calendar_bloc.dart';
import 'core/services/timezone_service.dart';
import 'core/widgets/auth_wrapper.dart';
import 'pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize locale data for intl package
  await initializeDateFormatting('tr_TR', null);
  await initializeDateFormatting('en_US', null);

  // Bildirim servisini başlat
  await NotificationService().initialize();

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
  final ThemeService _themeService = ThemeService();
  AppThemeModel? _currentTheme;
  ThemeMode _themeMode = ThemeMode.system;
  double _textScaleFactor = 1.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final theme = await _themeService.getSelectedTheme();
    final themeMode = await _themeService.getThemeMode();
    final textScale = await _themeService.getTextScaleFactor();

    if (mounted) {
      setState(() {
        _currentTheme = theme;
        _themeMode = themeMode;
        _textScaleFactor = textScale;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        title: 'Çalışma Takvimi',
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Dependency Injection Setup - SQLite kullanıyor
    final databaseHelper = DatabaseHelper.instance;
    final taskLocalDataSource = TaskLocalDataSource(databaseHelper);
    final taskRepository = TaskRepositoryImpl(taskLocalDataSource);
    final taskBloc = TaskBloc(taskRepository);

    // Share Calendar BLoC
    final shareCalendarBloc = ShareCalendarBloc();

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>.value(value: taskBloc),
        BlocProvider<ShareCalendarBloc>.value(value: shareCalendarBloc),
      ],
      child: MaterialApp(
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
        themeMode: _themeMode,
        theme: lightTheme(_textScaleFactor, themeModel: _currentTheme),
        darkTheme: darkTheme(_textScaleFactor, themeModel: _currentTheme),
        home: AuthWrapper(
          child: const HomePage(),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        // Theme değişikliklerini dinlemek için navigator observer ekleyebilirsiniz
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(_textScaleFactor),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
