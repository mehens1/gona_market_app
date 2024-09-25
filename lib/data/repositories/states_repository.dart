import 'package:gona_market_app/data/services/api_service.dart';

class StatesRepository {
  final ApiService apiService;

  StatesRepository(this.apiService);

  Future<List<Map<String, dynamic>>> getStates() async {
    final response = await apiService.get('/states');
    return (response.data as List)
        .map((stateJson) => {
              'id': stateJson['id']
                  .toString(),
              'state': stateJson['state'].toString(),
            })
        .toList();
  }
}
