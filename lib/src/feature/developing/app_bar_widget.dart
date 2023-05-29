import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

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
                  debugPrint('Perfil');
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
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                onTap: () {
                  debugPrint('Carrinho');
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
    );
  }
}
