import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/home_screen.dart';
import '../screen/cart_screen.dart';
import '../screen/profile_screen.dart';
import '../widget/cart_provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onCartUpdated() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final pages = [
      HomeScreen(
        onCartUpdated: _onCartUpdated,
      ),
      CartScreen(
        onCartUpdated: _onCartUpdated,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDark ? 0.5 : 0.15,
              ),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: theme.cardColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.green,
            unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart_rounded,
                    ),
                    if (cart.cartItems.isNotEmpty)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cart.totalItems().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: "Cart",
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_rounded,
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
