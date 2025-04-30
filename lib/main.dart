import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
            useMaterial3: true,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.indigo.withOpacity(0.05),
            ),
            scaffoldBackgroundColor: Colors.grey[50],
          ),
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const App(),
        ),
      ),
    );
  }
}

Future<encrypt.Key> getOrCreateKey(FlutterSecureStorage secureStorage) async {
  final keyString = await secureStorage.read(key: 'encryption_key');
  if (keyString != null) {
    return encrypt.Key.fromBase64(keyString);
  } else {
    final key = encrypt.Key.fromSecureRandom(32);
    await secureStorage.write(key: 'encryption_key', value: key.base64);
    return key;
  }
}
