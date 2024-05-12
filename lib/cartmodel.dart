import 'package:flutter/material.dart';
import 'package:hairhub/test.dart';


class Cart {
  final int cartId;
  final int productId;
  final int quantity;
   final List<Product> items;

  
  Cart({
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.items
  });
  
}

