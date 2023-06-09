import 'package:flutter_modular/flutter_modular.dart';

import 'view/page/login_screen.dart';
import '../home/home_module.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const LoginScreen()),
        ModuleRoute('/home/', module: HomeModule()),
      ];
}
