import 'package:flutter/foundation.dart';
import 'package:gona_market_app/data/repositories/lga_repository.dart';

class LGAProvider extends ChangeNotifier {
  final LGARepository lgaRepository;
  List<Map<String, dynamic>> _LGAs = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get lgas => _LGAs;
  bool get isLoading => _isLoading;

  LGAProvider(this.lgaRepository);

  Future<void> fetchLGAByIdAndField(String id, {String? field}) async {
    
    _isLoading = true;
    notifyListeners();

    try {
      final lgaData = await lgaRepository.getLocalGovernmentsByStateId(id);
      _LGAs = lgaData;

    } catch (e) {
      if (kDebugMode) {
        print('Error fetching local government: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
