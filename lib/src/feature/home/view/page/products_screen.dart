import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/utils/app_routes.dart';
import '../../../auth/view/widget/auth.dart';
import '../../repository/product_list.dart';
import '../widget/product_item.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context, listen: false);
    final ProductList products = Provider.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            ListView.builder(
              itemCount: products.itemsCount,
              itemBuilder: (ctx, i) => Column(
                children: [
                  if (products.items[i].userId == auth.userId)
                    ProductItem(products.items[i]),
                  if (products.items[i].userId == auth.userId) const Divider(),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () => AppRoutes.productsForm,
                child: const Text('Adicionar produto'))
          ],
        ),
      ),
    );
  }
}
