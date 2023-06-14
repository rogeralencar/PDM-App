import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

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
  late PageController pageViewController;
  int currentPageIndex = 0;

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
  void initState() {
    super.initState();
    pageViewController = PageController();
    pageViewController.addListener(() {
      setState(() {
        currentPageIndex = pageViewController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[currentPageIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
              Modular.to.navigate('/auth/');
            },
          ),
          if (currentPageIndex == 1)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Modular.to.pushNamed('products');
              },
            ),
        ],
      ),
      body: PageView(
        controller: pageViewController,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => pageViewController.jumpToPage(0),
              color: currentPageIndex == 0
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.tertiary,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => pageViewController.jumpToPage(1),
              color: currentPageIndex == 1
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.tertiary,
            ),
            IconButton(
              icon: const Icon(Icons.payment),
              onPressed: () => pageViewController.jumpToPage(2),
              color: currentPageIndex == 2
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}
