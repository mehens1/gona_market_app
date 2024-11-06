

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save token to secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'user_token', value: token);
  }

  // Retrieve token from secure storage
  Future<String?> getToken() async {
    return await _storage.read(key: 'user_token');
  }

  // Remove token from secure storage
  Future<void> removeToken() async {
    await _storage.delete(key: 'user_token');
  }
}
