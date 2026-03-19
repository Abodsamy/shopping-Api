import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://dummyjson.com";

  static Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['products'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> fetchCategoryProducts(String category) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/products/category/$category'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['products'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
