import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/routes/app_router.dart';
import 'core/services/firebase_options.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/cards/presentation/bloc/cards_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize services
  final sharedPreferences = await SharedPreferences.getInstance();
  final secureStorage = const FlutterSecureStorage();
  final localStorageService = LocalStorageService(
    sharedPreferences: sharedPreferences,
    secureStorage: secureStorage,
  );

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(MyApp(
    localStorageService: localStorageService,
    notificationService: notificationService,
  ));
}

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final NotificationService notificationService;

  const MyApp({
    Key? key,
    required this.localStorageService,
    required this.notificationService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: localStorageService),
        Provider<NotificationService>.value(value: notificationService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              localStorageService: localStorageService,
            ),
          ),
          BlocProvider(
            create: (context) => CardsBloc(
              localStorageService: localStorageService,
              notificationService: notificationService,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Loyalty Cards',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const App(),
        ),
      ),
    );
  }
}
