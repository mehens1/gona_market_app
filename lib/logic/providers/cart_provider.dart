import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/cart_model.dart';
import 'package:gona_market_app/data/models/cart_item_model.dart';
import 'package:gona_market_app/data/repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository cartRepository;
  CartModel _cart = CartModel(id: '0', items: []);

  CartProvider(this.cartRepository) {
    _loadCart();
  }

  CartModel get cart => _cart;

  Future<void> _loadCart() async {
    _cart = await cartRepository.getCart();
    notifyListeners();
  }

  Future<void> addItemToCart(CartItemModel item) async {
    await cartRepository.addItemToCart(item);
    await _loadCart();
  }

  Future<void> removeItemFromCart(String itemId) async {
    await cartRepository.removeItemFromCart(itemId);
    await _loadCart();
  }
}
