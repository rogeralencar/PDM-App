import 'package:flutter_modular/flutter_modular.dart';

import 'view/page/cart_screen.dart';
import 'view/page/category_selector_screen.dart';
import 'view/page/home_screen.dart';
import 'view/page/product_detail_screen.dart';
import 'view/page/product_overview_screen.dart';
import 'view/page/profile_screen.dart';
import 'view/page/promotion_details_screen.dart';
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
        ModuleRoute('/navegation', module: NavegationModule()),
        ChildRoute(
          '/cart',
          child: (_, __) => const CartScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/promotionDetails',
          child: (_, args) => PromotionDetailsScreen(
            promotion: args.data,
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productDetails/',
          child: (_, args) => ProductDetailScreen(
            product: args.data,
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productDetails/profile',
          child: (_, args) => ProfileScreen(
            user: args.data,
            isYourProfile: false,
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productOverview/',
          child: (_, args) => ProductOverviewScreen(
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
