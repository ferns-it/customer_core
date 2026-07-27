import 'package:async/async.dart' show AsyncMemoizer;
import 'package:customer_core/customer_core.dart';
import 'package:dartx/dartx.dart';
import 'dart:developer';

// import 'package:dartx/dartx.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';
import 'package:customer_core/src/domain/cart/i_cart_repo.dart';
import 'package:customer_core/src/domain/checkout/models/calculate_take_away_details.dart';
import 'package:customer_core/src/domain/offer/i_offer_repo.dart';
import 'package:customer_core/src/domain/offer/models/offer_details_model.dart';
import 'package:customer_core/src/domain/offer/models/validated_coupon_details.dart';
import 'package:customer_core/src/domain/store/models/product_details_model.dart';
// import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:customer_core/src/domain/user/i_user_shared_prefs.dart';
import 'package:customer_core/src/domain/user/models/user_login_response.dart';

import '../../core/utils/alert_dialogs.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/utils.dart';
import '../../domain/cart/models/add_product_cart_request_model.dart';
import '../../domain/cart/models/cart_details_model.dart';
import '../../domain/checkout/i_checkout_repo.dart';
import '../../domain/checkout/models/calculated_delivery_charge_details_model.dart';
import '../../domain/checkout/models/checkout_data_model.dart';
import '../../domain/user/models/user_address_list_data_model.dart';

enum OrderType {
  delivery(label: "Delivery"),
  takeaway(label: "Takeaway");

  final String label;

  const OrderType({required this.label});
}

enum PaymentMethod {
  cash(label: "COD"),
  card(label: "Card");

  final String label;

  const PaymentMethod({required this.label});
}

@LazySingleton()
class CartProvider extends ChangeNotifier with BaseController {
  final ICartRepo cartRepo;
  final ICheckoutRepo checkRepo;
  final IOfferRepo offerRepo;
  final IUserSharedPrefsRepo sharedPrefsRepository;

  CartProvider({
    required this.cartRepo,
    required this.checkRepo,
    required this.offerRepo,
    required this.sharedPrefsRepository,
  });

  late TabController _tabController;

  TabController get tabController => _tabController;

  CartDetailsModel? _cartDetailsModel;

  CartDetailsModel? get cartDetailsModel => _cartDetailsModel;

  List<CartItemDataModel> get cartItems => _cartDetailsModel?.cartItems ?? [];
  String get carttTotalAmountNormalFormatted {
    String totalAmount = "0.000";
    for (var item in cartItems) {
      totalAmount =
          item.amountDetails?.itemDetails?.display?.totalAmountNormal ??
              "0.000";
    }

    return totalAmount;
  }

  String? get cartTotalPriceDisplay =>
      cartDetailsModel?.cartTotal?.cartTotalPriceDisplay;

  double? get cartTotalPrice =>
      cartDetailsModel?.cartTotal?.cartTotalPrice != null
          ? cartDetailsModel!.cartTotal!.cartTotalPrice! /
              AppConfig.instance.country.currencyDivisor
          : null;

  // double? get cartDiscountTotalDisplay =>
  //     cartDetailsModel?.cartTotal?.cartDiscountTotal != null
  //         ? cartDetailsModel!.cartTotal!.cartDiscountTotal! /
  //             AppConfig.instance.country.currencyDivisor
  //         : null;
  // String get subTotal {
  //   double total = 0;

  //   for (final item in cartItems) {
  //     total += double.tryParse(
  //           item.amountDetails?.itemDetails?.display?.totalAmountNormal
  //                   ?.replaceAll('BHD', '')
  //                   .trim() ??
  //               '0',
  //         ) ??
  //         0;
  //   }

  //   return 'BHD ${total.toStringAsFixed(3)}';
  // }
  // double get cartGrossAmount =>
  //     double.tryParse(
  //       selectedOrderType == OrderType.delivery
  //           ? deliveryDetails?.cartGrossAmount ?? '0.0'
  //           : takeAwayDetails?.cartGrossAmount ?? '0.0',
  //     ) ??
  //     0.0;

  int get totalCartItems => cartItems.length;

  bool get isCartEmpty => cartItems.isEmpty;

  ValueNotifier<bool> get isCartEmptyNotifier => ValueNotifier(isCartEmpty);

  ProductVariationDataModel? _selectedItemVariation;

  ProductVariationDataModel? get selectedItemVariation =>
      _selectedItemVariation;

  List<ProductsAddonDataModel> _selectedRegularAddons = [];

  List<ProductsAddonDataModel> get selectedRegularAddons =>
      _selectedRegularAddons;

  List<ProductMasterAddonDataModel> _selectedMasterAddons = [];

  List<ProductMasterAddonDataModel> get selectedMasterAddons =>
      _selectedMasterAddons;

  int _selectedItemQty = 1;

  int get selectedItemQty => _selectedItemQty;

  String? _selectedItemId;

  String? get selectedItemId => _selectedItemId;

  // double get selectedItemPrice {
  //   double selectedVariationPrice = 0.00;
  //   if (selectedItemVariation?.price != null) {
  //     try {
  //       selectedVariationPrice = double.parse(selectedItemVariation!.price!);
  //     } catch (e) {
  //       selectedVariationPrice = 0.00;
  //     }
  //   }
  //   final selectedAddonsOption =
  //       selectedRegularAddons.expand((e) => e.options).toList();
  //   final totalAddonsPrice = selectedAddonsOption.fold(0.00, (prev, curr) {
  //     try {
  //       return prev + (curr.price != null ? double.parse(curr.price!) : 0.00);
  //     } catch (e) {
  //       return prev;
  //     }
  //   });
  //   final selectedMasterAddonsOption =
  //       (selectedMasterAddons).expand((e) => e.options).toList();
  //   final totalMasterAddonsPrice =
  //       selectedMasterAddonsOption.fold(0.00, (prev, curr) {
  //     try {
  //       return prev + (curr.price != null ? double.parse(curr.price!) : 0.00);
  //     } catch (e) {
  //       return prev;
  //     }
  //   });
  //   return double.parse(
  //     (_selectedItemQty *
  //             (selectedVariationPrice +
  //                 totalAddonsPrice +
  //                 totalMasterAddonsPrice))
  //         .toStringAsFixed(AppConfig.instance.country.decimalPlaces),
  //   );
  // }

