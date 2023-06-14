import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../../../common/exceptions/http_exception.dart';
import '../../../common/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  final List<Product> _items;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.where((product) => product.userId == _userId).length;
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'),
    );
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse(
        '${Constants.userFavoritesUrl}/$_userId.json?auth=$_token',
      ),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final categoryValue = productData['category'];
      final categoriesList = categoryValue is List<dynamic>
          ? List<String>.from(categoryValue)
          : [categoryValue.toString()];
      final isFavorite = favData[productId] ?? false;
      _items.add(
        Product(
          userId: productData['userId'],
          id: productId,
          name: productData['name'],
          description: productData['description'],
          category: categoriesList,
          price: productData['price'],
          orders: productData['orders'],
          image: productData['image'],
          isFavorite: isFavorite,
          location: PlaceLocation(
            latitude: productData['latitude'],
            longitude: productData['longitude'],
            address: productData['address'],
          ),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data, bool isImageUrl) {
    bool hasId = data['id'] != null;

    final product = Product(
      userId: _userId,
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      category: data['category'] as List<String>,
      price: data['price'] as double,
      orders: 0,
      image: data['image'],
      location: PlaceLocation(
        latitude: data['latitude'] as double,
        longitude: data['longitude'] as double,
        address: data['address'] as String,
      ),
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product, isImageUrl);
    }
  }

  Future<void> addProduct(Product product, bool isImageUrl) async {
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
    final response = await http.post(
      Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'),
      body: jsonEncode(
        {
          "address": product.location.address,
          "category": product.category,
          "description": product.description,
          "image": image,
          "latitude": product.location.latitude,
          "longitude": product.location.longitude,
          "name": product.name,
          "orders": 0,
          "price": product.price,
          "userId": product.userId,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
      userId: _userId,
      id: id,
      name: product.name,
      description: product.description,
      category: product.category,
      price: product.price,
      orders: 0,
      image: image,
      location: PlaceLocation(
        latitude: product.location.latitude,
        longitude: product.location.longitude,
        address: product.location.address,
      ),
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.productBaseUrl}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "userId": product.userId,
            "name": product.name,
            "description": product.description,
            "category": product.category,
            "price": product.price,
            "orders": product.orders,
            "image": product.image,
            "latitude": product.location.latitude,
            "longitude": product.location.longitude,
            "address": product.location.address,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response1 = await http.delete(
        Uri.parse(
            '${Constants.productBaseUrl}/${product.id}.json?auth=$_token'),
      );

      if (response1.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response1.statusCode,
        );
      }
    }
  }
}
