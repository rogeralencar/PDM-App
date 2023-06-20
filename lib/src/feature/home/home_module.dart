import 'package:flutter_modular/flutter_modular.dart';

import 'view/page/cart_screen.dart';
import 'view/page/category_selector_screen.dart';
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
          '/navegation',
          child: (_, __) => const NavigationScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productDetails',
          child: (_, args) => const ProductsDetailScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productOverview/',
          child: (_, args) => ProductsOverviewScreen(
            selectedCategoriesNames: args.data['selectedCategoriesNames'],
            search: args.data['search'],
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productOverview/categories',
          child: (_, args) => CategorySelectionScreen(
            selectedCategoriesNames: args.data['selectedCategoriesNames'],
            isInRoute: args.data['isInRoute'] ?? true,
          ),
          transition: TransitionType.fadeIn,
        ),
      ];
}
