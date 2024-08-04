import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/user_model.dart';
import 'package:gona_market_app/data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository userRepository;
  UserModel? _user;

  UserProvider(this.userRepository);

  UserModel? get user => _user;

  // Fetch user data with userId parameter
  Future<void> fetchUser(String userId) async {
    try {
      _user = await userRepository.getUser(userId);
      notifyListeners();
    } catch (error) {
      // Handle errors or show a message to the user
      print('Failed to fetch user: $error');
      _user = null; // Optional: Reset user if there's an error
      // Optionally, you might want to show an error message to the user
    }
  }

  // Method to update the user in the provider
  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Method to clear user data in the provider
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
