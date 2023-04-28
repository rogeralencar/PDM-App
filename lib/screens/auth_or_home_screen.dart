import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';
import 'products_overview_screen.dart';
import '../models/auth.dart';

class AuthOrHomeScreen extends StatelessWidget {
  const AuthOrHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth
              ? const ProductsOverviewScreen()
              : const AuthScreen();
        }
      },
    );
  }
}
