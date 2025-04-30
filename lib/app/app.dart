import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/cards/presentation/bloc/cards_bloc.dart';
import '../features/cards/presentation/pages/cards_list_page.dart';
import '../features/auth/presentation/pages/login_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthInitial) {
          context.read<AuthBloc>().add(CheckAuthStatus());
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authState is AuthAuthenticated) {
          return BlocBuilder<CardsBloc, CardsState>(
            builder: (context, cardsState) {
              if (cardsState is CardsInitial) {
                context.read<CardsBloc>().add(LoadCards());
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const CardsListPage();
            },
          );
        }

        return const LoginPage();
      },
    );
  }
}
