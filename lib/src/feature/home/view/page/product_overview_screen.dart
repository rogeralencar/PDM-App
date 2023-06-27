import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../repository/categories_data.dart';
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

class ProductOverviewScreen extends StatefulWidget {
  final List<String>? selectedCategoriesNames;
  final String? search;

  const ProductOverviewScreen({
    Key? key,
    this.selectedCategoriesNames,
    this.search,
  }) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  late String _search = '';
  late List<String> _selectedCategoriesNames = [];
  String _selectedSortOption = 'top_selling'.i18n();
  bool _showFavoriteOnly = false;

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  void _searchSubmitted(String value) {
    setState(() {
      _search = value;
    });
  }

  void _changeSortOption(String? value) {
    setState(() {
      _selectedSortOption = value ?? '';
    });
  }

  void _selectCategory() async {
    final updatedCategories = await Modular.to.pushNamed(
      'categories',
      arguments: {'selectedCategoriesNames': _selectedCategoriesNames},
    );

    if (updatedCategories != null) {
      List<Category> selectedCategories = categoryList
          .where((category) =>
              (updatedCategories as List<String>).contains(category.name))
          .toList();

      setState(() {
        _selectedCategoriesNames =
            selectedCategories.map((category) => category.name).toList();
      });
    }
  }

  @override
  void initState() {
    _selectedCategoriesNames = widget.selectedCategoriesNames ?? [];
    _search = widget.search ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('app_name'.i18n()),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: FilterOptions.favorite,
                    child: Text('favorites'.i18n()),
                  ),
                  PopupMenuItem(
                    value: FilterOptions.all,
                    child: Text('all'.i18n()),
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
                    Modular.to.pushNamed('/home/cart');
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
            Padding(
              padding: const EdgeInsets.all(4),
              child: SearchWidget(
                  searchSubmitted: _searchSubmitted, search: _search),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FilterWidget(
                selectCategory: _selectCategory,
                changeSortOption: _changeSortOption,
                selectedFilter: _selectedSortOption,
              ),
            ),
            Expanded(
              child: ProductGrid(
                _showFavoriteOnly,
                _selectedCategoriesNames,
                _search,
                _selectedSortOption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
