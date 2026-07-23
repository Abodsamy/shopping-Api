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

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    fetchCategoryProducts();
  }

  Future<void> fetchCategoryProducts() async {
    try {
      setState(() {
        isLoading = true;

        errorMessage = null;
      });

      final response = await http.get(
        Uri.parse(
          'https://dummyjson.com/products/category/${widget.category}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          products = data['products'] ?? [];

          isLoading = false;
        });
      } else {
        throw Exception();
      }
    } catch (e) {
      setState(() {
        products = [];

        isLoading = false;

        errorMessage = "Something went wrong";
      });
    }
  }

  void addToCart(Map<String, dynamic> product) {
    CartData.addItem(product);

    widget.onCartUpdated();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Added to cart successfully",
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.category.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: fetchCategoryProducts,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: fetchCategoryProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            "Try Again",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : products.isEmpty
                    ? const Center(
                        child: Text(
                          "No Products Found",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];

                          List<String> images = [];

                          if (product['images'] != null &&
                              product['images'].isNotEmpty) {
                            images = List<String>.from(
                              product['images'],
                            );
                          } else if (product['thumbnail'] != null &&
                              product['thumbnail'].toString().isNotEmpty) {
                            images = [product['thumbnail'].toString()];
                          }

                          return ProductCard(
                            title: product['title'] ?? "No title",
                            price: product['price']?.toString() ?? "0",
                            images: images,
                            rating: (product['rating'] ?? 0).toDouble(),
                            onAddToCart: () {
                              addToCart(product);
                            },
                          );
                        },
                      ),
      ),
    );
  }
}
