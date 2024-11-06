import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class AuthService {
  final ApiService apiService;

  AuthService(this.apiService);

  Future<Response> loginUser(Map<String, dynamic> loginData) async {
    try {
      final response = await apiService.post('/auth/login', data: loginData);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("error from the AuthService (e): $e");
      }
      throw e.toString();
    }
  }

}
