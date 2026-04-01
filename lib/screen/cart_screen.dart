import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/cart_provider.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onCartUpdated;

  const CartScreen({
    super.key,
    required this.onCartUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.green,
      ),
      body: cart.cartItems.isEmpty
          ? const Center(
        child: Text("Cart is empty"),
      )
          : ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) {
          final item = cart.cartItems[index];

          return ListTile(
            leading: Image.network(
              item['thumbnail'],
              width: 50,
            ),
            title: Text(
              item['title'],
            ),
            subtitle: Text(
              "Price: \$${item['price']} x ${item['quantity']} = \$${item['price'] * item['quantity']}",
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                cart.removeItem(index);
              },
            ),
          );
        },
      ),
      bottomNavigationBar:
      cart.cartItems.isNotEmpty
          ? Padding(
        padding:
        const EdgeInsets.all(16.0),
        child: Text(
          "Total: \$${cart.totalPrice()}",
          style:
          const TextStyle(
            fontSize: 20,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      )
          : null,
    );
  }
}