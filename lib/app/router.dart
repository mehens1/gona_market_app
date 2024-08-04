import 'package:flutter/material.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return AppRoutes.generateRoute(settings);
  }
}