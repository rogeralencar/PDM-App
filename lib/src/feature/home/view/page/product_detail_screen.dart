import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';
import '../../repository/cart.dart';
import '../../repository/product.dart';
import 'map_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _showFullDescription = false;
  bool _isLoading = false;

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('error_occurred'.i18n()),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('close'.i18n()),
          ),
        ],
      ),
    );
  }

  Future<void> _profileButtonSummit(Product product) async {
    setState(() => _isLoading = true);

    try {
      User user = await Provider.of<UserProvider>(
            context,
            listen: false,
          ).loadUser(
            userId: product.userId,
            isAnotherUser: true,
          ) ??
          User();
      Modular.to.pushNamed('profile', arguments: user);
    } catch (error) {
      _showErrorDialog('unexpected_error'.i18n());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);
    bool startsWithFile =
        widget.product.image.toString().toLowerCase().startsWith('https://');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.outline,
              ),
            )
          : SafeArea(
              child: MediaQuery(
                data: mediaQuery.copyWith(textScaleFactor: 1),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      startsWithFile
                          ? Image.network(
                              widget.product.image,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(widget.product.image),
                              fit: BoxFit.cover,
                            ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'R\$ ${widget.product.price}',
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
                                  content: Text('success_message'.i18n()),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'undo'.i18n(),
                                    onPressed: () {
                                      cart.removeSingleItem(widget.product.id);
                                    },
                                  ),
                                ),
                              );
                              cart.addItem(widget.product);
                            },
                          ),
                          const SizedBox(height: 10),
                          IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              _profileButtonSummit(widget.product);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'description'.i18n(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.description,
                        textAlign: TextAlign.justify,
                        maxLines: _showFullDescription ? null : 3,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (widget.product.description.length > 3)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showFullDescription = !_showFullDescription;
                            });
                          },
                          child: Text(
                            _showFullDescription
                                ? 'show_less'.i18n()
                                : 'show_more'.i18n(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        'address'.i18n(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.location.address!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          icon: const Icon(Icons.map),
                          label: Text('view_on_map'.i18n()),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (ctx) => MapScreen(
                                  isReadOnly: true,
                                  initialLocation: widget.product.location,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
