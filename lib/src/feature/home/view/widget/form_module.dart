import 'package:flutter_modular/flutter_modular.dart';

import '../page/form_screen.dart';

class FormModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const FormScreen()),
      ];
}
