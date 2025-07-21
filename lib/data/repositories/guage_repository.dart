import 'package:gona_market_app/data/services/api_service.dart';

class GuageRepository {
  final ApiService apiService;

  GuageRepository(this.apiService);

  Future<List<Map<String, dynamic>>> getGuages() async {
    final response = await apiService.get('/guages');
    return (response.data['data'] as List)
        .map((stateJson) => {
              'id': stateJson['id'].toString(),
              'guage': stateJson['name'].toString(),
            })
        .toList();
  }
}
