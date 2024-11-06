import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/repositories/categories_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository categoryRepository;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  CategoryProvider(this.categoryRepository);

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await categoryRepository.getCategories();
      if (kDebugMode) {
        print('Fetched Categories: $_categories');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching Categories: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }
}
