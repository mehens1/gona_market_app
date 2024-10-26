import 'package:gona_market_app/data/models/cart_item_model.dart';
import 'package:gona_market_app/data/models/cart_model.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class CartRepository {
  final ApiService apiService;

  CartModel cart = CartModel(id: DateTime.now().millisecondsSinceEpoch.toString(), items: []);

  CartRepository(this.apiService);

  List<CartItemModel> getItems() {
    print('from cart repo: $cart');
    return cart.items;
  }

  void addItem(CartItemModel cartItem) {
    final existingItemIndex =
        cart.items.indexWhere((item) => item.product.id == cartItem.product.id);

    if (existingItemIndex >= 0) {
      cart.items[existingItemIndex].quantity += cartItem.quantity;
    } else {
      cart.items.add(cartItem);
    }
  }

  void removeItem(String itemId) {
    cart.items.removeWhere((item) => item.id == itemId);
  }

  void clearCart() {
    cart.items.clear();
  }

  double getTotalAmount() {
    return cart.items
        .fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  Future<void> addProductToUserCart(ProductModel product) async {
    CartItemModel cartItem = CartItemModel(
      id: product.id.toString(),
      product: product,
      quantity: 1,
    );

    addItem(cartItem);

    final response = await apiService.post('/cart', data: {
      'productId': product.id,
      'quantity': cartItem.quantity,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to add product to cart');
    }
  }
}
