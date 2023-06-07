import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/utils/app_routes.dart';
import '../../repository/product_list.dart';
import '../../repository/cart.dart';
import '../widget/search_widget.dart';
import '../widget/filter_widget.dart';
import '../widget/product_grid.dart';
import '../widget/badge.dart' as bad;

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Snap'),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: FilterOptions.favorite,
                    child: Text('Somente Favoritos'),
                  ),
                  const PopupMenuItem(
                    value: FilterOptions.all,
                    child: Text('Todos'),
                  ),
                ],
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.favorite) {
                      _showFavoriteOnly = true;
                    } else {
                      _showFavoriteOnly = false;
                    }
                  });
                },
              ),
              Consumer<Cart>(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.cart);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                builder: (ctx, cart, child) => bad.Badge(
                  value: cart.itemsCount.toString(),
                  spacing: 8,
                  child: child!,
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        color: Theme.of(context).colorScheme.outline,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(4),
              child: SearchWidget(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FilterWidget(),
            ),
            Expanded(
              child: ProductGrid(_showFavoriteOnly),
            ),
          ],
        ),
      ),
    );
  }
}
