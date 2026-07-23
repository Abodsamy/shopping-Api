import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CartProvider extends ChangeNotifier {
  final Box box = Hive.box('cartBox');

  List<Map<String, dynamic>> cartItems = [];

  CartProvider() {
    loadCart();
  }

  void loadCart() {
    final data = box.get('cartItems');

    if (data != null) {
      cartItems = (data as List)
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();
    }

    notifyListeners();
  }

  void saveCart() {
    box.put(
      'cartItems',
      cartItems,
    );
  }

  void addItem(Map<String, dynamic> product) {
    final index = cartItems.indexWhere(
      (item) => item['title'] == product['title'],
    );

    if (index != -1) {
      cartItems[index]['quantity'] = (cartItems[index]['quantity'] ?? 0) + 1;
    } else {
      cartItems.add({
        'title': product['title'] ?? '',
        'price': product['price'] ?? 0,
        'thumbnail': product['thumbnail'] ?? '',
        'rating': product['rating'] ?? 0,
        'quantity': 1,
      });
    }

    saveCart();

    notifyListeners();
  }

  void removeItem(int index) {
    cartItems.removeAt(index);

    saveCart();

    notifyListeners();
  }

  int totalItems() {
    return cartItems.fold(
      0,
      (sum, item) => sum + ((item['quantity'] ?? 0) as int),
    );
  }

  double totalPrice() {
    return cartItems.fold(
      0.0,
      (sum, item) =>
          sum + ((item['price'] ?? 0) * (item['quantity'] ?? 0)).toDouble(),
    );
  }

  void clearCart() {
    cartItems.clear();

    saveCart();

    notifyListeners();
  }
}
