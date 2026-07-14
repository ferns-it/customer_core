import 'package:customer_core/src/core/constants/enums.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/domain/store/models/store_delivery_slot_model.dart';
import 'package:flutter/material.dart';
import 'package:customer_core/src/application/core/api_response.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/domain/store/i_store_repo.dart';
import 'package:customer_core/src/domain/store/models/store_settings_data_model.dart';
import 'package:customer_core/src/domain/store/models/store_timing_data_model.dart';

import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@LazySingleton()
class ShopProvider extends ChangeNotifier with BaseController {
  final IStoreRepo _storeRepo;

  ShopProvider(this._storeRepo);

  APIResponse<StoreTimingDataModel> _shopTiming = APIResponse.initial();

  APIResponse<StoreTimingDataModel> get shopTiming => _shopTiming;

  APIResponse<StoreSettingsDataModel> _storeSettings = APIResponse.initial();

  APIResponse<StoreSettingsDataModel> get storeSettings => _storeSettings;

  APIResponse<StoreDeliverySlotModel> _deliverySlots = APIResponse.initial();

  APIResponse<StoreDeliverySlotModel> get deliverySlots => _deliverySlots;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  String get formattedSelectedDate => selectedDate != null
      ? DateFormat('yyyy MMM dd').format(selectedDate!)
      : "";

  String get formattedSelectedDateForPayload => selectedDate != null
      ? DateFormat('yyyy-MM-dd').format(selectedDate!)
      : "";

  StoreDeliverySlotDataModelResponse? _selectedDeliverySlot;
  StoreDeliverySlotDataModelResponse? get selectedDeliverySlot =>
      _selectedDeliverySlot;

  bool isLoading = false;
  String? errorMessage;

  List<SmsAvailableCountrieData> smsCountries = [];

  SmsAvailableCountrieData? selectedCountry;

  List<StoreDeliverySlotDataModelResponse>? get slotForSelectedDate {
    final slots = _deliverySlots.data?.deliverySlots;
    if (slots == null) return null;
    switch (_selectedDate?.weekday) {
      case 1:
        return slots.monday;
      case 2:
        return slots.tuesday;
      case 3:
        return slots.wednesday;
      case 4:
        return slots.thursday;
      case 5:
        return slots.friday;
      case 6:
        return slots.saturday;
      case 7:
        return slots.sunday;
      default:
        return null;
    }
  }

  bool get isSlotsEmpty =>
      slotForSelectedDate?.isEmpty == true || slotForSelectedDate == null
          ? true
          : false;

  double get onlinePaymentMinAmount {
    final amtString = storeSettings.data?.deliveryInfo?.onlinePaymentMinAmount;
    final formattedAmt = double.tryParse(amtString ?? '0') ?? 0.00;

    return formattedAmt;
  }

  VerificationType get verificationType {
    final settings = storeSettings.data;
    if (settings == null) return VerificationType.email;

    final sms = settings.smsVerification?.toLowerCase() == 'enabled';
    final email = settings.emailVerification?.toLowerCase() == 'enabled';

    if (sms && email) return VerificationType.both;
    if (sms) return VerificationType.sms;
    return VerificationType.email;
  }

  String get otpMessage {
    switch (verificationType) {
      case VerificationType.sms:
        return "Enter the OTP sent to your registered mobile number";

      case VerificationType.email:
        return "Enter the OTP sent to your registered email address";

      case VerificationType.both:
        return "Enter the OTP sent to your registered mobile number and email address";

      case VerificationType.none:
        return "Enter the OTP";
    }
  }

  @override
  Future<void> init() {
    fetchShopTimingDetails();
    fetchStoreSettings();
    return super.init();
  }

  Future<void> fetchShopTimingDetails() async {
    _shopTiming = APIResponse.loading();
    notifyListeners();

    final result = await _storeRepo.getShopTimingDetails();

    result.fold(
      (error) {
        _shopTiming = APIResponse.error(error.message);
        notifyListeners();
      },
      (data) {
        _shopTiming = APIResponse.completed(data);
        notifyListeners();
      },
    );
  }

  Future<void> fetchStoreSettings() async {
    _storeSettings = APIResponse.loading();
    notifyListeners();

    final result = await _storeRepo.getStoreSettings();

    result.fold(
      (error) {
        _storeSettings = APIResponse.error(error.message);
        notifyListeners();
      },
      (data) {
        _storeSettings = APIResponse.completed(data);

        // Load allowed SMS countries from API
        smsCountries = data.smsAvailableCountries ?? [];

        // Select the first country by default
        if (smsCountries.isNotEmpty) {
          selectedCountry = smsCountries.first;
        }

        notifyListeners();
      },
    );
  }

  void updateSelectedCountry(SmsAvailableCountrieData country) {
    selectedCountry = country;
    notifyListeners();
  }

  Future<void> fetchShopDeliverySlots() async {
    _deliverySlots = APIResponse.loading();
    notifyListeners();

    final result = await _storeRepo.getStoreDeliverySlots();

    result.fold(
      (error) {
        _deliverySlots = APIResponse.error(error.message);
        notifyListeners();
      },
      (data) {
        _deliverySlots = APIResponse.completed(data);
        notifyListeners();
      },
    );
  }

  //clear the slots
  void clearSelectedDeliverySlot() {
    _selectedDate = null;
    _selectedDeliverySlot = null;
    notifyListeners();
  }

  void onChangeSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void onChangeOnSelectedDeliverySlot(
      StoreDeliverySlotDataModelResponse? slot) {
    _selectedDeliverySlot = slot;
    notifyListeners();
  }

  bool validateInputData() {
    if (selectedDate == null) {
      AlertDialogs.showInfo("Please Select A Delivery Date & Time");
      return false;
    }
    if (selectedDeliverySlot == null) {
      AlertDialogs.showInfo("Please Select A Delivery Date & Time");
      return false;
    }
    return true;
  }
}
