import 'package:flutter_modular/flutter_modular.dart';

import '../page/onboarding_screen.dart';
import 'form_module.dart';

class OnBoardingModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const OnBoardingScreen()),
        ModuleRoute('/form', module: FormModule()),
      ];
}
