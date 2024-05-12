import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hairhub/cart.dart';
import 'package:hairhub/cartmodel.dart';
import 'package:http/http.dart' as http;
import 'test.dart';

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
                    const SizedBox(height: 4.0),
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
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            // Navigate to the cart page
            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CartItems(
      cart: Cart(
        cartId: 0, // Provide the cartId parameter here
        productId: 0, // Provide the productId parameter here
        quantity: 0, // Provide the quantity parameter here
        items: [], // Provide the items parameter here
      ),
    ),
  ),
);


            // Add the product to the cart
            addToCart(product);
          },
        ),
      ],
    ),
  );
}

void addToCart(Product product) async {
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