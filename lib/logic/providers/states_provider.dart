import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/repositories/states_repository.dart';

class StatesProvider extends ChangeNotifier {
  final StatesRepository statesRepository;
  List<Map<String, dynamic>> _states = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get states => _states;
  bool get isLoading => _isLoading;

  StatesProvider(this.statesRepository);

  Future<void> fetchStates() async {
    _isLoading = true;
    notifyListeners();

    try {
      _states = await statesRepository.getStates();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching states: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }
}
