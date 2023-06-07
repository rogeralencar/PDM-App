import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feature/auth/repository/user_provider.dart';
import 'feature/auth/view/widget/auth.dart';
import 'feature/home/view/page/home_screen.dart';
import 'feature/onboarding/view/page/onboarding_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  const AuthOrHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.outline,
          ));
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          if (auth.isAuth) {
            return FutureBuilder(
              future: userProvider.loadUser(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.outline,
                  ));
                } else if (snapshot.error != null) {
                  return const Center(
                    child: Text('Ocorreu um erro ao carregar o usuário!'),
                  );
                } else {
                  return const HomeScreen();
                }
              },
            );
          } else {
            return const OnBoardingScreen();
          }
        }
      },
    );
  }
}
