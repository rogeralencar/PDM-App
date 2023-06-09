import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

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
    loadedProducts.sort((a, b) => b.orders.compareTo(a.orders));

    provider.updateProduct;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'top_selling'.i18n(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Modular.to.pushNamed('productOverview/', arguments: {});
                },
                child: Text(
                  'see_all'.i18n(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
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
              ? Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.outline,
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
                  child: Text('show_more'.i18n()),
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
