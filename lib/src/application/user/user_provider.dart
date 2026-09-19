import 'dart:io';

import 'package:customer_core/src/domain/user/models/basic_profile_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/core/utils/alert_dialogs.dart';
import 'package:customer_core/src/domain/user/i_user_repo.dart';
import 'package:customer_core/src/domain/user/models/add_new_adress_request_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:customer_core/src/domain/user/models/user_consent_list_data_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/user/i_user_shared_prefs.dart';
import '../../domain/user/models/user_address_list_data_model.dart';
import '../../domain/user/models/user_login_response.dart';
import '../../infrastructure/core/failures/app_exceptions.dart';

@LazySingleton()
class UserProvider extends ChangeNotifier with BaseController {
  final IUserRepo userRepo;
  final IUserSharedPrefsRepo sharedPrefsRepository;

  UserProvider({
    required this.userRepo,
    required this.sharedPrefsRepository,
  });

  UserLoginResponse? _userData;

  UserLoginResponse? get userData => _userData;

  String get userFullName {
    final firstName = userData?.user.userFirstName;
    final lastName = userData?.user.userLastName;
    return "${(firstName != null && firstName.isNotEmpty) ? firstName : ""} ${(lastName != null && lastName.isNotEmpty) ? lastName : "User"}";
  }

  GlobalKey<FormState> newAddressFormKey = GlobalKey<FormState>();

  UserAddressListDataModel? _userAddressList;

  List<UserAddressDataModel> get userAddressList =>
      _userAddressList?.data?.list ?? [];

  String? _updateRequiredAddressId;

  String? get updateRequiredAddressId => _updateRequiredAddressId;

  bool _isAddingOrUpdatingUserAddress = false;

  bool get isAddingOrUpdatingUserAddress => _isAddingOrUpdatingUserAddress;
  bool _isUpdateBasicProfile = false;

  bool get isUpdateBasicProfile => _isUpdateBasicProfile;

  bool _isUserAddressListLoading = false;

  bool get isUserAddressListLoading => _isUserAddressListLoading;

  bool _isDeletingUserAddress = false;

  bool get isDeletingUserAddress => _isDeletingUserAddress;

  bool _isUserConsentLoading = false;

  bool get isUserConsentLoading => _isUserConsentLoading;

  UserAddressDataModel? _selectedAddress;

  UserAddressDataModel? get selectedAddress => _selectedAddress;

  UserAddressListDataModel? _searchAddressListItem;

  List<UserAddressDataModel> get searchAddressListItem =>
      _searchAddressListItem?.data?.list ?? [];

  UserConsentRawDataModel? _userConsent;

  UserConsentRawDataModel? get userConsent => _userConsent;

  UserConsentSubDataModel? get transactionalUserConsent =>
      _userConsent?.consentList?.transactional;

  UserConsentSubDataModel? get promotionalUserConsent =>
      _userConsent?.consentList?.promotional;

  UserConsentSubDataModel? get newsLetterUserConsent =>
      _userConsent?.consentList?.newsletter;

  bool _isTransactionalConsentChanged = false;

  bool get isTransactionalConsentChanged => _isTransactionalConsentChanged;

  bool _isPromotionalConsentChanged = false;

  bool get isPromotionalConsentChanged => _isPromotionalConsentChanged;

  bool _isNewsletterConsentChanged = false;

  bool get isNewsletterConsentChanged => _isNewsletterConsentChanged;

  late TextEditingController addressTitleTxtController;
  late TextEditingController firstNameTxtController;
  late TextEditingController lastNameTxtController;
  late TextEditingController line1TxtController;
  late TextEditingController line2TxtController;
  late TextEditingController townTxtController;
  late TextEditingController postCodeTxtController;
  late TextEditingController countyTxtController;
  late TextEditingController landMarkTxtController;
  late TextEditingController searchAddressTxtController;

  static const _channel = MethodChannel('app_version_channel');

  bool get isUserExist => _userData != null;

  @override
  Future<void> init() {
    getUserData();
    getAddressList();
    checkNewAppUpdates();
    return super.init();
  }

  Future<void> getUserData() async {
    _userData = await sharedPrefsRepository.getUserData();
    notifyListeners();
  }

  void clearAllData() {
    _userAddressList = null;
    _userData = null;
    notifyListeners();
  }

  void initAllTextEditingController() {
    addressTitleTxtController = TextEditingController();
    firstNameTxtController = TextEditingController();
    lastNameTxtController = TextEditingController();
    line1TxtController = TextEditingController();
    line2TxtController = TextEditingController();
    townTxtController = TextEditingController();
    postCodeTxtController = TextEditingController();
    countyTxtController = TextEditingController();
    landMarkTxtController = TextEditingController();
    searchAddressTxtController = TextEditingController();
  }

