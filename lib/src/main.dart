import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/models/auth.dart';
import 'common/models/cart.dart';
import 'common/models/order_list.dart';
import 'common/models/product_list.dart';
import 'common/utils/app_routes.dart';
import 'common/utils/custom_route.dart';
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
  runApp(const HomeScreen());
}

class CircularItemList extends StatefulWidget {
  const CircularItemList({Key? key}) : super(key: key);

  @override
  CircularItemListState createState() => CircularItemListState();
}

class CircularItemListState extends State<CircularItemList> {
  List<String> items = ['', 'item 1', 'item 2', 'item 3', ''];
  late PageController _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _pageController.addListener(_pageListener);
  }

  void _pageListener() {
    if (_pageController.page! > items.length - 1.5) {
      _pageController.jumpToPage(1);
    } else if (_pageController.page! < 0.5) {
      _pageController.jumpToPage(items.length - 2);
    }
    setState(() {
      _currentPage = _pageController.page!.toInt();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToNext() {
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _scrollToPrevious() {
    _pageController.animateToPage(
      _currentPage - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Widget _buildItem(String item) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              _scrollToPrevious();
            } else if (details.velocity.pixelsPerSecond.dx < 0) {
              _scrollToNext();
            }
          },
          child: PageView.builder(
            controller: _pageController,
            itemCount: items.length + 2,
            itemBuilder: (context, index) {
              return _buildItem(items[index]);
            },
          ),
        ),
      ),
    );
  }
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
