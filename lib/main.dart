import 'package:flutter/material.dart';
import 'package:gona_market_app/routes.dart';
import 'package:gona_market_app/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gona Market',
      theme: appTheme,
      initialRoute: Routes.splash,
      routes: Routes.routes,
    );
  }
}