  void loadDataForAddressUpdate(UserAddressDataModel? address) {
    if (address != null) {
      addressTitleTxtController.text = address.addressTitle ?? '';
      firstNameTxtController.text = address.firstName ?? '';
      lastNameTxtController.text = address.lastName ?? '';
      line1TxtController.text = address.line1 ?? '';
      line2TxtController.text = address.line2 ?? '';
      townTxtController.text = address.town ?? '';
      postCodeTxtController.text = address.postcode ?? '';
      countyTxtController.text = address.county ?? '';
      landMarkTxtController.text = address.landmark ?? '';
      searchAddressTxtController.text = address.postcode ?? '';
    }
  }

  void clearAddressForm({bool delay = true}) async {
    // Clear search controller immediately so the bottom sheet address list
    // doesn't get stuck showing filtered results after editing an address.
    searchAddressTxtController.clear();
    if (delay) {
      await Future.delayed(const Duration(milliseconds: 600));
    }
    addressTitleTxtController.clear();
    firstNameTxtController.clear();
    lastNameTxtController.clear();
    line1TxtController.clear();
    line2TxtController.clear();
    townTxtController.clear();
    postCodeTxtController.clear();
    countyTxtController.clear();
    landMarkTxtController.clear();
  }

  Future<void> getAddressList() async {
    try {
      final isLogged = await sharedPrefsRepository.getUserData() != null;
      if (!isLogged) return;
      _isUserAddressListLoading = true;
      notifyListeners();
      final response = await userRepo.getUserAddressList();
      response.fold((error) {
        _isUserAddressListLoading = false;

        AlertDialogs.showError(error.message);
      }, (result) {
        _isUserAddressListLoading = false;

        _userAddressList = result;
        final isDefaultAddressSet =
            userAddressList.any((address) => address.dDefault == "1");
        if (userAddressList.isEmpty || !isDefaultAddressSet) {
          setDefaultUserAddressAnnonymus(userAddressList.first.uaID ?? '');
        }
      });
    } finally {
      _isUserAddressListLoading = false;
      notifyListeners();
    }
  }

  //search
  Future<void> searchAddressByPostCode(String query) async {
    if (query.isEmpty) {
      _searchAddressListItem = null;
      notifyListeners();
      return;
    }

    final normalizedQuery = _normalizePostcode(query);

    final list = _userAddressList?.data?.list;

    if (list != null && list.isNotEmpty) {
      final filteredList = list.where((address) {
        final postcode = address.postcode;
        if (postcode == null) return false;

        final normalizedPostcode = _normalizePostcode(postcode);

        return normalizedPostcode.contains(normalizedQuery);
      }).toList();

      _searchAddressListItem = UserAddressListDataModel(
        data: UserAddressListSubDataModel(
          list: filteredList,
        ),
      );
    } else {
      _searchAddressListItem = null;
    }

    notifyListeners();
  }

  String _normalizePostcode(String value) {
    return value.toLowerCase().replaceAll(' ', '').trim();
  }

  Future<bool> addOrUpdateUserAddress(String? updateRequiredAddressId) async {
    try {
      _isAddingOrUpdatingUserAddress = true;
      notifyListeners();
      final data = AddNewUserAddressRequestModel(
        addressTitle: "",
        firstName: firstNameTxtController.text,
        lastName: lastNameTxtController.text,
        line1: line1TxtController.text,
        line2: line2TxtController.text,
        town: townTxtController.text,
        county: countyTxtController.text,
        postcode: postCodeTxtController.text,
        landmark: landMarkTxtController.text,
      );

      Either<AppExceptions, String> response;

      if (updateRequiredAddressId != null) {
        response = await userRepo.updateAddress(
            data: data, addressID: updateRequiredAddressId);
      } else {
        response = await userRepo.addNewAddress(data: data);
      }

      return response.fold((error) {
        AlertDialogs.showError(error.message);
        return false;
      }, (message) {
        AlertDialogs.showSuccess(message);

        return true;
      });
    } finally {
      _isAddingOrUpdatingUserAddress = false;
      notifyListeners();
      await getAddressList();
    }
  }

  Future<bool> updateBasicProfile({
    required String firstName,
    required String lastName,
    required String mobile,
  }) async {
    try {
      _isUpdateBasicProfile = true;
      notifyListeners();

      final data = BasicProfileDataModel(
        userFirstName: firstName,
        userLastName: lastName,
        userMobile: mobile,
      );

      final Either<AppExceptions, String> response =
          await userRepo.updateBasicProfile(data: data);
      print("updateprofileResponse: $response");
      return response.fold(
        (error) {
          AlertDialogs.showError(error.message);
          return false;
        },
        (message) {
          AlertDialogs.showSuccess(message);
          return true;
        },
      );
    } finally {
      _isUpdateBasicProfile = false;
      notifyListeners();
    }
  }

