import 'package:flutter_modular/flutter_modular.dart';

import 'view/page/home_screen.dart';
import 'viewmodel/navegation_module.dart';

class HomeModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => const HomeScreen(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/navegation/',
          module: NavegationModule(),
        ),
      ];
}
