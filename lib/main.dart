import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:gona_market_app/app/router.dart';
import 'package:gona_market_app/data/repositories/lga_repository.dart';
import 'package:gona_market_app/data/repositories/product_repository.dart';
import 'package:gona_market_app/data/repositories/states_repository.dart';
import 'package:gona_market_app/data/repositories/user_repository.dart';
import 'package:gona_market_app/data/services/api_service.dart';
import 'package:gona_market_app/app/theme.dart';
import 'package:gona_market_app/data/services/auth_service.dart';
import 'package:gona_market_app/data/services/token_service.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';
import 'package:gona_market_app/logic/providers/lga_provider.dart';
import 'package:gona_market_app/logic/providers/login_provider.dart';
import 'package:gona_market_app/logic/providers/order_provider.dart';
import 'package:gona_market_app/logic/providers/product_provider.dart';
import 'package:gona_market_app/logic/providers/states_provider.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';

void setupLocator() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton(() => Dio());

  final baseUrl = dotenv.env['API_URL'] ?? 'https://api.example.com';
  
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>(), baseUrl: baseUrl));
  getIt.registerLazySingleton(() => UserRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => ProductRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => StatesRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => LGARepository(getIt<ApiService>()));
  
  getIt.registerLazySingleton(() => UserProvider(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => ProductProvider(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => StatesProvider(getIt<StatesRepository>()));
  getIt.registerLazySingleton(() => LGAProvider(getIt<LGARepository>()));

  getIt.registerLazySingleton(() => AuthService(getIt<ApiService>()));
  getIt.registerLazySingleton(() => TokenService());

  getIt.registerLazySingleton(() => LoginProvider(getIt<AuthService>(), getIt<UserProvider>(), getIt<TokenService>()));
  
}

String fileName = kReleaseMode ? ".env.production" : ".env.development";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: fileName);

  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetIt.instance<UserProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<ProductProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<CartProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<OrderProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<StatesProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<LGAProvider>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<LoginProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gona Market',
      theme: appTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
