import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/models/order_model.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class OrderRepository {
  final ApiService apiService;

  OrderRepository(this.apiService);

  Future<List<OrderModel>> getOrders() async {
    final response = await apiService.get('/orders/my-orders');
    final data = response.data;

    if (data['status'] == true) {
      final orderList = data['data'] as List<dynamic>;
      return orderList
          .map((orderJson) => OrderModel.fromJson(orderJson))
          .toList();
    } else {
      throw Exception("Failed to parse orders");
    }
  }

  Future<OrderModel> getOrderDetails(String orderId) async {
    final response = await apiService.get('/orders/$orderId');
    final data = response.data;
    if (data['status'] == true) {
      return OrderModel.fromJson(data['data']);
    } else {
      throw Exception("Failed to fetch order details");
    }
  }

  Future<dynamic> submitOrder(String type, dynamic data) async {
    try {
      String endpoint;
      if (type == 'card') {
        endpoint = '/payment/charge-card-monnify';
      } else if (type == 'transfer') {
        endpoint = '/payment/charge-transfer-monnify';
      } else {
        throw ArgumentError('Unsupported payment type: $type');
      }

      final response = await apiService.post(endpoint, data: data);
      return response; // Return response normally
    } on ArgumentError catch (e) {
      rethrow;
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Future submitOTP(dynamic data) async {
    try {
      final response =
          await apiService.post('/payment/autorized-otp', data: data);
      return response;
    } on ArgumentError catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
