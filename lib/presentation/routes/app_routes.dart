// app_routes.dart
import 'package:flutter/material.dart';
import 'package:gona_market_app/presentation/screens/auth/forgot_password.dart';
import 'package:gona_market_app/presentation/screens/auth/login_screen.dart';
import 'package:gona_market_app/presentation/screens/auth/register_screen.dart';
import 'package:gona_market_app/presentation/screens/auth/terms_and_condition.dart';
import 'package:gona_market_app/presentation/screens/splash_screen.dart';
import 'package:gona_market_app/presentation/screens/portal/home_screen.dart';

class AppRoutes {
  // Define route names as constants
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String termsAndCondition = '/terms-and-condition';
  static const String home = '/';

  // Define a method to generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

        // auth pages
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case termsAndCondition:
        return MaterialPageRoute(builder: (_) => const TermsAndCondition());
      
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const UndefinedRouteScreen());
    }
  }
}

// Screen for undefined routes
class UndefinedRouteScreen extends StatelessWidget {
  const UndefinedRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Undefined Route'),
      ),
      body: const Center(
        child: Text('The route is not defined.'),
      ),
    );
  }
}

// Arguments class for ProductScreen
class ProductScreenArguments {
  final String productId;

  ProductScreenArguments({required this.productId});
}
