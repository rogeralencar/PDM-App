import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

import '../../../auth/view/widget/auth.dart';
import '../../repository/cart.dart';
import '../../repository/product.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (ctx, product, _) {
        final cart = Provider.of<Cart>(context, listen: false);
        final auth = Provider.of<Auth>(context, listen: false);
        bool startsWithFile =
            product.image.toString().toLowerCase().startsWith('https://');

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                onPressed: () {
                  product.toggleFavorite(
                    auth.token ?? '',
                    auth.userId ?? '',
                  );
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                product.name,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Produto adicionado com sucesso!'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'DESFAZER',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                  cart.addItem(product);
                },
              ),
            ),
            child: GestureDetector(
              child: Hero(
                tag: product.id,
                child: startsWithFile
                    ? FadeInImage(
                        placeholder: const AssetImage(
                            'lib/assets/images/product-placeholder.png'),
                        image: NetworkImage(product.image),
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        placeholder: const AssetImage(
                            'lib/assets/images/product-placeholder.png'),
                        image: FileImage(File(product.image)),
                        fit: BoxFit.cover,
                      ),
              ),
              onTap: () {
                Modular.to
                    .pushNamed('/home/productDetails', arguments: product);
              },
            ),
          ),
        );
      },
    );
  }
}
