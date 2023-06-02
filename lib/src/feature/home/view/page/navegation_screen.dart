import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/utils/app_routes.dart';
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
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
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
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
          ),
          if (_selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.productsForm);
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
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
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.payment),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
