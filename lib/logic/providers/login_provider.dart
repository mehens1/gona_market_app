import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/user_model.dart';
import 'package:gona_market_app/data/services/auth_service.dart';
import 'package:gona_market_app/data/services/token_service.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';
import 'package:dio/dio.dart';

class LoginProvider with ChangeNotifier {
  final AuthService authService; 
  final UserProvider userProvider;
  final TokenService tokenService;

  bool _isLoggingIn = false;
  bool get isLoggingIn => _isLoggingIn;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LoginProvider(this.authService, this.userProvider, this.tokenService);

  Future<void> login(Map<String, dynamic> loginData) async {
    _isLoggingIn = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Response loginResponse = await authService.loginUser(loginData);

      if ((loginResponse.statusCode == 200 || loginResponse.statusCode == 201) && loginResponse.data['status'] == true) {
        final userData = loginResponse.data['data'];
        final accessToken = userData['access_token'];
        final userModel = UserModel.fromJson(userData['user']);

        userProvider.updateUser(userModel);
        await tokenService.saveToken(accessToken);
      } else {
        _errorMessage = loginResponse.data['message'];
        throw Exception(_errorMessage);
      }
    } catch (error) {
      print('Login failed: $error');
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _isLoggingIn = false;
      notifyListeners();
    }
  }

  void logout() {
    userProvider.clearUser();
    tokenService.removeToken();
  }
}
