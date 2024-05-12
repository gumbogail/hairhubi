import 'package:flutter/material.dart';
import 'package:hairhub/cartmodel.dart'; // Assuming you have a Cart class defined

class CartItems extends StatelessWidget {
  final Cart cart;

  const CartItems({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
            leading: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              width: 50, // Adjust the image size as needed
              height: 50,
            ),
            // You can add more functionality to the list tile if needed
          );
        },
      ),
    );
  }
}
