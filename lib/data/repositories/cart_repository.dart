import 'dart:convert';
import 'package:gona_market_app/core/services/local_storage_service.dart';
import 'package:gona_market_app/data/models/cart_model.dart';
import 'package:gona_market_app/data/models/cart_item_model.dart';

class CartRepository {
  final LocalStorageService localStorageService;

  CartRepository(this.localStorageService);

  Future<CartModel> getCart() async {
    final cartJsonString = await localStorageService.get('cart');

    if (cartJsonString == null) {
      return CartModel(id: '0', items: []);
    }

    final Map<String, dynamic> cartJson = jsonDecode(cartJsonString);
    return CartModel.fromJson(cartJson);
  }

  Future<void> addItemToCart(CartItemModel item) async {
    final cart = await getCart();
    cart.items.add(item);
    await localStorageService.set('cart', cart.toJsonString());
  }

  Future<void> removeItemFromCart(String itemId) async {
    final cart = await getCart();
    cart.items.removeWhere((item) => item.id == itemId);
    await localStorageService.set('cart', cart.toJsonString());
  }
}
