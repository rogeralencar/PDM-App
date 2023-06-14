import 'package:flutter_modular/flutter_modular.dart';

import '../auth/auth_module.dart';
import '../home/home_module.dart';
import 'view/page/onboarding_screen.dart';

class OnBoardingModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const OnBoardingScreen()),
        ModuleRoute('/home', module: HomeModule()),
        ModuleRoute('/auth', module: AuthModule()),
      ];
}
