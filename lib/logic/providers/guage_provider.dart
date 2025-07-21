import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/repositories/guage_repository.dart';

class GuageProvider extends ChangeNotifier {
  final GuageRepository guageRepository;
  List<Map<String, dynamic>> _guages = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get guages => _guages;
  bool get isLoading => _isLoading;

  GuageProvider(this.guageRepository);

  Future<void> fetchGuages() async {
    _isLoading = true;
    notifyListeners();

    try {
      _guages = await guageRepository.getGuages();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching Guages: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }
}
