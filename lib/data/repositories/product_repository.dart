
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<List<ProductModel>> getProducts() async {
    final response = await apiService.get('/products');
    // print('product repo: $response');
    return (response.data as List)
        .map((productJson) => ProductModel.fromJson(productJson))
        .toList();
  }

  Future<ProductModel> getProductById(String productId) async {
    final response = await apiService.get('/products/$productId');
    return ProductModel.fromJson(response.data);
  }

}
