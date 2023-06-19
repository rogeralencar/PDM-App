import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

import '../../repository/product_list.dart';
import '../widget/product_item.dart';
import 'products_form_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Modular.to.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductsFormScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: products.itemsCount > 0
              ? ListView.builder(
                  itemCount: products.itemsCount,
                  itemBuilder: (ctx, i) => Column(
                    children: [
                      ProductItem(products.items[i]),
                      const Divider(),
                    ],
                  ),
                )
              : const Center(
                  child: Text(
                    'Você ainda não adicionou nenhum produto!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
