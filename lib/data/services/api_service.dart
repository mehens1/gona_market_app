import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl;

  // ApiService(this._dio, {required this.baseUrl});
  ApiService(this._dio, {required this.baseUrl}) {
    _dio.options.headers['Accept'] = 'application/json';
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
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
    try {
      if (kDebugMode) {
        print('Request Data: $data');
      }
      return await _dio.post(
        '$baseUrl$endpoint',
        data: data,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
    } on DioException catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error during POST request: ${e.response?.data}');
        print('Error Code: ${e.response?.statusCode}');
        print('StackTrace: $stackTrace');
      }

      String errorMessage = 'An error occurred';
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data['errors'] != null) {
          final errors = e.response!.data['errors'];
          errorMessage = errors.values.expand((e) => e).join(', ');
        }
      }

      throw errorMessage.toString();
    } catch (e) {
      if (kDebugMode) {
        print('An unexpected error occurred: $e');
      }
      throw Exception(
          'An unexpected error occurred. Please try again.');
    }
  }

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
