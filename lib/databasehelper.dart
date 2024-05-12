
import 'dart:convert';
import 'package:hairhub/productList.dart';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  // static final DatabaseHelper _instance = DatabaseHelper.internal();

  // factory DatabaseHelper() => _instance;

  // DatabaseHelper.internal();

 final String baseUrl = 'http://192.168.113.36/php_scripts'; // Replace with your base URL

Future<List<Product>> fetchProducts() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/product.php'));

    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);
      // Convert dynamic list to list of Product objects
      List<Product> products = productList.map((json) => Product(
        json['name'],
        double.parse(json['price']),
        json['imageUrl']
      )).toList();
      return products;
    } else {
      throw Exception('Failed to load products. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server: $e');
  }
}



  

}
