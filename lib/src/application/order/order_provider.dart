// import 'package:dartx/dartx.dart';

import 'package:flutter/cupertino.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/domain/user/i_user_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:customer_core/src/domain/user/i_user_shared_prefs.dart';

import '../../domain/user/models/order_history_raw_data_model.dart';
import '../core/api_response.dart';
import 'package:dartx/dartx.dart';

@LazySingleton()
class OrderProvider extends ChangeNotifier with BaseController {
  final IUserRepo userRepo;
  final IUserSharedPrefsRepo sharedPrefsRepository;

  OrderProvider({required this.userRepo, required this.sharedPrefsRepository});

  APIResponse<List<OrderDetailsModel>> _ordersResponse =
      APIResponse<List<OrderDetailsModel>>.initial();

  APIResponse<List<OrderDetailsModel>> get ordersResponse => _ordersResponse;

  bool get isEmpty => _ordersResponse.data?.isEmpty ?? true;

  String? _viewOrderId;

  String? get viewOrderId => _viewOrderId;

  TextEditingController searchController = TextEditingController();

  OrderDetailsModel? get viewOrderDetails {
    return _ordersResponse.data?.firstOrNullWhere((order) {
      return order.orderID == viewOrderId;
    });
  }

  List<OrderDetailsModel> get getActiveOrders {
    List<OrderDetailsModel> activeOrders = [];
    final orders = this.orders;
    if (orders.isEmpty) {
      return activeOrders;
    }

    activeOrders =
        orders.where((e) => e.orderPending || e.orderAccepted).toList();

    return activeOrders;
  }

  List<OrderDetailsModel> _filteredOrders = [];

  List<OrderDetailsModel> get orders {
    if (searchController.text.isEmpty) {
      return _ordersResponse.data ?? [];
    }
    return _filteredOrders;
  }

  Future<bool> checkUserIsLogged() async =>
      await sharedPrefsRepository.getUserData() != null;

  @override
  Future<void> init() {
    fetchAllOrders();
    return super.init();
  }

  Future<void> fetchAllOrders({String? year}) async {
    final isLogged = await checkUserIsLogged();
    if (!isLogged) {
      clearData();
      return;
    }

    _ordersResponse = APIResponse.loading();
    notifyListeners();
    final orderYear = year ?? DateTime.now().year.toString();
    final response = await userRepo.getOrderHistory(year: orderYear);
    response.fold((exception) {
      _ordersResponse = throwAppException(exception);
      notifyListeners();
    }, (result) {
      _ordersResponse = APIResponse.completed(result.history);
      _filteredOrders = [];
      searchController.clear();
      notifyListeners();
    });
  }

  void updateViewOrderId(String orderID) async {
    _viewOrderId = orderID;
    notifyListeners();
  }

  void clearData() {
    _ordersResponse = APIResponse.initial();
    _filteredOrders = [];
    searchController.clear();
    notifyListeners();
  }

  void searchOrders(String query) {
    final orders = _ordersResponse.data;

    if (orders == null || orders.isEmpty) {
      _filteredOrders = [];
      notifyListeners();
      return;
    }

    if (query.trim().isEmpty) {
      _filteredOrders = [];
      notifyListeners();
      return;
    }

    final normalizedQuery = _normalize(query);

    _filteredOrders = orders.where((order) {
      final orderId = order.customerOrderID ?? '';

      final normalizedOrderId = _normalize(orderId);

      return normalizedOrderId.contains(normalizedQuery);
    }).toList();

    notifyListeners();
  }

  /// Removes hyphens, spaces, makes lowercase,
  /// and removes leading zeros from numeric parts
  String _normalize(String value) {
    final lower = value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    // Split letters and numbers
    final match = RegExp(r'^([a-z]+)(\d+)$').firstMatch(lower);

    if (match != null) {
      final letters = match.group(1)!;
      final numbers = int.parse(match.group(2)!).toString();
      return '$letters$numbers';
    }

    return lower;
  }
}
