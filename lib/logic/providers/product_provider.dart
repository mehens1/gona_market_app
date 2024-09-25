import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository productRepository;
  List<ProductModel> _products = [];
  bool _loading = false;
  String? _errorMessage;

  ProductProvider(this.productRepository);

  List<ProductModel> get products => _products;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _loading = true;  
    _errorMessage = null; // Reset error message before fetching
    notifyListeners();

    try {
      _products = await productRepository.getProducts();
    } catch (e) {
      _errorMessage = 'Failed to load products. Please try again later.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
