import 'package:gona_market_app/data/models/cart_item_model.dart';

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double totalAmount;
  final String userId;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.userId,
    required this.status,
    required this.createdAt,
  });

  // Factory method to create an OrderModel from a JSON object
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      items: (json['items'] as List).map((item) => CartItemModel.fromJson(item)).toList(),
      totalAmount: json['total_amount'],
      userId: json['user_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method to convert an OrderModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'user_id': userId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
