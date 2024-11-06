import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/cart_item_model.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/repositories/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  List<CartItemModel> _cartItems = [];
  final CartRepository _cartRepository;

  CartProvider(this._cartRepository) {
    _loadLocalCart();
  }

  int get itemCount => _cartItems.length;
  List<CartItemModel> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  void addItem(ProductModel product) {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(CartItemModel(
          id: product.id.toString(), product: product, quantity: 1));
    }

    _saveLocalCart(); // Save to local storage after adding an item
    notifyListeners();
  }

  void removeItem(ProductModel product) {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      if (_cartItems[existingItemIndex].quantity > 1) {
        _cartItems[existingItemIndex].quantity--;
      } else {
        _cartItems.removeAt(existingItemIndex);
      }
      _saveLocalCart(); // Save to local storage after removing an item
    }

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _saveLocalCart(); // Clear local storage when the cart is cleared
    notifyListeners();
  }

  Future<void> addItemForUser(ProductModel product) async {
    try {
      await _cartRepository.addProductToUserCart(product);
      addItem(product);
    } catch (error) {
      // Handle error: Show a snackbar or a toast.
    }
  }

  Future<List<String>> syncCartWithUserProfile() async {
    List<String> productIds = [];
    for (var item in _cartItems) {
      productIds.add(item.id);
      await addItemForUser(item.product);
    }
    clearCart();
    return productIds;
  }

  Future<void> _loadLocalCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString('local_cart');

    if (cartString != null) {
      final List<dynamic> cartJson = jsonDecode(cartString);
      _cartItems = cartJson
          .map((json) => CartItemModel.fromJson(json))
          .toList()
          .cast<CartItemModel>();
      notifyListeners();
    }
  }

  // Save cart items to SharedPreferences
  Future<void> _saveLocalCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartString =
        jsonEncode(_cartItems.map((item) => item.toJson()).toList());
    prefs.setString('local_cart', cartString);
  }
}
