import 'package:flutter/material.dart';
import '../widget/cart_data.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onCartUpdated;

  const CartScreen({super.key, required this.onCartUpdated});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart"), backgroundColor: Colors.green),
      body: CartData.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : ListView.builder(
              itemCount: CartData.cartItems.length,
              itemBuilder: (context, index) {
                final item = CartData.cartItems[index];
                if (item is Map<String, dynamic>) {
                  return ListTile(
                    leading: Image.network(item['thumbnail'], width: 50),
                    title: Text(item['title']),
                    subtitle: Text(
                        "Price: \$${item['price']} x ${item['quantity']} = \$${(item['price'] * item['quantity']).toString()}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          CartData.cartItems.removeAt(index);
                          widget.onCartUpdated();
                        });
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
      bottomNavigationBar: CartData.cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Total: \$${CartData.totalPrice()}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
