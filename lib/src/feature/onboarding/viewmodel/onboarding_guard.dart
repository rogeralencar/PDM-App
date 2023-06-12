import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/view/widget/auth.dart';

class OnboardingGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String url, ModularRoute route) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted =
        prefs.getBool('onboardingCompleted') ?? false;

    if (onboardingCompleted) {
      return true;
    } else {
      final auth = Modular.get<Auth>();
      await auth.tryAutoLogin();
      return auth.isAuth;
    }
  }
}
