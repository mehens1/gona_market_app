import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/user_model.dart';
import 'package:gona_market_app/data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository userRepository;
  UserModel? _user;

  UserProvider(this.userRepository);

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  // Fetch user data with userId parameter
  Future<void> fetchUser() async {
    try {
      _user = await userRepository.getUser();
      notifyListeners();
    } catch (error) {
      print('Failed to fetch user: $error');
      _user = null;
    }
  }

  Future<UserModel?> getUser() async {
    if (_user == null) {
      await fetchUser();
    }
    return _user;
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