  final notesFieldKey = GlobalKey<FormBuilderFieldState>();
  String _deliveryNotes = '';

  String get deliveryNotes => _deliveryNotes;

  void setDeliveryNotes(String value) {
    _deliveryNotes = value;
    notifyListeners();
  }

  OrderType _selectedOrderType = OrderType.delivery;

  OrderType get selectedOrderType => _selectedOrderType;

  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;

  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;

  UserAddressDataModel? _selectedAddress;

  UserAddressDataModel? _selectedAddressSecondary;

  UserAddressDataModel? get selectedAddressSecondary =>
      _selectedAddressSecondary;

  UserAddressDataModel? get selectedAddress => _selectedAddress;

  DateTime? _selectedPickUpTime;

  DateTime? get selectedPickUpTime => _selectedPickUpTime;

  bool _deliveryOrTakeAwayChargeCalculating = false;

  bool get deliveryOrTakeAwayChargeCalculating =>
      _deliveryOrTakeAwayChargeCalculating;

  bool _createOrderPending = false;

  bool get createOrderPending => _createOrderPending;

  bool _isClearCartProgress = false;

  bool get isClearCartProgress => _isClearCartProgress;

  CalculatedDeliveryChargeDetailsModel? _deliveryDetails;

  CalculatedDeliveryChargeDetailsModel? get deliveryDetails => _deliveryDetails;

  double get calculatedDeliveryFee =>
      _deliveryDetails?.deliveryFeeAmount?.toDouble() ?? 0.00;

  // double get cartDiscountAmount {
  //   final value = _deliveryDetails?.amountFormatted?.cartDiscountAmount ?? "0";

  //   final cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

  //   return double.tryParse(cleanedValue) ?? 0.0;
  // }

  // double get deliveryDiscountAmount {
  //   final value = _deliveryDetails?.amountFormatted?.deliveryDiscount ?? "0";

  //   final cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

  //   return double.tryParse(cleanedValue) ?? 0.0;
  // }

  // double get totalDiscountAmount {
  //   final value = _deliveryDetails?.amountFormatted?.totalDiscount ?? "0";

  //   final cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

  //   return double.tryParse(cleanedValue) ?? 0.0;
  // }

  CalculateTakeAwayDetails? _takeAwayDetails;

  CalculateTakeAwayDetails? get takeAwayDetails => _takeAwayDetails;

  double get offerDiscount => _validatedCouponDetails?.coupenData == null
      ? 0.00
      : cartTotalPrice == null
          ? 0.00
          : _validatedCouponDetails!.coupenData!.coupenType == "percentage"
              ? (double.parse(
                          _validatedCouponDetails!.coupenData!.coupenAmount!) *
                      cartTotalPrice!) /
                  100
              : double.parse(
                  _validatedCouponDetails!.coupenData!.coupenAmount!);

  bool get isStripeEnabled => selectedOrderType == OrderType.delivery
      ? deliveryDetails?.cartData?.paymentOptions?.isStripeEnabled ??
          cartDetailsModel?.paymentOptions?.isStripeEnabled ??
          false
      : takeAwayDetails?.cartData?.paymentOptions?.isStripeEnabled ??
          cartDetailsModel?.paymentOptions?.isStripeEnabled ??
          false;

  bool get isCODEnabled => selectedOrderType == OrderType.delivery
      ? deliveryDetails?.cartData?.paymentOptions?.isCODEnabled ??
          cartDetailsModel?.paymentOptions?.isCODEnabled ??
          false
      : takeAwayDetails?.cartData?.paymentOptions?.isCODEnabled ??
          cartDetailsModel?.paymentOptions?.isCODEnabled ??
          false;

  double get discountAfterCouponApplied =>
      cartTotalPrice == null ? 0.00 : cartTotalPrice! - offerDiscount;

  double get calculatedDiscount => selectedOrderType == OrderType.delivery
      ? (double.tryParse(_deliveryDetails?.deliveryDiscount ?? '0.00') ?? 0.00)
      : (double.tryParse(_takeAwayDetails?.takeAwayDiscount ?? '0.00') ?? 0.00);

  double get totalCalculatedDiscount => calculatedDiscount + offerDiscount;
  // double get cartDiscount => selectedOrderType == OrderType.delivery
  //     ? (double.tryParse(_deliveryDetails?.cartDiscountAmount ?? '0.00') ??
  //         0.00)
  //     : (double.tryParse(_takeAwayDetails?.cartDiscountAmount ?? '0.00') ??
  //         0.00);

  // double get totalCartDiscount => totalCalculatedDiscount + cartDiscount;

  double get calculatedTax => selectedOrderType == OrderType.delivery
      ? (double.tryParse(_deliveryDetails?.taxTotalAmount ?? '0.00') ?? 0.00)
      : (double.tryParse(_takeAwayDetails?.taxTotalAmount ?? '0.00') ?? 0.00);

  double get totalAmount => cartTotalPrice == null
      ? 0.00
      : cartTotalPrice! +
          calculatedDeliveryFee -
          offerDiscount -
          calculatedDiscount +
          calculatedTax;

  bool _addItemLoading = false;

