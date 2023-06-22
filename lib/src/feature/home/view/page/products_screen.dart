import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../repository/product_list.dart';
import '../widget/product_item.dart';

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
              : Center(
                  child: Text(
                    'info_message_no_product'.i18n(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
