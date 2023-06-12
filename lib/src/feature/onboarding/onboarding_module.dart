import 'package:flutter_modular/flutter_modular.dart';

import '../auth/auth_module.dart';
import '../home/home_module.dart';
import 'view/page/onboarding_screen.dart';
import 'viewmodel/onboarding_guard.dart';

class OnBoardingModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: HomeModule(), guards: [OnboardingGuard()]),
        ModuleRoute('/auth', module: AuthModule(), guards: [OnboardingGuard()]),
        ChildRoute('/onboarding', child: (_, __) => const OnBoardingScreen()),
      ];
}
