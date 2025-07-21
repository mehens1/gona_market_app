import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gona_market_app/core/utils/ApiException.dart';
import 'package:gona_market_app/data/services/token_service.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl;
  bool _initialized = false;

  ApiService(this._dio, {required this.baseUrl}) {
    _dio.options.headers['Accept'] = 'application/json';
  }

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      var tokenService = TokenService();
      var userToken = await tokenService.getToken();

      if (userToken != null && userToken.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $userToken';
      }
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error during token retrieval: $e');
      }
    }
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    await initialize();
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

  Future<Response> getById(String endpoint, {required String id}) async {
    await initialize();
    try {
      return await _dio.get('$baseUrl$endpoint/$id');
    } catch (e) {
      if (kDebugMode) {
        print('Error during GET for $endpoint by ID request: $e');
      }
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    await initialize();
    try {
      return await _dio.post(
        '$baseUrl$endpoint',
        data: data,
      );
    } on DioException catch (e) {
      final error = e.response?.data["message"]?.toString();
      if (kDebugMode) {
        print('DioException occurred: ${e.message}');
        print('Response data api_service: ${e.response?.data}');
      }
      throw Exception(error);
    } catch (e) {
      if (kDebugMode) {
        print('An unexpected error occurred: $e');
      }
      throw Exception("An unexpected error occurred. Please try again");
    }
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    await initialize();
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
