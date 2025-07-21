import 'package:dio/dio.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class ProductUploadService {
  final ApiService apiService;

  ProductUploadService(this.apiService);

  Future<Response> getMyProduct(Map<String, dynamic> userData) async {
    try {
      final response = await apiService.get('/my-products');
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // Future<Response> uploadProduct(Map<String, dynamic> productData) async {
  //   try {
  //     // print('data from upload: $productData');

  //     final response = await apiService.post('/upload-product', data: productData );
  //     print('response from upload: $response');
  //     return response;
  //   } catch (e) {
  //     print('error from upload: ');
  //     print(e);
  //     throw e.toString();
  //   }
  // }
  Future<Response> uploadProduct(FormData productData) async {
  try {
    final response = await apiService.post('/upload-product', data: productData);
    print('response from upload: $response');
    return response;
  } catch (e) {
    print('error from upload: ');
    print(e);
    throw e.toString();
  }
}

  Future<Response> updateProduct(product) async {
    try {
      final response = await apiService
          .put('/my-product/update', data: {'product': product});
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
