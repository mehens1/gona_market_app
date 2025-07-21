import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<List<ProductModel>> getProducts() async {
    final response = await apiService.get('/products');

    final productsData = response.data['data'];

    debugPrint('Products data: $productsData');

    if (productsData is List && productsData.isNotEmpty) {
      final products = productsData
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList();

      return products;
    } else {
      return [];
    }
  }

  Future<ProductModel> getProductById(String productId) async {
    final response = await apiService.get('/products/$productId');
    return ProductModel.fromJson(response.data);
  }
}
