import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import 'product_grid_item.dart';
import '../../repository/product.dart';
import '../../repository/product_list.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;
  final String search;
  final List<String> categories;
  final String selectedSortOption;

  const ProductGrid(
    this.showFavoriteOnly,
    this.categories,
    this.search,
    this.selectedSortOption, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    List<Product> filteredProducts = loadedProducts.where((product) {
      final String productName = product.name.toLowerCase();

      if (categories.isEmpty && search.isEmpty) {
        return true;
      }

      if (categories.isEmpty && search.isNotEmpty) {
        return productName.contains(search.toLowerCase()) ||
            product.name.toLowerCase().contains(search.toLowerCase());
      }

      for (final category in categories) {
        if (product.categories.contains(category) &&
            (productName.contains(search.toLowerCase()) ||
                product.name.toLowerCase().contains(search.toLowerCase()))) {
          return true;
        }
      }

      return false;
    }).toList();

    if (selectedSortOption == 'top_selling'.i18n()) {
      filteredProducts.sort((a, b) => b.orders.compareTo(a.orders));
    } else if (selectedSortOption == 'increasing_price'.i18n()) {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSortOption == 'decreasing_price'.i18n()) {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }

    return filteredProducts.isEmpty
        ? Center(
            child: Text(
              'no_product_found'.i18n(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: filteredProducts.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: filteredProducts[i],
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
