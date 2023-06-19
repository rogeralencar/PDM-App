import 'package:flutter_modular/flutter_modular.dart';

import 'view/page/cart_screen.dart';
import 'view/page/home_screen.dart';
import 'view/page/navegation_screen.dart';
import 'view/page/products_detail_screen.dart';
import 'view/page/products_overview_screen.dart';

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
          '/productDetails',
          child: (_, args) => const ProductsDetailScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productsOverview',
          child: (_, args) => const ProductsOverviewScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/navegation',
          child: (_, __) => const NavigationScreen(),
          transition: TransitionType.fadeIn,
        ),
      ];
}
