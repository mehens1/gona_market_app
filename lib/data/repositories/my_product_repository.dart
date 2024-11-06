
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class MyProductRepository {
  final ApiService apiService;

  MyProductRepository(this.apiService);

  Future<List<ProductModel>> getMyProducts() async {
    final response = await apiService.get('/my-products');
    print('my product repo: $response');
    return (response.data as List)
        .map((productJson) => ProductModel.fromJson(productJson))
        .toList();
  }

  Future<ProductModel> getMyProductById(String productId) async {
    final response = await apiService.get('/my-products/$productId');
    return ProductModel.fromJson(response.data);
  }

}
