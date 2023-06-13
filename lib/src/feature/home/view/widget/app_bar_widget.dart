import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

import 'badge.dart' as bad;
import '../../repository/cart.dart';
import 'cep_widget.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  AppBarWidgetState createState() => AppBarWidgetState();
}

class AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                onTap: () {
                  Modular.to.pushNamed('/navegation');
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.person_outlined),
                ),
              ),
            ),
          ),
          const CepWidget(),
          Material(
            elevation: 4,
            shape: const CircleBorder(),
            child: Consumer<Cart>(
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onTap: () {
                    //Navigator.of(context).pushNamed(AppRoutes.cart);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.shopping_cart_outlined),
                  ),
                ),
              ),
              builder: (ctx, cart, child) => Stack(
                children: [
                  bad.Badge(
                    value: cart.itemsCount.toString(),
                    child: child!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
