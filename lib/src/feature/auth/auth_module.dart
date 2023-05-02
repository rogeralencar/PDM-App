import 'package:flutter_modular/flutter_modular.dart';

import '../../auth_or_home_screen.dart';
import 'viewmodule/signup_module.dart';
import '../home/home_module.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const AuthOrHomeScreen()),
        ModuleRoute('/signup/', module: SignupModule()),
        ModuleRoute('/form/', module: SignupModule()),
        ModuleRoute('/home/', module: HomeModule()),
      ];
}
