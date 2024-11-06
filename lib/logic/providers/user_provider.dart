import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/user_model.dart';
import 'package:gona_market_app/data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository userRepository;
  UserModel? _user;

  UserProvider(this.userRepository);

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> fetchUser() async {
    try {
      _user = await userRepository.getUser();
      if(_user != null){
        notifyListeners();
      }
    } catch (error) {
      _user = null;
      notifyListeners();
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

  Future<void> cacheUser(UserModel user) async {
    await userRepository.cacheUser(user);
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
