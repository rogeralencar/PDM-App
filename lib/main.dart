import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/auth.dart';
import 'models/cart.dart';
import 'models/order_list.dart';
import 'models/product_list.dart';
import 'screens/auth_or_home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/place_detail_screen.dart';
import 'screens/products_detail_screen.dart';
import 'screens/products_form_screen.dart';
import 'screens/products_screen.dart';
import 'utils/app_routes.dart';
import 'utils/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList();
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList();
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: CustomScreenTransictionBuilder(),
              TargetPlatform.android: CustomScreenTransictionBuilder(),
            },
          ),
        ),
        routes: {
          AppRoutes.authOrHome: (ctx) => AuthOrHomeScreen(),
          AppRoutes.productsDetail: (ctx) => ProductsDetailScreen(),
          AppRoutes.cart: (ctx) => CartScreen(),
          AppRoutes.orders: (ctx) => OrdersScreen(),
          AppRoutes.products: (ctx) => ProductsScreen(),
          AppRoutes.productsForm: (ctx) => ProductsFormScreen(),
          AppRoutes.placeDetail: (ctx) => const PlaceDetailScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
