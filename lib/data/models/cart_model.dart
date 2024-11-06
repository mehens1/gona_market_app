// cart_model.dart
import 'dart:convert';
import 'cart_item_model.dart';

class CartModel {
  final String id; // Unique identifier for the cart
  final List<CartItemModel> items; // List of items in the cart

  CartModel({
    required this.id,
    required this.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
