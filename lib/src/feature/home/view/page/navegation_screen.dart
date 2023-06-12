import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/feature/home/view/page/products_form_screen.dart';

import '../../../auth/view/widget/auth.dart';
import 'orders_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
  final pageViewController = PageController();

  final List<String> _titles = [
    'Perfil',
    'Produtos',
    'Pedidos',
  ];

  final List<Widget> _screens = const [
    ProfileScreen(),
    ProductsScreen(),
    OrdersScreen(),
  ];

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[pageViewController.page?.round() ?? 0]),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
              Modular.to.pushNamed('/auth/');
            },
          ),
          if (pageViewController.page?.round() == 1)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Modular.to.push(
                  MaterialPageRoute(
                    builder: (_) => const ProductsFormScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: PageView(
        controller: pageViewController,
        children: _screens,
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: pageViewController,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            currentIndex: pageViewController.page?.round() ?? 0,
            onTap: (index) {
              pageViewController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.payment),
              ),
            ],
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            unselectedItemColor: Theme.of(context).colorScheme.tertiary,
          );
        },
      ),
    );
  }
}
