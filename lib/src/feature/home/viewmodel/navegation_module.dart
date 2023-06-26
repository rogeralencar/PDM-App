import 'package:flutter_modular/flutter_modular.dart';

import '../view/page/category_selector_screen.dart';
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
          child: (_, __) => const NavegationScreen(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/profileForm',
          child: (_, args) => ProfileFormScreen(
            user: args.data,
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productForm/',
          child: (_, args) => ProductFormScreen(
            product: args.data,
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/productForm/categories',
          child: (_, args) => CategorySelectionScreen(
            selectedCategoriesNames: args.data,
          ),
          transition: TransitionType.fadeIn,
        ),
      ];
}
