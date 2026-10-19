import 'dart:developer';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:customer_core/src/application/core/api_response.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/domain/table/models/reserve_dining_table.dart';
import 'package:customer_core/src/domain/user/i_user_shared_prefs.dart';
import 'package:injectable/injectable.dart';

import '../../domain/table/i_table_repo.dart';
import '../../domain/table/models/table_reservation_details.dart';
import '../../infrastructure/core/end_points/end_points.dart';

@LazySingleton()
class TableProvider extends ChangeNotifier with BaseController {
  final ITableRepo _tableRepo;
  final IUserSharedPrefsRepo _userSharedPrefsRepo;

  final List<TableReservationDetails> _tableReservations = [];

  TableProvider(
      {required ITableRepo tableRepo,
      required IUserSharedPrefsRepo userSharedPrefsRepo})
      : _tableRepo = tableRepo,
        _userSharedPrefsRepo = userSharedPrefsRepo;

  List<TableReservationDetails> get tableReservations => _tableReservations;

  APIResponse<List<TableReservationDetails>> _tableReservationsResponse =
      APIResponse<List<TableReservationDetails>>.initial();

  APIResponse<List<TableReservationDetails>> get tableRespo =>
      _tableReservationsResponse;

  // bool get isEmpty => _ordersResponse.data?.isEmpty ?? true;

  bool get isEmpty => _tableReservationsResponse.data?.isEmpty ?? true;

  final reservationFormKey = GlobalKey<FormBuilderState>();

  int _totalChair = 1;

  int get totalChair => _totalChair;

  DateTime _reservationDate = DateTime.now();

  DateTime get reservationDate => _reservationDate;

  bool _isReservingTable = false;

  bool get isReservingTable => _isReservingTable;

  bool _isReservingTableHistory = false;

  bool get isReservingTableHistory => _isReservingTableHistory;

  late TabController tabController;

  void incrementTotalChairs() {
    if (_totalChair == 50) return;
    _totalChair += 1;
    notifyListeners();
  }

  void decrementTotalChairs() {
    if (_totalChair == 1) return;
    _totalChair -= 1;
    notifyListeners();
  }

  void onChangeReservationDate(DateTime date) {
    _reservationDate = date;
    notifyListeners();
  }

  Future<bool> reserveADiningTable({required TimeOfDay reservationTime}) async {
    try {
      _isReservingTable = true;
      notifyListeners();
      final loggedUser = await _userSharedPrefsRepo.getUserData();
      final email = loggedUser?.user.userEmail;
      final userID = loggedUser?.user.userID;

      log(userID ?? 'n/a', name: 'userID');

      reservationFormKey.currentState?.saveAndValidate();

      final values = reservationFormKey.currentState?.value;

      if (email == null || values == null || values.isEmpty || userID == null) {
        return false;
      }

      final reservationDateTime = DateTime(
        _reservationDate.year,
        _reservationDate.month,
        _reservationDate.day,
        reservationTime.hour,
        reservationTime.minute,
      );

      final payload = ReserveDiningTable(
        userID: userID,
        advanceAmount: "0",
        totalChair: totalChair,
        reservationDateTime: reservationDateTime,
        source: "Flutter",
        message: values["message"] ?? "",
        transactionId: "",
        baseUrl: Endpoints.kTableReservationBaseUrl,
        phone: values["phone"],
        advancePayment: "No",
        name: values["name"],
        paymentMethod: "",
        shopId: AppIdentifiers.kShopId,
        email: email,
      );

      final response = await _tableRepo.reserveDiningTable(payload);
      return response.fold(() {
        AlertDialogs.showSuccess("Reservation Booked Successfully");
        return true;
      }, (error) {
        AlertDialogs.showError(error.message);
        return false;
      });
    } finally {
      _isReservingTable = false;
      notifyListeners();
    }
  }

  @override
  Future<void> init() {
    fetchAllTableReservations();
    _isReservingTableHistory = true;
    return super.init();
  }

  Future<void> fetchAllTableReservations() async {
    try {
      _tableReservationsResponse = APIResponse.loading();
      _tableReservations.clear();
      notifyListeners();
      final response = await _tableRepo.reservationHistory();
      response.fold((exception) {
        _tableReservationsResponse = throwAppException(exception);
        notifyListeners();
      }, (reservations) {
        // _tableReservations.clear();
        _tableReservationsResponse = APIResponse.completed(reservations);
        notifyListeners();
      });
    } finally {
      _isReservingTableHistory = false;
      notifyListeners();
    }
  }

  void clearValues() {
    reservationFormKey.currentState?.reset();
    _totalChair = 1;
    _reservationDate = DateTime.now();
    notifyListeners();
  }
}
