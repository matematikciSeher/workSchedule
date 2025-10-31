import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'features/task/bloc/task_bloc.dart';
import 'features/task/data/datasources/task_remote_datasource.dart';
import 'features/task/data/repositories/task_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize locale data for intl package
  await initializeDateFormatting('tr_TR', null);
  await initializeDateFormatting('en_US', null);

  // BLoC Observer setup
  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection Setup
    final firestore = FirebaseFirestore.instance;
    final taskRemoteDataSource = TaskRemoteDataSource(firestore);
    final taskRepository = TaskRepositoryImpl(taskRemoteDataSource);
    final taskBloc = TaskBloc(taskRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>.value(value: taskBloc),
        // Add more BLoC providers here
      ],
      child: const MaterialApp(
        title: 'Çalışma Takvimi',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.home,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
