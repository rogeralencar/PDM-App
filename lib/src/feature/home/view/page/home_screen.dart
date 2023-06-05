import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: ListView(
                children: const [
                  AppBarWidget(),
                  SearchWidget(),
                  Carousel(),
                  ProductCategories(),
                  ProductRecommendation(),
                ],
              ),
            ),
    );
  }
}
