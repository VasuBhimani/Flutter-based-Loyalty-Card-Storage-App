import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cards/presentation/pages/cards_list_page.dart';
import '../../features/cards/presentation/pages/add_card_page.dart';
import '../../features/cards/presentation/pages/card_details_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const CardsListPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/add-card':
        return MaterialPageRoute(builder: (_) => const AddCardPage());
      case '/card-details':
        final cardId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CardDetailsPage(cardId: cardId),
        );
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