  bool get addItemLoading => _addItemLoading;

  List<OfferDetailsModel> _offerList = [];

  List<OfferDetailsModel> get offerList => _offerList;

  bool _isOfferListLoading = false;

  bool get isOfferListLoading => _isOfferListLoading;

  bool _cartDeleteLoading = false;

  bool get cartDeleteLoading => _cartDeleteLoading;

  ValidatedCouponDetails? _validatedCouponDetails;

  ValidatedCouponDetails? get validatedCouponDetails => _validatedCouponDetails;

  bool _cartLoading = false;

  bool get cartLoading => _cartLoading;

  bool _cartTransferring = false;

  bool get cartTransferring => _cartTransferring;

  int _selectedCartTabbarIndex = 0;
  int get selectedCartTabbarIndex => _selectedCartTabbarIndex;

  String? _guestID;
  String? get guestID => _guestID;

  final _cache = AsyncMemoizer<Uint8List>();

  bool _isProductAdded = false;
  bool get isProductAdded => _isProductAdded;

  bool _isUserLoggedIn = false;
  bool get isUserLoggedIn => _isUserLoggedIn;

  String get _activeCurrencySymbol =>
      (_cartDetailsModel?.shopCurrencyIcon?.trim().isNotEmpty ?? false)
          ? _cartDetailsModel!.shopCurrencyIcon!.trim()
          : AppConfig.instance.country.symbol;

  double _parseCurrencyToDouble(String? value) {
    if (value == null) return 0.0;
    final raw = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(raw) ?? 0.0;
  }

  String _formatDynamicCurrency(double value) {
    return "$_activeCurrencySymbol ${value.toStringAsFixed(AppConfig.instance.country.decimalPlaces)}";
  }

  @override
  Future<void> init() async {
    await getSavedGuestID();
    await listCartItems();
    listAllOffers();

    return super.init();
  }

  @override
  void dispose() {
    _tabController.removeListener(notifyListeners);
    _tabController.dispose();
    super.dispose();
  }

  void initController(TickerProvider tickerProvider, int length) {
    _tabController = TabController(length: length, vsync: tickerProvider);
    _tabController.addListener(notifyListeners);
  }

  void jumpToPage(int index) {
    if (index >= 0 && index < _tabController.length) {
      _tabController.animateTo(index);
      notifyListeners();
    }
  }

  void onchangeCartTabbarIndex(int index) {
    _selectedCartTabbarIndex = index;
    notifyListeners();
  }

  bool isProductExist(String? pID) {
    if (pID == null) return false;

    return cartItems.any((e) => e.pID == pID);
  }

  int getProductQuantity(String? pID) {
    if (pID == null) return 0;

    final product = cartItems.firstOrNullWhere(
      (e) => e.pID == pID,
    );

    final result = product?.quantity;

    // final qty = int.tryParse(result ?? '0') ?? 0;

    return result ?? 0;
  }

  //clear selected Address

  void clearSelectedAddress() {
    _selectedAddress = null;
    notifyListeners();
  }

  void clearDiscountValue() {
    _deliveryDetails = _deliveryDetails?.copyWith(deliveryDiscount: '0.00');
    _takeAwayDetails = _takeAwayDetails?.copyWith(takeAwayDiscount: '0.00');
    notifyListeners();
  }

  void onChangeGuestID(String? guestID) {
    _guestID = guestID;
    saveGuestID(guestID);
    notifyListeners();
  }

  Future<bool> saveGuestID(String? guestID) async {
    if (guestID == null) return false;
    return await sharedPrefsRepository.saveGuestID(guestID);
  }

  Future<String?> getSavedGuestID() async {
    final id = await sharedPrefsRepository.getGuestID();
    _guestID = id;
    notifyListeners();
    return id;
  }

  int getProductCartIndex(String? pID) {
    if (pID == null) {
      return -1; // Return -1 if pID is null (indicating not found)
    }

    return cartItems.indexWhere((e) => e.pID == pID);
  }

  Future<bool> checkUserIsLogged() async {
    _isUserLoggedIn = await sharedPrefsRepository.getUserData() != null;
    notifyListeners();
    return _isUserLoggedIn;
  }

  Future<UserLoginResponse?> getUserData() async =>
      await sharedPrefsRepository.getUserData();

  Future<void> listAllOffers() async {
    try {
      final isLogged = await checkUserIsLogged();
      if (!isLogged) return;
      _isOfferListLoading = true;
      notifyListeners();
      _offerList.clear();
      notifyListeners();
      final response = await offerRepo.listAllOffers();
      response.fold((exception) {
        AlertDialogs.showError(exception.message);
      }, (result) {
        _offerList = result;
        notifyListeners();
      });
    } finally {
      _isOfferListLoading = false;
      notifyListeners();
    }
  }

  Future<bool> validateOffer(String offerCode) async {
    final response = await offerRepo.validateCouponCode(offerCode);
    return response.fold(
      (exception) {
        AlertDialogs.showError(exception.message);
        return false;
      },
      (result) {
        if (result.coupenData?.minSpend != null &&
                cartTotalPrice != null &&
                double.parse(result.coupenData!.minSpend!) <= cartTotalPrice! ||
            (result.coupenData!.maxSpend == null ||
                double.parse(result.coupenData!.maxSpend!) > cartTotalPrice!)) {
          _validatedCouponDetails = result;
          notifyListeners();
          return true;
        }
        return false;
      },
    );
  }

  void onChangeVariation(ProductVariationDataModel variation) {
    _selectedItemVariation = variation;
    notifyListeners();
  }

