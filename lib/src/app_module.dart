import 'package:flutter_modular/flutter_modular.dart';

import 'feature/onboarding/viewmodel/auth_or_home_screen.dart';
import 'feature/auth/auth_module.dart';
import 'feature/home/home_module.dart';
import 'feature/onboarding/onboarding_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const AuthOrHomeScreen()),
        ModuleRoute('/OnBoarding/', module: OnBoardingModule()),
        ModuleRoute('/auth/', module: AuthModule()),
        ModuleRoute('/home/', module: HomeModule())
      ];
}
