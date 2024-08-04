import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl;
  
  ApiService(this._dio, {required this.baseUrl});
  
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(
        '$baseUrl$endpoint',
        queryParameters: queryParameters,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during GET request: $e');
      }
      rethrow;
    }
  }

  // Method to make POST requests
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(
        '$baseUrl$endpoint',
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during POST request: $e');
      }
      rethrow;
    }
  }

  // Method to make PUT requests
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(
        '$baseUrl$endpoint',
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during PUT request: $e');
      }
      rethrow;
    }
  }
}
