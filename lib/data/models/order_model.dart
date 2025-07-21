import 'package:gona_market_app/data/models/order_items_model.dart';

class OrderModel {
  final int id;
  final int userId;
  final String paymentReference;
  final String transactionReference;
  final String amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem>? items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.paymentReference,
    required this.transactionReference,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  // Factory method to create an OrderModel from a JSON object
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      paymentReference: json['payment_reference'],
      transactionReference: json['transaction_reference'],
      amount: json['amount'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : null,
    );
  }

  // Method to convert an OrderModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'status': status,
      'payment_reference': paymentReference,
      'transaction_reference': transactionReference,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, status: $status, paymentReference: $paymentReference, transaction_reference: $transactionReference, amount: $amount, createdAt: $createdAt, items: $items)';
  }
}
