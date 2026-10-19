import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HomeProvider extends ChangeNotifier with BaseController {
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  ValueNotifier<int> get currentPage => _currentPage;

  bool _isVisible = true;
  bool get isVisible => _isVisible;

  void hideNavBar() {
    if (_isVisible) {
      _isVisible = false;
      notifyListeners();
    }
  }

  void showNavBar() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners();
    }
  }

  void onChangeCurrentPage(int index) {
    _currentPage.value = index;
    notifyListeners();
  }
}
