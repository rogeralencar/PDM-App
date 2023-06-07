import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/utils/app_routes.dart';
import '../../repository/product.dart';
import '../../repository/product_list.dart';
import 'product_grid_item.dart';

class ProductRecommendation extends StatefulWidget {
  const ProductRecommendation({super.key});

  @override
  State<ProductRecommendation> createState() => _ProductRecommendationState();
}

class _ProductRecommendationState extends State<ProductRecommendation> {
  List<Product> loadedProducts = [];
  int currentItemCount = 6;
  bool haveMoreProducts = true;
  bool isLoading = false;

  void loadMoreProducts() {
    if (isLoading || !haveMoreProducts) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        currentItemCount += 6;

        if (currentItemCount >= loadedProducts.length) {
          currentItemCount = loadedProducts.length;
          haveMoreProducts = false;
        }

        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    loadedProducts = provider.items;
    provider.updateProduct;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'We Recommend',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.productsOverview);
                },
                child: const Text(
                  'See all',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        SizedBox(
          height: 410,
          width: double.infinity,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.grey,
                ))
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: currentItemCount,
                      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                        value: loadedProducts[i],
                        child: const ProductGridItem(),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    );
                  },
                ),
        ),
        haveMoreProducts
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: const Text('Show More'),
                  onPressed: () {
                    loadMoreProducts();
                  },
                ),
              )
            : const SizedBox(height: 16)
      ],
    );
  }
}
