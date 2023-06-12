import 'package:flutter_modular/flutter_modular.dart';

import 'view/page/forgot_password_screen.dart';
import 'view/page/signup_screen.dart';
import 'view/page/login_screen.dart';
import '../home/home_module.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const LoginScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/signup/',
          child: (_, __) => const SignupScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/forgotPassword/',
          child: (_, __) => const ForgotPasswordScreen(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute('/home/', module: HomeModule()),
      ];
}
