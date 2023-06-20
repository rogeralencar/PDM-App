import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_grid_item.dart';
import '../../repository/product.dart';
import '../../repository/product_list.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  const ProductGrid(this.showFavoriteOnly, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    return loadedProducts.isEmpty
        ? const Center(
            child: Text(
              'Nenhum Produto encontrado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: loadedProducts.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: loadedProducts[i],
              child: const ProductGridItem(),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
