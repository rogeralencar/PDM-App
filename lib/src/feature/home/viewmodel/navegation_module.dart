import 'package:flutter_modular/flutter_modular.dart';

import '../view/page/products_form_screen.dart';
import '../view/page/profile_form_screen.dart';
import '../view/page/navegation_screen.dart';

class NavegationModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => const NavigationScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/profile/',
          child: (_, __) => const ProfileFormScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/products/',
          child: (_, __) => const ProductsFormScreen(),
          transition: TransitionType.fadeIn,
        ),
      ];
}
