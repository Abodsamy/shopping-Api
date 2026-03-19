import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widget/product_card.dart';
import '../widget/cart_data.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final VoidCallback onCartUpdated;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.onCartUpdated,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  Future<void> fetchCategoryProducts() async {
    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/category/${widget.category}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data['products'];
        isLoading = false;
      });
    } else {
      setState(() {
        products = [];
        isLoading = false;
      });
    }
  }

  void addToCart(Map<String, dynamic> product) {
    CartData.addItem(product);
    widget.onCartUpdated();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Added to Cart")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                List<String> images = [];
                if (product['images'] != null) {
                  images = List<String>.from(product['images']);
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
    );
  }
}
