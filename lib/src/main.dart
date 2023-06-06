import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/utils/app_routes.dart';
import 'auth_or_home_screen.dart';
import 'feature/auth/repository/user_provider.dart';
import 'feature/auth/view/widget/auth.dart';
import 'feature/home/repository/cart.dart';
import 'feature/home/repository/order_list.dart';
import 'feature/home/repository/product_list.dart';
import 'feature/home/view/page/products_overview_screen.dart';
import 'feature/auth/view/page/forgot_password_screen.dart';
import 'feature/auth/view/page/login_screen.dart';
import 'feature/auth/view/page/signup_screen.dart';
import 'feature/home/view/page/cart_screen.dart';
import 'feature/home/view/page/home_screen.dart';
import 'feature/home/view/page/navegation_screen.dart';
import 'feature/home/view/page/orders_screen.dart';
import 'feature/home/view/page/place_detail_screen.dart';
import 'feature/home/view/page/products_detail_screen.dart';
import 'feature/home/view/page/products_form_screen.dart';
import 'feature/home/view/page/products_screen.dart';
import 'feature/onboarding/view/page/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF35034F),
            secondary: const Color(0xFFF9626C),
          ),
          fontFamily: 'Lato',
        ),
        navigatorKey: navigatorKey,
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomeScreen(),
          AppRoutes.cart: (ctx) => const CartScreen(),
          AppRoutes.forgotPassword: (ctx) => const ForgotPassword(),
          AppRoutes.home: (ctx) => const HomeScreen(),
          AppRoutes.login: (ctx) => const LoginScreen(),
          AppRoutes.onBoarding: (ctx) => const OnBoardingScreen(),
          AppRoutes.orders: (ctx) => const OrdersScreen(),
          AppRoutes.placeDetail: (ctx) => const PlaceDetailScreen(),
          AppRoutes.products: (ctx) => const ProductsScreen(),
          AppRoutes.productsDetail: (ctx) => const ProductsDetailScreen(),
          AppRoutes.productsForm: (ctx) => const ProductsFormScreen(),
          AppRoutes.productsOverview: (ctx) => const ProductsOverviewScreen(),
          AppRoutes.navegator: (ctx) => const NavigationScreen(),
          AppRoutes.signup: (ctx) => const SignupScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
