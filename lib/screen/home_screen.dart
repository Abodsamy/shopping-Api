import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/product_card.dart';
import '../widget/categories.dart';
import '../http.dart';
import '../widget/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onCartUpdated;

  const HomeScreen({super.key, required this.onCartUpdated});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    products = await ApiService.fetchProducts();
    setState(() => isLoading = false);
  }

  void addToCart(Map<String, dynamic> product) {
    Provider.of<CartProvider>(
      context,
      listen: false,
    ).addItem(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Added to Cart"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (products.isNotEmpty)
                      Categories(
                        title: "Food",
                        image: products[0]['thumbnail'],
                        category: "groceries",
                        onCartUpdated: widget.onCartUpdated,
                      ),
                    if (products.length > 1)
                      Categories(
                        title: "Makeup",
                        image: products[1]['thumbnail'],
                        category: "beauty",
                        onCartUpdated: widget.onCartUpdated,
                      ),
                    if (products.length > 2)
                      Categories(
                        title: "Furniture",
                        image: products[2]['thumbnail'],
                        category: "furniture",
                        onCartUpdated: widget.onCartUpdated,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.60,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      List<String> images = [];

                      if (product['images'] != null) {
                        images = List<String>.from(
                          product['images'],
                        );
                      } else if (product['thumbnail'] != null) {
                        images = [product['thumbnail']];
                      }

                      return ProductCard(
                        title: product['title'] ?? 'No title',
                        price: product['price']?.toString() ?? '0',
                        images: images,
                        rating: (product['rating'] ?? 0).toDouble(),
                        onAddToCart: () => addToCart(product),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
