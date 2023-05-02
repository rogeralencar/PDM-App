import 'dart:math';
import 'package:flutter/material.dart';

import 'product.dart';
import '../../feature/home/repository/product_store.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = products;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  void saveProduct(Map<String, Object> data, bool isImageUrl) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      image: data['image'],
      location: PlaceLocation(
        latitude: data['latitude'] as double,
        longitude: data['longitude'] as double,
        address: data['address'] as String,
      ),
    );

    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product, isImageUrl);
    }
  }

  void addProduct(Product product, bool isImageUrl) {
    var image = "";
    if (isImageUrl) {
      image = product.image.toString();
    } else {
      image = product.image
          .toString()
          .replaceAll("'", "")
          .replaceFirst("F", "")
          .replaceFirst("i", "")
          .replaceFirst("l", "")
          .replaceFirst("e", "")
          .replaceFirst(":", "")
          .replaceFirst(" ", "");
    }
    final updatedProduct = Product(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      image: image,
      location: product.location,
      isFavorite: product.isFavorite,
    );
    _items.add(updatedProduct);
    notifyListeners();
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }
}
