import 'package:flutter/material.dart';
import 'package:gona_market_app/screens/splash_screen.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      // login: (context) => LoginScreen(),
      // register: (context) => RegisterScreen(),
    };
  }
}
