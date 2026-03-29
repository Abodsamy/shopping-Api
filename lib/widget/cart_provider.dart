import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CartProvider extends ChangeNotifier {
  final Box cartBox = Hive.box('cartBox');

  List<Map<String, dynamic>> get cartItems {
    final List data = cartBox.get('cart', defaultValue: []);

    return data
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  void addItem(Map<String, dynamic> product) {
    List items = cartItems;

    int index = items.indexWhere(
      (item) => item['title'] == product['title'],
    );

    if (index != -1) {
      items[index]['quantity'] = ((items[index]['quantity'] ?? 1) + 1);
    } else {
      items.add({
        'title': product['title'],
        'price': product['price'],
        'thumbnail': product['thumbnail'],
        'rating': product['rating'],
        'quantity': 1,
      });
    }

    cartBox.put('cart', items);

    notifyListeners();
  }

  void removeItem(int index) {
    List items = cartItems;

    items.removeAt(index);

    cartBox.put('cart', items);

    notifyListeners();
  }

  void clearCart() {
    cartBox.put('cart', []);

    notifyListeners();
  }

  int totalItems() {
    return cartItems.fold(
      0,
      (sum, item) => sum + ((item['quantity'] ?? 1) as int),
    );
  }

  double totalPrice() {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + ((item['price'] ?? 0) * (item['quantity'] ?? 1)),
    );
  }
}
