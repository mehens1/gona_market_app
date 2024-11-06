import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/repositories/my_product_repository.dart';

class MyProductProvider with ChangeNotifier {
  final MyProductRepository myProductRepository;
  List<ProductModel> _myProducts = [];
  bool _loading = false;
  String? _errorMessage;

  MyProductProvider(this.myProductRepository);

  List<ProductModel> get myProducts => _myProducts;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMyProducts() async {
    _loading = true;  
    _errorMessage = null;
    notifyListeners();

    try {
      _myProducts = await myProductRepository.getMyProducts();
    } catch (e) {
      _errorMessage = 'Failed to load your products, Error: $e! Please try again later.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
