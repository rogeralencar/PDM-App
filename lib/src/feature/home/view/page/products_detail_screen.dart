import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

import '../../repository/cart.dart';
import '../../repository/product.dart';
import 'map_screen.dart';

class ProductsDetailScreen extends StatefulWidget {
  const ProductsDetailScreen({Key? key}) : super(key: key);

  @override
  ProductsDetailScreenState createState() => ProductsDetailScreenState();
}

class ProductsDetailScreenState extends State<ProductsDetailScreen> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    bool startsWithFile =
        product.image.toString().toLowerCase().startsWith('https://');

    return Scaffold(
      body: SafeArea(
        child: MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: 1),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(product.name),
                  centerTitle: true,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: product.id,
                        child: startsWithFile
                            ? Image.network(
                                product.image,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(product.image),
                                fit: BoxFit.cover,
                              ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0, 0.8),
                            end: Alignment(0, 0),
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0.6),
                              Color.fromRGBO(0, 0, 0, 0)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'R\$ ${product.price}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Produto adicionado com sucesso!'),
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
                          const SizedBox(height: 10),
                          IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              Modular.to.pushNamed('');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Descrição:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description,
                            textAlign: TextAlign.justify,
                            maxLines: showFullDescription ? null : 3,
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (product.description.length > 3)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showFullDescription = !showFullDescription;
                                });
                              },
                              child: Text(
                                showFullDescription
                                    ? 'Mostrar Menos'
                                    : 'Mostrar Mais',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          const Text(
                            'Endereço:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.location.address!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                              icon: const Icon(Icons.map),
                              label: const Text('Ver no Mapa'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (ctx) => MapScreen(
                                      isReadOnly: true,
                                      initialLocation: product.location,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
