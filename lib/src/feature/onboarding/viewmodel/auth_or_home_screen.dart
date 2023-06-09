import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/view/widget/auth.dart';
import '../../home/view/page/home_screen.dart';
import '../view/page/onboarding_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  const AuthOrHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? const HomeScreen() : const OnBoardingScreen();
        }
      },
    );
  }
}
