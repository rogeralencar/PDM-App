import 'package:flutter_modular/flutter_modular.dart';

import 'view/page/cart_screen.dart';
import 'view/page/home_screen.dart';
import 'view/page/products_overview_screen.dart';
import 'viewmodel/navegation_module.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, __) => const HomeScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/cart',
          child: (_, __) => const CartScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/products',
          child: (_, __) => const ProductsOverviewScreen(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/navegation',
          module: NavegationModule(),
        ),
      ];
}
