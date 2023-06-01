import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feature/auth/view/widget/auth.dart';
import 'feature/home/view/widget/models/cart.dart';
import 'feature/home/view/widget/models/order_list.dart';
import 'feature/home/view/widget/models/product_list.dart';
import 'common/utils/app_routes.dart';
import 'auth_or_home_screen.dart';
import 'feature/auth/view/page/forgot_password_screen.dart';
import 'feature/auth/view/page/login_screen.dart';
import 'feature/auth/view/page/signup_screen.dart';
import 'feature/home/view/page/cart_screen.dart';
import 'feature/home/view/page/orders_screen.dart';
import 'feature/home/view/page/place_detail_screen.dart';
import 'feature/home/view/page/products_detail_screen.dart';
import 'feature/home/view/page/products_form_screen.dart';
import 'feature/home/view/page/products_screen.dart';
import 'feature/home/view/page/products_overview_screen.dart';
import 'feature/onboarding/view/page/onboarding_screen.dart';

import 'feature/developing/home_screen.dart';

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
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomeScreen(),
          AppRoutes.login: (ctx) => const LoginScreen(),
          AppRoutes.signup: (ctx) => const SignupScreen(),
          AppRoutes.forgotPassword: (ctx) => const ForgotPassword(),
          AppRoutes.productsDetail: (ctx) => const ProductsDetailScreen(),
          AppRoutes.onBoarding: (ctx) => const OnBoardingScreen(),
          AppRoutes.cart: (ctx) => const CartScreen(),
          AppRoutes.orders: (ctx) => const OrdersScreen(),
          AppRoutes.products: (ctx) => const ProductsScreen(),
          AppRoutes.productsOverview: (ctx) => const ProductsOverviewScreen(),
          AppRoutes.productsForm: (ctx) => const ProductsFormScreen(),
          AppRoutes.placeDetail: (ctx) => const PlaceDetailScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
