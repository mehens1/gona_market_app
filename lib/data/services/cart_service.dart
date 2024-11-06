import 'package:gona_market_app/data/models/cart_model.dart';
import 'api_service.dart';

class CartService {
  final ApiService _apiService;

  CartService(this._apiService);

  Future<CartModel> fetchCart(String cartId) async {
    try {
      final response = await _apiService.getById('carts', id: cartId);
      return CartModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel> createCart(CartModel cartModel) async {
    try {
      final response = await _apiService.post('carts', data: cartModel.toJson());
      return CartModel.fromJson(response.data);
    } catch (e) {
      rethrow; // Handle or log the error as needed
    }
  }

  Future<CartModel> updateCart(CartModel cartModel) async {
    try {
      final response = await _apiService.put('carts/${cartModel.id}', data: cartModel.toJson());
      return CartModel.fromJson(response.data);
    } catch (e) {
      rethrow; // Handle or log the error as needed
    }
  }
}
