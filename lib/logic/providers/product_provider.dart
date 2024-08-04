import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository productRepository;
  List<ProductModel> _products = [];

  ProductProvider(this.productRepository);

  List<ProductModel> get products => _products;

  Future<void> fetchProducts() async {
    try {
      _products = await productRepository.getProducts();
      print('Products fetched: $_products');
    } catch (e) {
      print('Error fetching products: $e');
    }
    notifyListeners();
  }
}
