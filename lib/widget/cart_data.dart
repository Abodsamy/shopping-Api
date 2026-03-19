class CartData {
  static List<Map<String, dynamic>> cartItems = [];

  static void addItem(Map<String, dynamic> product) {
    final existingIndex = cartItems.indexWhere(
      (item) => item['title'] == product['title'],
    );

    if (existingIndex != -1) {
      var item = cartItems[existingIndex];
      item['quantity'] = ((item['quantity'] ?? 1) + 1).toInt();
    } else {
      final cartItem = {
        'title': product['title'] ?? 'No title',
        'price': (product['price'] ?? 0).toDouble(),
        'thumbnail': product['thumbnail'] ?? '',
        'rating': (product['rating'] ?? 0.0).toDouble(),
        'quantity': 1,
      };
      cartItems.add(cartItem);
    }
  }

  static void removeItem(Map<String, dynamic> product) {
    cartItems.removeWhere((item) => item['title'] == product['title']);
  }

  static void clearCart() {
    cartItems.clear();
  }

  static int totalItems() {
    return cartItems.fold(
      0,
      (sum, item) => sum + ((item['quantity'] ?? 1) as int),
    );
  }

  static double totalPrice() {
    return cartItems.fold(
      0.0,
      (sum, item) =>
          sum +
          ((item['price'] ?? 0).toDouble() * ((item['quantity'] ?? 1) as int)),
    );
  }
}
