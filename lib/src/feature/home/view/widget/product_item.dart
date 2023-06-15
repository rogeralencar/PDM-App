import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

import '../../repository/product.dart';
import '../../repository/product_list.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(
    this.product, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool startsWithFile =
        product.image.toString().toLowerCase().startsWith('https://');
    return ListTile(
      leading: startsWithFile
          ? CircleAvatar(
              backgroundImage: NetworkImage(product.image),
            )
          : CircleAvatar(
              backgroundImage: FileImage(File(product.image)),
            ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Modular.to.pushNamed('products', arguments: product);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Excluir Produto'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                        child: const Text('Não'),
                        onPressed: () => Modular.to.pop(false),
                      ),
                      TextButton(
                        child: const Text('Sim'),
                        onPressed: () => Modular.to.pop(true),
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value ?? false) {
                    Provider.of<ProductList>(
                      context,
                      listen: false,
                    ).removeProduct(product);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
