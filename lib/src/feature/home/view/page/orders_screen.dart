import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

import '../../repository/order_list.dart';
import '../widget/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    final bool withoutOrders = orders.items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Modular.to.pop();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: withoutOrders
            ? const Center(
                child: Text(
                  'Você ainda não realizou nenhuma compra!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
              ),
      ),
    );
  }
}
