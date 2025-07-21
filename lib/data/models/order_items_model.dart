import 'package:gona_market_app/data/models/product_model.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int quantity;
  final String price;
  final ProductModel? product;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.product,
    required this.quantity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      quantity: json['quantity'],
      price: json['price'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product': product,
      'quantity': quantity,
      'price': price,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'OrderItem(product: $product, qty: $quantity, price: $price)';
  }
}
