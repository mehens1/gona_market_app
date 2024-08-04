import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/cart_model.dart';
import 'package:gona_market_app/data/models/order_model.dart';
import 'package:gona_market_app/data/repositories/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository orderRepository;
  List<OrderModel> _orders = []; // Initialize as an empty list

  OrderProvider(this.orderRepository);

  List<OrderModel> get orders => _orders;

  // Fetch orders for a specific user ID
  Future<void> fetchOrders(String userId) async {
    try {
      _orders = await orderRepository.getOrders(userId);
      notifyListeners();
    } catch (error) {
      // Handle errors or show a message to the user
      print('Failed to fetch orders: $error');
    }
  }

  // Place an order and refresh the orders list
  Future<void> placeOrder(CartModel cart) async {
    try {
      await orderRepository.placeOrder(cart);
      // Assuming you want to refresh the orders list after placing an order
      // You need to pass userId or another way to fetch updated orders
      // fetchOrders(currentUserId); // Example
    } catch (error) {
      // Handle errors or show a message to the user
      print('Failed to place order: $error');
    }
  }
}
