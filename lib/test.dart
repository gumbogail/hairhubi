import 'package:flutter/material.dart';
import 'package:hairhub/cart.dart';
import 'package:hairhub/cartmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product(this.name, this.price, this.imageUrl);
}

class ProductListScreen1 extends StatelessWidget {
  const ProductListScreen1({Key? key});

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
    const String baseUrl = 'http://192.168.1.41/php_scripts'; // Replace with your base URL

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
          ),
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
               Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CartItems(
      cart: Cart(
        cartId: 0, // Provide the cartId parameter here
        productId: 0, // Provide the productId parameter here
        quantity: 0, // Provide the quantity parameter here
        items: [], // Provide the items parameter here
              // Implement add to cart functionality here
      )
    )
  )
  );
               addToCart(product);
            },
          ),
      
        ],
      ),
    );
  }

  Future<void> addToCart(Product product) async {
    // Implement logic to add the product to the cart
    // For example, you can use Provider or another state man
    //agement solution
     try {
    // Make a POST request to your server-side script with the product data
    final response = await http.post(
      Uri.parse('http://192.168.1.41/php_scripts/cart.php'),
      body: {
        'name': product.name,
        'price': product.price.toString(),
        'imageUrl': product.imageUrl,
      },
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the response JSON data (if any)
      final responseData = json.decode(response.body);
      
      // Handle the response data as needed
      // For example, you can show a message confirming that the item was added to the cart
      print(responseData['message']);
    } else {
      // Handle unsuccessful request (e.g., display an error message)
      print('Failed to add item to cart. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error adding item to cart: $e');
  }
}
}