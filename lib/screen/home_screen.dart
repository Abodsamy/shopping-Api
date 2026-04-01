import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/product_card.dart';
import '../widget/categories.dart';
import '../widget/cart_provider.dart';
import '../cubit/product_cubit.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onCartUpdated;

  const HomeScreen({
    super.key,
    required this.onCartUpdated,
  });

  void addToCart(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    final cart = context.read<CartProvider>();

    cart.addItem(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Added to Cart",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..fetchProducts(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Home Screen",
          ),
          backgroundColor: Colors.green,
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProductLoaded) {
              final products = state.products;

              return Column(
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
                          onCartUpdated: onCartUpdated,
                        ),
                      if (products.length > 1)
                        Categories(
                          title: "Makeup",
                          image: products[1]['thumbnail'],
                          category: "beauty",
                          onCartUpdated: onCartUpdated,
                        ),
                      if (products.length > 2)
                        Categories(
                          title: "Furniture",
                          image: products[2]['thumbnail'],
                          category: "furniture",
                          onCartUpdated: onCartUpdated,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
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
                          onAddToCart: () => addToCart(
                            context,
                            product,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is ProductError) {
              return Center(
                child: Text(
                  state.message,
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
