import 'package:flutter_modular/flutter_modular.dart';
import 'package:shop/src/feature/auth/auth_module.dart';

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
          '/auth/',
          module: AuthModule(),
        ),
        ModuleRoute(
          '/navegation/',
          module: NavegationModule(),
        ),
      ];
}
