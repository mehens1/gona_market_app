import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/services/api_service.dart';

class RegistrationService {
  final ApiService apiService;

  RegistrationService(this.apiService);

  // Future<Response> registerUser(Map<String, dynamic> userData) async {
  //   try {
  //     final response = await apiService.post('/auth/register', data: userData);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<Response> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiService.post('/auth/register', data: userData);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> verifyEmail(String userId, String verificationCode) async {
    try {
      final response = await apiService.post(
        '/verify-email',
        data: {'userId': userId, 'code': verificationCode},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
