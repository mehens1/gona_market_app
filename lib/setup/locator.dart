import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:gona_market_app/core/services/local_storage_service.dart';
import 'package:gona_market_app/data/models/cart_model.dart';
import 'package:gona_market_app/data/repositories/cart_repository.dart';
import 'package:gona_market_app/data/repositories/order_repository.dart';
import 'package:gona_market_app/data/repositories/product_repository.dart';
import 'package:gona_market_app/data/repositories/states_repository.dart';
import 'package:gona_market_app/data/repositories/user_repository.dart';
import 'package:gona_market_app/data/services/api_service.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';
import 'package:gona_market_app/logic/providers/order_provider.dart';
import 'package:gona_market_app/logic/providers/product_provider.dart';
import 'package:gona_market_app/logic/providers/states_provider.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Dio>(() => Dio());
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';

  // Register the ApiService and LocalStorageService
  locator.registerLazySingleton<ApiService>(() => ApiService(locator<Dio>(), baseUrl: baseUrl));
  locator.registerLazySingleton<LocalStorageService>(() => LocalStorageService());

  // Register repositories
  locator.registerLazySingleton<UserRepository>(() => UserRepository(locator<ApiService>()));
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository(locator<ApiService>()));
  
  final cartModel = CartModel(id: 'cart1', items: []);
  locator.registerLazySingleton<CartModel>(() => cartModel);
  locator.registerLazySingleton<CartRepository>(() => CartRepository(locator<ApiService>()));
  
  locator.registerLazySingleton<OrderRepository>(() => OrderRepository(locator<ApiService>()));
  locator.registerLazySingleton<StatesRepository>(() => StatesRepository(locator<ApiService>()));
  
  // Register Providers
  locator.registerLazySingleton<UserProvider>(() => UserProvider(locator<UserRepository>()));
  locator.registerLazySingleton<ProductProvider>(() => ProductProvider(locator<ProductRepository>()));
  locator.registerLazySingleton<CartProvider>(() => CartProvider(locator<CartRepository>()));
  locator.registerLazySingleton<OrderProvider>(() => OrderProvider(locator<OrderRepository>()));
  locator.registerLazySingleton<StatesProvider>(() => StatesProvider(locator<StatesRepository>()));
}

// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get_it/get_it.dart';
// import 'package:gona_market_app/core/services/local_storage_service.dart';
// import 'package:gona_market_app/data/repositories/cart_repository.dart';
// import 'package:gona_market_app/data/repositories/order_repository.dart';
// import 'package:gona_market_app/data/repositories/product_repository.dart';
// import 'package:gona_market_app/data/repositories/states_repository.dart';
// import 'package:gona_market_app/data/repositories/user_repository.dart';
// import 'package:gona_market_app/data/services/api_service.dart';
// import 'package:gona_market_app/logic/providers/cart_provider.dart';
// import 'package:gona_market_app/logic/providers/order_provider.dart';
// import 'package:gona_market_app/logic/providers/product_provider.dart';
// import 'package:gona_market_app/logic/providers/states_provider.dart';
// import 'package:gona_market_app/logic/providers/user_provider.dart';

// final GetIt locator = GetIt.instance;

// void setupLocator() {
//   locator.registerLazySingleton<Dio>(() => Dio());
//   final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';


//   locator.registerLazySingleton<ApiService>(() => ApiService(locator<Dio>(), baseUrl: baseUrl));
//   locator.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
//   locator.registerLazySingleton<UserRepository>(() => UserRepository(locator<ApiService>()));
//   locator.registerLazySingleton<ProductRepository>(() => ProductRepository(locator<ApiService>()));
//   locator.registerLazySingleton<CartRepository>(() => CartRepository(locator<LocalStorageService>()));
//   locator.registerLazySingleton<OrderRepository>(() => OrderRepository(locator<ApiService>()));
//   locator.registerLazySingleton<StatesRepository>(() => StatesRepository(locator<ApiService>()));
  
//   // Register Providers
//   locator.registerLazySingleton<UserProvider>(() => UserProvider(locator<UserRepository>()));
//   locator.registerLazySingleton<ProductProvider>(() => ProductProvider(locator<ProductRepository>()));
//   locator.registerLazySingleton<CartProvider>(() => CartProvider(locator<CartRepository>()));
//   locator.registerLazySingleton<OrderProvider>(() => OrderProvider(locator<OrderRepository>()));
//   locator.registerLazySingleton<StatesProvider>(() => StatesProvider(locator<StatesRepository>()));
// }
