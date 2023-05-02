import 'package:flutter_modular/flutter_modular.dart';

import 'view/page/onboarding_screen.dart';
import '../home/home_module.dart';
import '../auth/auth_module.dart';
import '../auth/viewmodule/signup_module.dart';

class OnBoardingModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const OnBoardingScreen()),
        ModuleRoute('/auth/', module: AuthModule()),
        ModuleRoute('/signup/', module: SignupModule()),
        ModuleRoute('/home/', module: HomeModule()),
      ];
}
