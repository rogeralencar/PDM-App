import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repository/product_list.dart';
import '../widget/app_bar_widget.dart';
import '../widget/carousel.dart';
import '../widget/product_categories.dart';
import '../widget/product_recommendation.dart';

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
                children: [
                  const AppBarWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(18.0),
                      child: TextField(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          suffixIcon: const Icon(
                            Icons.search,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onChanged: (value) {
                          debugPrint(value);
                        },
                      ),
                    ),
                  ),
                  const Carousel(),
                  const ProductCategories(),
                  const ProductRecommendation(),
                ],
              ),
            ),
    );
  }
}
