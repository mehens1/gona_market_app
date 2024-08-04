import 'package:gona_market_app/data/models/product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  // Factory method to create a CartItemModel from a JSON object
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  // Method to convert a CartItemModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