  void onSelectAddon(
    ProductsAddonDataModel addon,
    ProductsOptionDataModel option,
  ) {
    final locModifierIndex = selectedRegularAddons.indexWhere((e) {
      return e.id == addon.id;
    });

    if (locModifierIndex == -1) {
      selectedRegularAddons.add(addon.copyWith(options: [option]));
    } else {
      final locModifier = selectedRegularAddons.elementAt(locModifierIndex);
      final options = List<ProductsOptionDataModel>.from(locModifier.options);

      if (options.contains(option)) {
        options.remove(option);
      } else {
        options.add(option);
      }

      selectedRegularAddons[locModifierIndex] =
          locModifier.copyWith(options: options);
    }

    notifyListeners();
  }

  bool checkOptionsIsSelected(
    ProductsAddonDataModel addon,
    ProductsOptionDataModel option,
  ) {
    final locModifier = selectedRegularAddons.firstOrNullWhere((e) {
      return e.id == addon.id;
    });
    if (locModifier == null) return false;
    return locModifier.options.contains(option);
  }

  bool checkMasterOptionsIsSelected(
    ProductMasterAddonDataModel addon,
    ProductsMasterAddonsOptionDataModel option,
  ) {
    final locModifier = selectedMasterAddons.firstOrNullWhere((e) {
      return e.id == addon.id;
    });
    if (locModifier == null) return false;
    return locModifier.options.contains(option);
  }

  void onSelectMasterAddon(
    ProductMasterAddonDataModel addon,
    ProductsMasterAddonsOptionDataModel option,
  ) {
    final locModifierIndex = selectedMasterAddons.indexWhere((e) {
      return e.id == addon.id;
    });

    if (locModifierIndex == -1) {
      selectedMasterAddons.add(addon.copyWith(options: [option]));
    } else {
      final locModifier = selectedMasterAddons.elementAt(locModifierIndex);
      final options = List<ProductsMasterAddonsOptionDataModel>.from(
        locModifier.options,
      );

      if (options.contains(option)) {
        options.remove(option);
      } else {
        options.add(option);
      }

      selectedMasterAddons[locModifierIndex] =
          locModifier.copyWith(options: options);
    }

    notifyListeners();
  }

  void incrementQty() {
    _selectedItemQty = _selectedItemQty + 1;
    notifyListeners();
  }

  void decrementQty() {
    if (_selectedItemQty == 1) return;
    _selectedItemQty = _selectedItemQty - 1;
    notifyListeners();
  }

  void updateSelectedItemId(String itemId) {
    _selectedItemId = itemId;
    notifyListeners();
  }

  bool validateRequiredModifiers(ProductDataModel product) {
    if (!product.hasMasterAddons) {
      return true;
    }

    for (var modifier in product.masterAddons) {
      final locatedModifier = selectedMasterAddons.firstOrNullWhere((e) {
        return e.id == modifier.id;
      });
      final minimumRequired = (modifier.minimumRequired ?? 0).toString();
      final maximumRequired = (modifier.maximumRequired ?? 0).toString();

      if (minimumRequired == "0" && maximumRequired == "0") continue;

      if (locatedModifier != null) {
        if (locatedModifier.options.length < int.parse(minimumRequired)) {
          AlertDialogs.showWarning(
            "${modifier.name} addon required minimum $minimumRequired",
          );
          return false;
        } else if (maximumRequired != "0" &&
            locatedModifier.options.length > int.parse(maximumRequired)) {
          AlertDialogs.showWarning(
            "${modifier.name} addon exceeded maximum $maximumRequired",
          );
          return false;
        }
      } else if (int.parse(minimumRequired) != 0 ||
          int.parse(maximumRequired) != 0) {
        AlertDialogs.showWarning(
          "${modifier.name} is required minimum $minimumRequired and maximum $maximumRequired",
        );
        return false;
      }
    }
    return true;
  }

  Future<bool> addItemToCart({bool isGuest = false}) async {
    try {
      if (_selectedItemId == null || _selectedItemVariation == null) {
        return false;
      }

      _addItemLoading = true;
      _isProductAdded = false;

      notifyListeners();

      final addons = Map.fromEntries(_selectedRegularAddons.map((e) {
        final optionsIds = e.options
            .where((option) => option.value != null)
            .map((option) => option.value!)
            .toList();
        return MapEntry(e.id!, optionsIds);
      }));

      final masterAddons = Map.fromEntries(_selectedMasterAddons.map((e) {
        final optionsIds = e.options
            .where((option) => option.itemId != null)
            .map((option) => option.itemId!)
            .toList();
        return MapEntry(e.id!, optionsIds);
      }));

      final payload = AddProductCartRequestDataModel(
        pID: _selectedItemId,
        rID: AppIdentifiers.kShopId,
        qty: _selectedItemQty.toString(),
        cOption: CartCOptionsDataModel(
          addons: addons,
          masterAddons: masterAddons,
          pvID: _selectedItemVariation!.pvID,
        ),
      );
      final userData = await getUserData();

      final result = await cartRepo.addCartItem(
          payload, isGuest, guestID, userData?.user.userID);

      final addedOrError = result.fold(() {
        _isProductAdded = true;
        notifyListeners();
        return true;
      }, (error) {
        AlertDialogs.showError(error.message);
        log(error.toString(), name: "Add Cart Item");
        return false;
      });

      listCartItems();

      return addedOrError;
    } finally {
      _addItemLoading = false;
      notifyListeners();
    }
  }

  Future<bool> transferCart() async {
    try {
      _cartTransferring = true;
      notifyListeners();
      final userData = await sharedPrefsRepository.getUserData();
      final userID = userData?.user.userID;
      await clearCart();

      final response =
          await cartRepo.transferCart(guestID: guestID, userID: userID);
      return response.fold(
        (exception) {
          AlertDialogs.showError(exception.message);
          return false;
        },
        (result) {
          return true;
        },
      );
    } finally {
      _cartTransferring = false;
      notifyListeners();
    }
  }

