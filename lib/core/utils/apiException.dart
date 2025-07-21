class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorDetails;

  ApiException({required this.message, this.statusCode, this.errorDetails});

  @override
  String toString() {
    return '$message (Status Code: $statusCode)';
  }
}
