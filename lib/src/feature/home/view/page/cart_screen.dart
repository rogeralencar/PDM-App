import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/repository/user_provider.dart';
import '../../repository/cart.dart';
import '../../repository/order_list.dart';
import '../../repository/product_list.dart';
import '../widget/cart_item.dart';
import '../widget/cep_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: CepWidget(),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CartItemWidget(items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Informe seu CEP'),
        content: const Text('Nao foi possivel encontrar um cep na sua conta'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user!;
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : user.cep == ''
                    ? () => _showErrorDialog()
                    : () async {
                        setState(() => _isLoading = true);

                        await Provider.of<OrderList>(
                          context,
                          listen: false,
                        ).addOrder(widget.cart, provider, user);

                        widget.cart.clear();
                        setState(() => _isLoading = false);
                      },
            child: const Text('COMPRAR'),
          );
  }
}
