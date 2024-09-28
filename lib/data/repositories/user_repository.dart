import 'package:gona_market_app/data/models/user_model.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<UserModel> getUser() async {
    try {
      final response = await apiService.get('/me');
      if (response.data != null && response.data is Map<String, dynamic>) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (error) {
      print('Failed to fetch user: $error');
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await apiService.put('/users/${user.id}', data: user.toJson());
    } catch (error) {
      print('Failed to update user: $error');
      rethrow;
    }
  }

  Future<UserModel> registerUser(UserModel user) async {
    try {
      final response = await apiService.post('/users', data: user.toJson());
      // Check if response data is not null and is in the expected format
      if (response.data != null && response.data is Map<String, dynamic>) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (error) {
      // Handle or log the error
      print('Failed to register user: $error');
      rethrow;
    }
  }
}
