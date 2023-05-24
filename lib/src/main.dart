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

void main() {
  runApp(const Teste());
}

class Teste extends StatefulWidget {
  const Teste({Key? key}) : super(key: key);

  @override
  TesteState createState() => TesteState();
}

class TesteState extends State<Teste> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      indicators.add(
        i == _currentPage ? _indicator(true) : _indicator(false),
      );
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: 4.0,
      width: 20,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                      ),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onTap: () {
                          // Implemente a funcionalidade do botão de perfil aqui
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person_outlined),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                      ),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onTap: () {
                          // Implemente a funcionalidade do botão de perfil aqui
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.shopping_cart_outlined),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(18.0),
                child: TextField(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: const Icon(
                      Icons.search,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  onChanged: (value) {
                    // Implement search functionality here
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              height: 190.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount:
                    3, // Coloque o número total de itens do carrossel aqui
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Implemente a funcionalidade do carrossel aqui
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        'https://casaeconstrucao.org/wp-content/uploads/2022/07/2-modelo-de-frase-para-loja-de-roupas.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Product Categories',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Add your product category widgets here
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Product Recommendations',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Add your product recommendation widgets here
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
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
