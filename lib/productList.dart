import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product(this.name, this.price, this.imageUrl);
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HairHub - Products'),
        backgroundColor: const Color.fromARGB(255, 252, 241, 241),
        elevation: 0,
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            final productList = snapshot.data!;
            if (productList.isNotEmpty) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                  crossAxisSpacing: 8.0, // Spacing between columns
                  childAspectRatio: 0.75, // Aspect ratio of each grid item (adjust as needed)
                ),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return ProductItem(product: productList[index]);
                },
              );
            } else {
              return const Center(child: Text('No products available'));
            }
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    const String baseUrl = 'http://192.168.113.36/php_scripts'; // Replace with your base URL

    try {
      final response = await http.get(Uri.parse('$baseUrl/product.php'));

      if (response.statusCode == 200) {
        final List<dynamic> productList = json.decode(response.body);
        List<Product> products = productList.map((json) => Product(
          json['name'] ?? '',
          double.parse(json['price'] ?? '0.0'),
          json['imageUrl'] ?? '',
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

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
