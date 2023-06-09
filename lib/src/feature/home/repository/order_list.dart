import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localization/localization.dart';

import '../../../common/exceptions/http_exception.dart';
import '../../auth/repository/user_model.dart';
import 'cart.dart';
import 'cart_item.dart';
import 'order.dart';
import '../../../common/utils/constants.dart';
import 'product_list.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final response = await http.get(
      Uri.parse('${Constants.ordersBaseUrl}/$_userId.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          cep: orderData['cep'],
          city: orderData['city'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              name: item['name'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });

    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart, ProductList productList, User user) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constants.ordersBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'cep': user.cep,
          'city': user.city,
          'products': cart.items.values
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                },
              )
              .toList(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];

    for (var cartItem in cart.items.values) {
      final product = productList.findProductById(cartItem.productId);

      if (product != null) {
        final newOrders = product.orders + cartItem.quantity;
        await product.updateOrders(_token, newOrders);
      } else {
        throw HttpException(
          msg: 'error_message_order'.i18n(),
          statusCode: response.statusCode,
        );
      }
    }

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        date: date,
        cep: user.cep!,
        city: user.city!,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
