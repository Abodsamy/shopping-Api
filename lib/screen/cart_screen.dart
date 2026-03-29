import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/cart_provider.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onCartUpdated;

  const CartScreen({super.key, required this.onCartUpdated});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.green,
      ),
      body: cart.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                final item = cart.cartItems[index];

                double price = (item['price'] ?? 0).toDouble();
                int quantity = (item['quantity'] ?? 1);

                return ListTile(
                  leading: Image.network(
                    item['thumbnail'] ?? '',
                    width: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                  title: Text(item['title'] ?? ''),
                  subtitle: Text(
                    "Price: \$${price} x $quantity = \$${(price * quantity).toString()}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      cart.removeItem(index);
                      widget.onCartUpdated();
                    },
                  ),
                );
              }),
      bottomNavigationBar: cart.cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Total: \$${cart.totalPrice()}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
