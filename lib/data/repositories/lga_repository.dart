import 'package:gona_market_app/data/services/api_service.dart';
class LGARepository {
  final ApiService apiService;

  LGARepository(this.apiService);

  Future<List<Map<String, dynamic>>> getLocalGovernments() async {
    final response = await apiService.get('/lga');
    return (response.data as List)
        .map((stateJson) => {
              'id': stateJson['id'].toString(),
              'lga': stateJson['lga'].toString(),
            })
        .toList();
  }

  Future<List<Map<String, String>>> getLocalGovernmentsByStateId(String id) async {
    final response = await apiService.getById('/lga', id: id);

    if (response.data is! List) {
      throw Exception('Expected a list of LGAs but received something else');
    }

    List<dynamic> lgaList = response.data;

    return lgaList.map((lga) {
      return {
        'id': lga['id'].toString(),
        'lga': lga['lga'].toString(),
      };
    }).toList();
  }
}
