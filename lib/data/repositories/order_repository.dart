import 'package:gona_market_app/data/models/cart_model.dart';
import 'package:gona_market_app/data/models/order_model.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class OrderRepository {
  final ApiService apiService;

  OrderRepository(this.apiService);

  Future<List<OrderModel>> getOrders(String userId) async {
    final response = await apiService.get('/orders', queryParameters: {'user_id': userId});
    return (response.data as List)
        .map((orderJson) => OrderModel.fromJson(orderJson))
        .toList();
  }

  Future<OrderModel> placeOrder(CartModel cart) async {
    final response = await apiService.post('/orders', data: cart.toJson());
    return OrderModel.fromJson(response.data);
  }
}
