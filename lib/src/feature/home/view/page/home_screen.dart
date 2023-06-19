import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/repository/user_provider.dart';
import '../../repository/order_list.dart';
import '../../repository/product_list.dart';
import '../widget/app_bar_widget.dart';
import '../widget/carousel.dart';
import '../widget/product_categories.dart';
import '../widget/product_recommendation.dart';
import '../widget/search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<UserProvider>(
      context,
      listen: false,
    ).loadUser().then((_) {
      Provider.of<ProductList>(
        context,
        listen: false,
      ).loadProducts().then((_) {
        Provider.of<OrderList>(
          context,
          listen: false,
        ).loadOrders().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.outline,
            ))
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              color: Theme.of(context).colorScheme.outline,
              child: ListView(
                children: [
                  const AppBarWidget(),
                  SearchWidget(),
                  const Carousel(),
                  const ProductCategories(),
                  const ProductRecommendation(),
                ],
              ),
            ),
    );
  }
}
