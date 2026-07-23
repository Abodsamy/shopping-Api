import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../widget/product_card.dart';
import '../widget/categories.dart';
import '../widget/cart_provider.dart';
import '../cubit/product_cubit.dart';

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
    return BlocProvider(
      create: (_) => ProductCubit()..fetchProducts(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Shopping App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            }

            if (state is ProductError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductLoaded) {
              final products = state.products;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductCubit>().fetchProducts();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome 👋",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Find your favorite products",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color
                                    ?.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 120,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                            ),
                            const SizedBox(height: 25),
                            Text(
                              "Popular Products",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];

                            List<String> images = [];

                            if (product['images'] != null &&
                                product['images'].isNotEmpty) {
                              images = List<String>.from(product['images']);
                            } else if (product['thumbnail'] != null) {
                              images = [product['thumbnail'].toString()];
                            }

                            return ProductCard(
                              title: product['title'] ?? "No title",
                              price: product['price']?.toString() ?? "0",
                              images: images,
                              rating: (product['rating'] ?? 0).toDouble(),
                              onAddToCart: () {
                                addToCart(
                                  context,
                                  product,
                                );
                              },
                            );
                          },
                          childCount: products.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                      ),
                    ),
                  ],
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
