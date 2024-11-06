import 'package:gona_market_app/data/services/api_service.dart';

class CategoryRepository {
  final ApiService apiService;

  CategoryRepository(this.apiService);

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await apiService.get('/categories');
    return (response.data['data'] as List)
        .map((stateJson) => {
              'id': stateJson['id']
                  .toString(),
              'category': stateJson['category'].toString(),
            })
        .toList();
  }
}
