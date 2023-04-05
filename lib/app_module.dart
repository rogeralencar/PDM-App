import 'package:flutter_modular/flutter_modular.dart';

import 'src/feature/home/view/widget/form_module.dart';
import 'src/feature/home/view/widget/onboarding_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: OnBoardingModule()),
        ModuleRoute('/form/', module: FormModule())
      ];
}
