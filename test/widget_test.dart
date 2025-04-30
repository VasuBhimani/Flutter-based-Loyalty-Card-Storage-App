// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_based_lloyalty_card_storage_app/main.dart';
import 'package:flutter_based_lloyalty_card_storage_app/core/services/local_storage_service.dart';
import 'package:flutter_based_lloyalty_card_storage_app/core/services/notification_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Setup services
    final sharedPreferences = await SharedPreferences.getInstance();
    final secureStorage = const FlutterSecureStorage();
    final localStorageService = LocalStorageService(
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
    );
    final notificationService = NotificationService();
    await notificationService.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      localStorageService: localStorageService,
      notificationService: notificationService,
    ));

    // Verify that the app starts
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