  Future<Uint8List> fetchFromCache(String url) => _cache.runOnce(
        () => NetworkAssetBundle(Uri.parse(url)).load(url).then(
              (value) => value.buffer.asUint8List(),
            ),
      );

  Future<void> listCartItems() async {
    try {
      final isLogged = await checkUserIsLogged();
      if (!isLogged) {
        if (_guestID == null) {
          final randomID = Utils.getRandomNumber();
          onChangeGuestID(randomID.toString());
        }
      }
      _cartLoading = true;
      notifyListeners();
      final userData = await getUserData();

      final response = await cartRepo.listCartItems(
          isGuest: !isLogged, guestID: _guestID, userID: userData?.user.userID);
      response.fold((exception) {
        log(exception.toString());
      }, (result) {
        _cartDetailsModel = result;
        notifyListeners();
      });
    } finally {
      _cartLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeCartItem(String? itemId) async {
    try {
      if (itemId == null || _cartDeleteLoading == true) return false;
      final isLogged = await checkUserIsLogged();
      if (!isLogged) {
        if (_guestID == null) {
          final randomID = Utils.getRandomNumber();
          onChangeGuestID(randomID.toString());
        }
      }
      _cartDeleteLoading = true;
      notifyListeners();
      final userData = await getUserData();
      final response = await cartRepo.deleteCartItem(
          id: itemId,
          isGuest: !isLogged,
          guestID: _guestID,
          userID: userData?.user.userID);
      final deleteOrNot = response.fold(() {
        return true;
      }, (error) {
        AlertDialogs.showError("Failed to remove cart item");
        log(error.toString(), name: "removeCartItem");
        return false;
      });
      await listCartItems();
      return deleteOrNot;
    } finally {
      _cartDeleteLoading = false;
      notifyListeners();
    }
  }

  Future<bool> incrementCartItemQty(int index) async {
    if (_cartDetailsModel == null || _cartDeleteLoading == true) return false;
    final locatedCartItem = cartItems.elementAt(index);
    final newQty = (locatedCartItem.quantity ?? 0) + 1;

    // _debounceTimer?.cancel();
    // _debounceTimer = Timer(
    //   const Duration(seconds: 2),
    //   () => _updateQty(locatedCartItem, newQty),
    // );

    _updateQty(locatedCartItem, newQty); // Call _updateQty directly

    final newCartItems = List<CartItemDataModel>.from(cartItems);
    final item = newCartItems[index];
    final prevQty = item.quantity ?? 1;
    final appliedMasterAddons = item.master_addon_apllied;
    final appliedAddons = item.addon_apllied;

    final updatedAppliedAddons = appliedAddons.map((e) {
      final updatedOptions = e.choosedOption.map((option) {
        final rawPrice = option.priceSingle;

        final price = _parseCurrencyToDouble(rawPrice);

        final updatedPrice = price * newQty;

        return option.copyWith(
          price: _formatDynamicCurrency(updatedPrice),
        );
      }).toList();

      return e.copyWith(choosedOption: updatedOptions);
    }).toList();

    final updatedAppliedMasterAddons = appliedMasterAddons.map((e) {
      final updatedOptions = e.choosedOption.map((option) {
        final rawPrice = option.priceSingle;

        final price = _parseCurrencyToDouble(rawPrice);

        final updatedPrice = price * newQty;

        return option.copyWith(
          price: _formatDynamicCurrency(updatedPrice),
        );
      }).toList();

      return e.copyWith(choosedOption: updatedOptions);
    }).toList();

    newCartItems[index] = item.copyWith(
      master_addon_apllied: updatedAppliedMasterAddons,
      addon_apllied: updatedAppliedAddons,
    );
    final itemProductPrice = _parseCurrencyToDouble(item.product_price);
    final itemProductPriceInPaisa =
        itemProductPrice * AppConfig.instance.country.currencyDivisor;
    final itemModifiersTotal = item.getModifiersTotal * newQty;
    final itemModifiersTotalInPaisa =
        itemModifiersTotal * AppConfig.instance.country.currencyDivisor;
    final totalItemPrice = newQty * itemProductPriceInPaisa;
    final productTotalPriceFormatted =
        (totalItemPrice) / AppConfig.instance.country.currencyDivisor;
    final updatedAmountDetails = _scaleAmountDetailsForQty(
      amountDetails: item.amountDetails,
      previousQty: prevQty,
      newQty: newQty,
    );

    newCartItems[index] = item.copyWith(
      cartID: locatedCartItem.cartID,
      quantity: newQty,
      master_addon_apllied: updatedAppliedMasterAddons,
      addon_apllied: updatedAppliedAddons,
      total: (totalItemPrice + itemModifiersTotalInPaisa).toInt(),
      amountDetails: updatedAmountDetails,
      product_total_price: _formatDynamicCurrency(productTotalPriceFormatted),
    );

    final totalAmountInPaisa = newCartItems.fold<int>(
      0,
      (sum, item) {
        log(sum.toString(), name: "totalAmountInPaisaSum");
        return sum + (item.total ?? 0);
      },
    );
    final totalDiscountInPaisa = newCartItems.fold<int>(
      0,
      (sum, item) => sum + (item.amountDetails?.totalDiscount ?? 0),
    );
    final totalNormalAmountInPaisa = newCartItems.fold<int>(
      0,
      (sum, item) =>
          sum +
          (item.amountDetails?.totalAmountWithAddonNormal ?? (item.total ?? 0)),
    );

    _cartDetailsModel = _cartDetailsModel!.copyWith(
      cartItems: newCartItems,
      cartTotal: _cartDetailsModel!.cartTotal!.copyWith(
        cartTotalPriceDisplay: _formatDynamicCurrency(
            totalAmountInPaisa / AppConfig.instance.country.currencyDivisor),
        cartTotalPrice: totalAmountInPaisa,
        cartDiscountTotal: totalDiscountInPaisa,
        cartTotalPrice_NormalDisplay: _formatDynamicCurrency(
            totalNormalAmountInPaisa /
                AppConfig.instance.country.currencyDivisor),
        cartDiscountTotalDisplay: _formatDynamicCurrency(
            totalDiscountInPaisa / AppConfig.instance.country.currencyDivisor),
      ),
    );

    notifyListeners();
    return true;
  }

  Future<bool> decrementCartItemQty(int index) async {
    if (_cartDetailsModel == null || _cartDeleteLoading == true) return false;
    final locatedCartItem = cartItems.elementAt(index);
    final prevQty = locatedCartItem.quantity ?? 0;
    if (prevQty == 1) {
      return removeCartItem(locatedCartItem.cartID);
    }
    final newQty = prevQty - 1;

    // _debounceTimer?.cancel();
    // _debounceTimer = Timer(
    //   const Duration(seconds: 2),
    //   () => _updateQty(locatedCartItem, newQty),
    // );

    _updateQty(locatedCartItem, newQty); // Call _updateQty directly

    final newCartItems = List<CartItemDataModel>.from(cartItems);
    final item = newCartItems[index];
    final prevQty1 = item.quantity ?? 1;
    final appliedMasterAddons = item.master_addon_apllied;
    final appliedAddons = item.addon_apllied;

    final updatedAppliedAddons = appliedAddons.map((e) {
      final updatedOptions = e.choosedOption.map((option) {
        final rawPrice = option.priceSingle;

        final price = _parseCurrencyToDouble(rawPrice);

        final updatedPrice = price * newQty;

        return option.copyWith(
          price: _formatDynamicCurrency(updatedPrice),
        );
      }).toList();

      return e.copyWith(choosedOption: updatedOptions);
    }).toList();

    final updatedAppliedMasterAddons = appliedMasterAddons.map((e) {
      final updatedOptions = e.choosedOption.map((option) {
        final rawPrice = option.priceSingle;

        final price = _parseCurrencyToDouble(rawPrice);

        final updatedPrice = price * newQty;

        return option.copyWith(
          price: _formatDynamicCurrency(updatedPrice),
        );
      }).toList();

      return e.copyWith(choosedOption: updatedOptions);
    }).toList();

    newCartItems[index] = item.copyWith(
        master_addon_apllied: updatedAppliedMasterAddons,
        addon_apllied: updatedAppliedAddons);
    final itemProductPrice = _parseCurrencyToDouble(item.product_price);
    final itemProductPriceInPaisa =
        itemProductPrice * AppConfig.instance.country.currencyDivisor;
    final itemModifiersTotal = item.getModifiersTotal * newQty;
    final itemModifiersTotalInPaisa =
        itemModifiersTotal * AppConfig.instance.country.currencyDivisor;
    final totalItemPrice = newQty * itemProductPriceInPaisa;
    final productTotalPriceFormatted =
        (totalItemPrice) / AppConfig.instance.country.currencyDivisor;
    final updatedAmountDetails = _scaleAmountDetailsForQty(
      amountDetails: item.amountDetails,
      previousQty: prevQty1,
      newQty: newQty,
    );

    newCartItems[index] = item.copyWith(
      cartID: locatedCartItem.cartID,
      quantity: newQty,
      master_addon_apllied: updatedAppliedMasterAddons,
      addon_apllied: updatedAppliedAddons,
      total: (totalItemPrice + itemModifiersTotalInPaisa).toInt(),
      amountDetails: updatedAmountDetails,
      product_total_price: _formatDynamicCurrency(productTotalPriceFormatted),
    );

    final totalAmountInPaisa = newCartItems.fold<int>(
      0,
      (sum, item) => sum + (item.total ?? 0),
    );
    final totalDiscountInPaisa = newCartItems.fold<int>(
      0,
      (sum, item) => sum + (item.amountDetails?.totalDiscount ?? 0),
    );
    final totalNormalAmountInPaisa = newCartItems.fold<int>(
      0,
      (sum, item) =>
          sum +
          (item.amountDetails?.totalAmountWithAddonNormal ?? (item.total ?? 0)),
    );

    _cartDetailsModel = _cartDetailsModel!.copyWith(
      cartItems: newCartItems,
      cartTotal: _cartDetailsModel!.cartTotal!.copyWith(
        cartTotalPriceDisplay: _formatDynamicCurrency(
            totalAmountInPaisa / AppConfig.instance.country.currencyDivisor),
        cartTotalPrice: totalAmountInPaisa,
        cartDiscountTotal: totalDiscountInPaisa,
        cartTotalPrice_NormalDisplay: _formatDynamicCurrency(
            totalNormalAmountInPaisa /
                AppConfig.instance.country.currencyDivisor),
        cartDiscountTotalDisplay: _formatDynamicCurrency(
            totalDiscountInPaisa / AppConfig.instance.country.currencyDivisor),
      ),
    );
    //new cart value => totalAmountInPaisa /  AppConfig.instance.country.currencyDivisor

    //validatedCouponDetails => minSpend

    _selectedAddress = null;
    _deliveryDetails = null;

    notifyListeners();
    return true;
  }

  CartAmountDetailsDataModel? _scaleAmountDetailsForQty({
    required CartAmountDetailsDataModel? amountDetails,
    required int previousQty,
    required int newQty,
  }) {
    if (amountDetails == null) return null;
    final safePrevQty = previousQty <= 0 ? 1 : previousQty;

    int scaleInt(int? value) {
      if (value == null) return 0;
      return ((value / safePrevQty) * newQty).round();
    }

    String? scaleCurrencyString(String? value) {
      if (value == null) return null;
      final raw = value.replaceAll(RegExp(r'[^0-9.]'), '');
      final parsed = double.tryParse(raw);
      if (parsed == null) return value;
      final scaled = (parsed / safePrevQty) * newQty;
      return _formatDynamicCurrency(scaled);
    }

    final display = amountDetails.display;
    final itemDetails = amountDetails.itemDetails;
    final itemDisplay = itemDetails?.display;

    return amountDetails.copyWith(
      totalAmountWithAddon: scaleInt(amountDetails.totalAmountWithAddon),
      totalAmountWithAddonExcTax:
          scaleInt(amountDetails.totalAmountWithAddonExcTax),
      totalAmountWithAddonNormal:
          scaleInt(amountDetails.totalAmountWithAddonNormal),
      totalDiscount: scaleInt(amountDetails.totalDiscount),
      display: display?.copyWith(
        totalAmountWithAddon: scaleCurrencyString(display.totalAmountWithAddon),
        totalAmountWithAddonNormal:
            scaleCurrencyString(display.totalAmountWithAddonNormal),
        totalDiscount: scaleCurrencyString(display.totalDiscount),
      ),
      itemDetails: itemDetails?.copyWith(
        totalAmount: scaleInt(itemDetails.totalAmount),
        totalAmountNormal: scaleInt(itemDetails.totalAmountNormal),
        totalDiscount: scaleInt(itemDetails.totalDiscount),
        display: itemDisplay?.copyWith(
          totalAmount: scaleCurrencyString(itemDisplay.totalAmount),
          totalAmountNormal: scaleCurrencyString(itemDisplay.totalAmountNormal),
          totalDiscount: scaleCurrencyString(itemDisplay.totalDiscount),
          totalAmountWithAddon:
              scaleCurrencyString(itemDisplay.totalAmountWithAddon),
        ),
      ),
    );
  }

  void _updateQty(CartItemDataModel cartItem, int newQty) async {
    if (cartItem.pID == null || cartItem.cartID == null) {
      AlertDialogs.showError("Invalid cart item");
      return;
    }
    final isLogged = await checkUserIsLogged();
    if (!isLogged) {
      if (_guestID == null) {
        final randomID = Utils.getRandomNumber();
        onChangeGuestID(randomID.toString());
      }
    }
    final payload = AddProductCartRequestDataModel(
      pID: cartItem.pID,
      rID: AppIdentifiers.kShopId,
      qty: newQty.toString(),
      cOption: cartItem.cOption,
    );
    final userData = await getUserData();
    final response = await cartRepo.updateCartItem(cartItem.cartID!, payload,
        isGuest: !isLogged, guestID: _guestID, userID: userData?.user.userID);
    response.fold(() {
      // listCartItems();
    }, (error) {
      AlertDialogs.showError(error.message);
    });
  }

  void onChangeOrderType(OrderType type) {
    _selectedOrderType = type;
    _selectedPaymentMethod = PaymentMethod.cash;
    notifyListeners();

    if (_selectedOrderType == OrderType.delivery) {
      calculateDeliveryCharge();
      return;
    } else {
      if (_selectedPickUpTime != null) {
        calculateTakeAwayCharge();
      }
      // calculateTakeAwayCharge(
      //   pickupTime: _selectedPickUpTime ??
      //       DateTime.now().add(const Duration(minutes: 15)),
      // );
    }
  }

  void onChangePaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  void onChangeAddress(UserAddressDataModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void selectedAddressSecondaryFunc(UserAddressDataModel address) {
    _selectedAddressSecondary = address;
    notifyListeners();
  }

  void clearSelectedAddressSecondary() {
    _selectedAddressSecondary = null;
  }

  void onChangePickUpTime(DateTime time) {
    _selectedPickUpTime = time;
    calculateTakeAwayCharge();
  }

  Future<bool> validateAddress() async {
    if (selectedAddress == null) {
      AlertDialogs.showInfo("Please pick an address");
      return false;
    }

    if (selectedOrderType == OrderType.delivery) {
      return await calculateDeliveryCharge();
    }

    return true;
  }

  bool validateInputData() {
    if (selectedAddress == null) {
      AlertDialogs.showInfo("Please pick an address");
      return false;
    }

    if (selectedOrderType == OrderType.delivery) {
      if (deliveryDetails == null) {
        calculateDeliveryCharge();
        return false;
      }
    } else if (selectedOrderType == OrderType.takeaway) {
      if (_selectedPickUpTime == null) {
        AlertDialogs.showInfo("Pick a time for takeaway");
        return false;
      }
      if (takeAwayDetails == null) {
        calculateTakeAwayCharge();
        return false;
      }
    }

    return true;
  }

  Future<bool> calculateDeliveryCharge() async {
    try {
      _deliveryDetails = null;
      notifyListeners();
      _deliveryOrTakeAwayChargeCalculating = true;
      notifyListeners();
      if (selectedAddress?.postcode == null) return false;
      final destinationPostCode = selectedAddress!.postcode!;
      final response = await checkRepo.calculateDeliveryFee(
        postCodeValidation:
            AppConfig.instance.country == Country.bh ? false : true,
        shopID: AppIdentifiers.kShopId,
        destinationPostCode: destinationPostCode,
      );

      return response.fold((error) {
        AlertDialogs.showError(error.message);
        return false;
      }, (result) {
        _deliveryDetails = result;
        _selectedAddressSecondary = _selectedAddress;
        notifyListeners();
        return true;
      });
    } finally {
      _deliveryOrTakeAwayChargeCalculating = false;
      notifyListeners();
    }
  }

  Future<void> calculateTakeAwayCharge({DateTime? pickupTime}) async {
    final effectivePickupTime = pickupTime ?? _selectedPickUpTime;

    if (effectivePickupTime == null) {
      return;
    }

    try {
      _takeAwayDetails = null;
      notifyListeners();

      _deliveryOrTakeAwayChargeCalculating = true;
      notifyListeners();

      final response = await checkRepo.calculateTakeAwayFee(
        effectivePickupTime,
      );

      response.fold((error) {
        if (pickupTime == null) {
          _selectedPickUpTime = null;
        }

        AlertDialogs.showError(error.message);
        notifyListeners();
      }, (details) {
        _takeAwayDetails = details;
        notifyListeners();
      });
    } finally {
      _deliveryOrTakeAwayChargeCalculating = false;
      notifyListeners();
    }
  }

  Future<bool> clearCart() async {
    try {
      final isLogged = await checkUserIsLogged();
      if (!isLogged) {
        if (_guestID == null) {
          final randomID = Utils.getRandomNumber();
          onChangeGuestID(randomID.toString());
        }
      }
      _isClearCartProgress = true;
      notifyListeners();
      final userData = await getUserData();
      final response = await cartRepo.clearCart(
          isGuest: !isLogged, guestID: _guestID, userID: userData?.user.userID);
      return response.fold(
        () {
          return true;
        },
        (t) {
          return false;
        },
      );
    } finally {
      _isClearCartProgress = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder({
    String? minWaitingTime,
    String tID = '',
    required String deliveryDate,
    required String deliverySlot,
  }) async {
    try {
      final userData = await getUserData();

      if (cartTotalPrice == null || userData == null) return false;
      _createOrderPending = true;
      notifyListeners();

      final customerAddress = CheckOutCustomerDataModel(
        customerName: selectedAddress?.userFullname,
        county: selectedAddress?.county,
        line1: selectedAddress?.line1,
        line2: selectedAddress?.line2,
        town: selectedAddress?.town,
        postcode: selectedAddress?.postcode,
        landmark: selectedAddress?.landmark,
        email: userData.user.userEmail,
        phone: userData.user.userMobile,
      );

      final data = CheckOutDataModel(
        shopID: AppIdentifiers.kShopId,
        discount: totalCalculatedDiscount
            .toStringAsFixed(AppConfig.instance.country.decimalPlaces),
        amount: (totalAmount * AppConfig.instance.country.currencyDivisor)
            .toStringAsFixed(AppConfig.instance.country.decimalPlaces),
        couponAmount: validatedCouponDetails?.coupenData == null
            ? ''
            : offerDiscount
                .toStringAsFixed(AppConfig.instance.country.decimalPlaces),
        couponCode: validatedCouponDetails?.coupenCode ?? '',
        couponType: validatedCouponDetails?.coupenData?.coupenType ?? '',
        couponValue: validatedCouponDetails?.coupenData?.coupenAmount ?? '',
        source: 'Flutter',
        deliveryType: selectedOrderType == OrderType.delivery
            ? 'door_delivery'
            : 'store_pickup',
        approxDeliveryTime: minWaitingTime ?? '',
        deliveryCharge: selectedOrderType == OrderType.delivery
            ? (calculatedDeliveryFee *
                    AppConfig.instance.country.currencyDivisor)
                .toStringAsFixed(AppConfig.instance.country.decimalPlaces)
            : '',
        takeawayTime: selectedOrderType == OrderType.takeaway
            ? DateTimeUtils.convertDateTime12HrTo24Hr(selectedPickUpTime!)
            : '',
        paymentGatway:
            selectedPaymentMethod == PaymentMethod.cash ? 'COD' : 'STRIPE',
        transactionID: selectedPaymentMethod == PaymentMethod.cash ? '' : tID,
        paymentStatus: selectedPaymentMethod == PaymentMethod.cash ? '0' : '1',
        deliveryNotes: _deliveryNotes,
        deliveryLocation: selectedAddress?.addressTitle,
        deliveryDate: deliveryDate,
        deliverySlot: deliverySlot,
        customer: customerAddress,
        projectID: AppIdentifiers.kProjectID,
        isSingleVendor: 'Yes',
        postCode: selectedOrderType == OrderType.delivery
            ? selectedAddress?.postcode
            : '',
        postCodeValidation: 'false',
      );

      log(data.toJson());
      // pi_3SdTp2HeVTRCojcj0CF7yKFk

      // return false;

      final response = await checkRepo.completeOrder(data: data);
      return response.fold((exception) {
        AlertDialogs.showError(exception.message);
        return false;
      }, (result) {
        AlertDialogs.showSuccess("Order created successfully!");
        return true;
      });
    } finally {
      _createOrderPending = false;
      notifyListeners();
      listCartItems();
    }
  }

  void resetValues() {
    _selectedItemId = null;
    _selectedMasterAddons = [];
    _selectedRegularAddons = [];
    _selectedItemVariation = null;
    _selectedItemQty = 1;
    _selectedAddress = null;
    _deliveryNotes = '';
    _deliveryDetails = null;
    _takeAwayDetails = null;
    _createOrderPending = false;
    _validatedCouponDetails = null;
    _selectedAddressSecondary = null;
    _selectedPickUpTime = null;
    _selectedOrderType = OrderType.delivery;
    _selectedPaymentMethod = PaymentMethod.cash;
    notifyListeners();

    // _debounceTimer?.cancel();
  }

  void clearCalculatedDeliveryDetails() {
    _deliveryDetails = null;
    notifyListeners();
  }

  void removeCouponCode() {
    _validatedCouponDetails = null;
    notifyListeners();
  }
}
