import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/order_model.dart';
import 'package:gona_market_app/data/repositories/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository orderRepository;
  List<OrderModel> _orders = [];

  OrderProvider(this.orderRepository);

  List<OrderModel> get orders => _orders;

  // Future<void> fetchOrders(String userId) async {
  Future<void> fetchOrders() async {
    try {
      _orders = await orderRepository.getOrders();
      notifyListeners();
    } catch (error) {
      debugPrint('Failed to fetch orders: $error');
    }
  }

  OrderModel? _selectedOrder;

  OrderModel? get selectedOrder => _selectedOrder;

  Future<void> fetchOrderDetails(String orderId) async {
    try {
      _selectedOrder = await orderRepository.getOrderDetails(orderId);
      notifyListeners();
    } catch (error) {
      debugPrint('Failed to fetch order details: $error');
    }
  }

  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }
}
