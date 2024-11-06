// app_routes.dart
import 'package:flutter/material.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/presentation/screens/auth/account_under_review.dart';
import 'package:gona_market_app/presentation/screens/auth/forgot_password.dart';
import 'package:gona_market_app/presentation/screens/auth/login_screen.dart';
import 'package:gona_market_app/presentation/screens/auth/register_screen.dart';
import 'package:gona_market_app/presentation/screens/auth/terms_and_condition.dart';
import 'package:gona_market_app/presentation/screens/portal/cart_screen.dart';
import 'package:gona_market_app/presentation/screens/portal/checkout_screen.dart';
import 'package:gona_market_app/presentation/screens/portal/my_store_screen.dart';
import 'package:gona_market_app/presentation/screens/portal/product_details_screen.dart';
import 'package:gona_market_app/presentation/screens/portal/profile_screen.dart';
import 'package:gona_market_app/presentation/screens/portal/upload_product_screen.dart';
import 'package:gona_market_app/presentation/screens/splash_screen.dart';
import 'package:gona_market_app/presentation/screens/portal/home_screen.dart';

class AppRoutes {
  // Define route names as constants
  static const String splash = '/splash';
  static const String login = '/login';
  static const String accountUnderVerification = '/account-under-verification';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String termsAndCondition = '/terms-and-condition';
  static const String home = '/';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String productDetails = '/product-detail';
  static const String userProfile = '/user-profile';
  static const String myStore = '/my-store';
  static const String uploadProduct = '/upload-product';

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
      case accountUnderVerification:
        return MaterialPageRoute(builder: (_) => const AccountUnderReview());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case termsAndCondition:
        return MaterialPageRoute(builder: (_) => const TermsAndCondition());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case productDetails:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );
      case userProfile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case cart:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => CheckoutScreen());
      case myStore:
        return MaterialPageRoute(builder: (_) => MyStoreScreen());
      case uploadProduct:
        return MaterialPageRoute(builder: (_) => ProductUploadScreen());
      default:
        return MaterialPageRoute(builder: (_) => const UndefinedRouteScreen());
    }
  }
}

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

class ProductScreenArguments {
  final String productId;

  ProductScreenArguments({required this.productId});
}
