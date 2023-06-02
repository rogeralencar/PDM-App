import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repository/product_list.dart';
import '../widget/product_item.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    final bool withoutProducts = products.items.isEmpty;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: withoutProducts
            ? const Center(
                child: Text(
                  'Você ainda não realizou nenhuma compra!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: products.itemsCount,
                itemBuilder: (ctx, i) => Column(
                  children: [
                    ProductItem(products.items[i]),
                    const Divider(),
                  ],
                ),
              ),
      ),
    );
  }
}
