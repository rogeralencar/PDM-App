lib/src/feature/home/viewmodel/navegation_module.dart:

import 'package:flutter_modular/flutter_modular.dart';

import '../view/page/product_form_screen.dart';
import '../view/page/profile_form_screen.dart';
import '../view/page/navegation_screen.dart';

class NavegationModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => const NavigationScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/profileForm',
          child: (_, __) => const ProfileFormScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productForm',
          child: (_, __) => const ProductFormScreen(),
          transition: TransitionType.fadeIn,
        ),
      ];
}