  Future<bool> setDefaultUserAddress(String addressID) async {
    try {
      _isAddingOrUpdatingUserAddress = true;
      notifyListeners();
      final response =
          await userRepo.setDefaultUserAddress(addressID: addressID);
      return response.fold((error) {
        // AlertDialogs.showError(error.message);
        return false;
      }, (message) {
        AlertDialogs.showSuccess(message);
        return true;
      });
    } finally {
      _isAddingOrUpdatingUserAddress = false;
      notifyListeners();
      await getAddressList();
    }
  }

  Future<bool> setDefaultUserAddressAnnonymus(String addressID) async {
    try {
      final response =
          await userRepo.setDefaultUserAddress(addressID: addressID);
      return response.fold((error) {
        return false;
      }, (message) {
        return true;
      });
    } finally {}
  }

  Future<bool> deleteUserAddress(String addressID) async {
    try {
      _isAddingOrUpdatingUserAddress = true;
      _isDeletingUserAddress = true;

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));
      final response = await userRepo.deleteUserAddress(addressID: addressID);
      notifyListeners();
      return response.fold(() {
        return true;
      }, (error) {
        AlertDialogs.showError(error.message);
        return false;
      });
      // await Future.delayed(Duration(seconds: 5));
      // return true;
    } finally {
      _isAddingOrUpdatingUserAddress = false;
      _isDeletingUserAddress = false;
      notifyListeners();
    }
  }

  Future<bool> getUserConsent() async {
    try {
      _isUserConsentLoading = true;
      notifyListeners();
      final user = await sharedPrefsRepository.getUserData();
      final userID = user?.user.userID;

      if (user == null || userID == null) {
        return false;
      }

      final response = await userRepo.getUserConsent(
          shopID: AppIdentifiers.kShopId, userID: userID);
      return response.fold(
        (l) {
          AlertDialogs.showError(l.message);
          return false;
        },
        (r) {
          _userConsent = r;
          _isNewsletterConsentChanged =
              r.userData?.consents?.newsletter == 'Yes';
          _isPromotionalConsentChanged =
              r.userData?.consents?.promotional == 'Yes';
          _isTransactionalConsentChanged =
              r.userData?.consents?.transactional == 'Yes';
          notifyListeners();
          return true;
        },
      );
    } finally {
      _isUserConsentLoading = false;
      notifyListeners();
    }
  }

  void onChangeNewsLetterConsentChanged() {
    _isNewsletterConsentChanged = !_isNewsletterConsentChanged;
    notifyListeners();
  }

  void onChangePromotionalConsentChanged() {
    _isPromotionalConsentChanged = !_isPromotionalConsentChanged;
    notifyListeners();
  }

  void onChangeTransactionalConsentChanged() {
    _isTransactionalConsentChanged = !_isTransactionalConsentChanged;
    notifyListeners();
  }

  Future<bool> saveUserConsent() async {
    try {
      final newsletter = _isNewsletterConsentChanged ? 'Yes' : 'No';
      final promotional = _isPromotionalConsentChanged ? 'Yes' : 'No';
      final transactional = _isTransactionalConsentChanged ? 'Yes' : 'No';

      _isUserConsentLoading = true;
      notifyListeners();

      final response = await userRepo.saveUserConsent(
        newsletter: newsletter,
        promotional: promotional,
        transactional: transactional,
      );
      return response.fold(
        (l) {
          AlertDialogs.showError(l.message);
          return false;
        },
        (r) {
          // _userConsent = r;
          // notifyListeners();
          return true;
        },
      );
    } finally {
      _isUserConsentLoading = false;
      notifyListeners();
    }
  }

  Future<void> prepareFakeManager() async {
    await _channel.invokeMethod("prepareFakeManager");
  }

  Future<void> triggerFakeUpdateAvailable() async {
    await _channel.invokeMethod('triggerFakeUpdateAvailable');
  }

  Future<void> completeFakeUpdate() async {
    await _channel.invokeMethod('completeFakeUpdate');
  }

  Future<void> startImmediateUpdate() async {
    await _channel.invokeMethod('startImmediateUpdate');
  }

  Future<void> setFakeMode(bool enable) async {
    await _channel.invokeMethod("setFakeMode", {"enable": enable});
  }

  Future<bool> checkUpdate() async {
    return await _channel.invokeMethod("checkUpdate");
  }

  Future<void> checkNewAppUpdates() async {
    if (kDebugMode || Platform.isIOS) return;

    final isUpdateAvailable = await checkUpdate();
    if (isUpdateAvailable) {
      await startImmediateUpdate();
    }
  }

  // void dispose() {
  //   disposeAllTextEditingControllers();
  //   super.dispose();
  // }
}
