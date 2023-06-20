import 'cart_item.dart';

class Order {
  final String id;
  final double total;
  final String cep;
  final String city;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.cep,
    required this.city,
    required this.products,
    required this.date,
  });
}
