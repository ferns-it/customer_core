// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:customer_core/customer_core.dart';

import 'add_product_cart_request_model.dart';

class CartDetailsModel {
  final String? restaurantID;
  final String? restaurantName;
  final List<CartItemDataModel> cartItems;
  final CartItemTotalSummary? cartTotal;
  final CartItemPaymentDetails? paymentOptions;
  final String? shopCurrency;
  final String? shopCurrencyIcon;
  final String? shopPhone;

  CartDetailsModel({
    this.restaurantID,
    this.restaurantName,
    this.cartItems = const [],
    this.cartTotal,
    this.paymentOptions,
    this.shopCurrency,
    this.shopCurrencyIcon,
    this.shopPhone,
  });

  CartDetailsModel copyWith({
    String? restaurantID,
    String? restaurantName,
    List<CartItemDataModel>? cartItems,
    CartItemTotalSummary? cartTotal,
    CartItemPaymentDetails? paymentOptions,
    String? shopCurrency,
    String? shopCurrencyIcon,
    String? shopPhone,
  }) {
    return CartDetailsModel(
      restaurantID: restaurantID ?? this.restaurantID,
      restaurantName: restaurantName ?? this.restaurantName,
      cartItems: cartItems ?? this.cartItems,
      cartTotal: cartTotal ?? this.cartTotal,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      shopCurrency: shopCurrency ?? this.shopCurrency,
      shopCurrencyIcon: shopCurrencyIcon ?? this.shopCurrencyIcon,
      shopPhone: shopPhone ?? this.shopPhone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restaurantID': restaurantID,
      'restaurantName': restaurantName,
      'cartItems': cartItems.map((x) => x.toMap()).toList(),
      'cartTotal': cartTotal?.toMap(),
      'paymentOptions': paymentOptions?.toMap(),
      'shopCurrency': shopCurrency,
      'shopCurrencyIcon': shopCurrencyIcon,
      'shopPhone': shopPhone,
    };
  }

  factory CartDetailsModel.fromMap(Map<String, dynamic> map) {
    return CartDetailsModel(
      restaurantID:
          map['restaurantID'] != null ? map['restaurantID'] as String : null,
      restaurantName: map['restaurantName'] != null
          ? map['restaurantName'] as String
          : null,
      cartItems: List<CartItemDataModel>.from(
        (map['cartItems'] ?? []).map<CartItemDataModel?>(
          (x) => CartItemDataModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      cartTotal: map['cartTotal'] != null
          ? CartItemTotalSummary.fromMap(
              map['cartTotal'] as Map<String, dynamic>)
          : null,
      paymentOptions: map['paymentOptions'] != null
          ? CartItemPaymentDetails.fromMap(
              map['paymentOptions'] as Map<String, dynamic>)
          : null,
      shopCurrency:
          map['shopCurrency'] != null ? map['shopCurrency'] as String : null,
      shopCurrencyIcon: map['shopCurrencyIcon'] != null
          ? map['shopCurrencyIcon'] as String
          : null,
      shopPhone: map['shopPhone'] != null ? map['shopPhone'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartDetailsModel.fromJson(String source) =>
      CartDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartSummarySubDataModel(restaurantID: $restaurantID, restaurantName: $restaurantName, cartItems: $cartItems, cartTotal: $cartTotal, paymentOptions: $paymentOptions,shopCurrency: $shopCurrency,shopCurrencyIcon: $shopCurrencyIcon,shopPhone: $shopPhone)';
  }

  @override
  bool operator ==(covariant CartDetailsModel other) {
    if (identical(this, other)) return true;

    return other.restaurantID == restaurantID &&
        other.restaurantName == restaurantName &&
        listEquals(other.cartItems, cartItems) &&
        other.cartTotal == cartTotal &&
        other.paymentOptions == paymentOptions &&
        other.shopCurrency == shopCurrency &&
        other.shopCurrencyIcon == shopCurrencyIcon &&
        other.shopPhone == shopPhone;
  }

  @override
  int get hashCode {
    return restaurantID.hashCode ^
        restaurantName.hashCode ^
        cartItems.hashCode ^
        cartTotal.hashCode ^
        paymentOptions.hashCode ^
        shopCurrency.hashCode ^
        shopCurrencyIcon.hashCode ^
        shopPhone.hashCode;
  }

  double get getOfferDiscount {
    double total = 0.0;
    for (final element in cartItems) {
      if (element.amountDetails?.isOfferApplied ?? false) {
        final int discount = element.amountDetails?.totalDiscount ?? 0;
        total += discount.toDouble();
      }
    }
    final double totalDiscount =
        total / AppConfig.instance.country.currencyDivisor;
    return totalDiscount;
  }
}

class CartItemDataModel {
  final String? pID;
  final String? productName;
  final int? quantity;
  final String? cartID;
  final String? product_price;
  final String? product_total_price;
  final String? product_normal_price;
  final int? total;
  final String? display_total;
  final String? variation;
  final List<AppliedAddonsDetails> addon_apllied;
  final List<AppliedAddonsDetails> master_addon_apllied;
  final CartCOptionsDataModel? cOption;
  final String? productPhoto;
  final CartAmountDetailsDataModel? amountDetails;

  final String? type;
  final String? identifierName;
  final String? description;
  final String? ingredients;

  CartItemDataModel({
    this.pID,
    this.productName,
    this.quantity,
    this.cartID,
    this.product_price,
    this.product_total_price,
    this.product_normal_price,
    this.total,
    this.display_total,
    this.variation,
    this.addon_apllied = const [],
    this.master_addon_apllied = const [],
    this.cOption,
    this.productPhoto,
    this.amountDetails,
    this.type,
    this.identifierName,
    this.description,
    this.ingredients,
  });

  CartItemDataModel copyWith({
    String? pID,
    String? productName,
    int? quantity,
    String? cartID,
    String? product_price,
    String? product_total_price,
    String? product_normal_price,
    int? total,
    String? display_total,
    String? variation,
    List<AppliedAddonsDetails>? addon_apllied,
    List<AppliedAddonsDetails>? master_addon_apllied,
    CartCOptionsDataModel? cOption,
    String? productPhoto,
    CartAmountDetailsDataModel? amountDetails,
    String? type,
    String? identifierName,
    String? description,
    String? ingredients,
  }) {
    return CartItemDataModel(
      pID: pID ?? this.pID,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      cartID: cartID ?? this.cartID,
      product_price: product_price ?? this.product_price,
      product_total_price: product_total_price ?? this.product_total_price,
      product_normal_price: product_normal_price ?? this.product_normal_price,
      total: total ?? this.total,
      display_total: display_total ?? this.display_total,
      variation: variation ?? this.variation,
      addon_apllied: addon_apllied ?? this.addon_apllied,
      master_addon_apllied: master_addon_apllied ?? this.master_addon_apllied,
      cOption: cOption ?? this.cOption,
      productPhoto: productPhoto ?? this.productPhoto,
      amountDetails: amountDetails ?? this.amountDetails,
      type: type ?? this.type,
      identifierName: identifierName ?? this.identifierName,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pID': pID,
      'productName': productName,
      'quantity': quantity,
      'cartID': cartID,
      'product_price': product_price,
      'product_total_price': product_total_price,
      'product_normal_price': product_normal_price,
      'total': total,
      'display_total': display_total,
      'variation': variation,
      'addon_apllied': addon_apllied.map((x) => x.toMap()).toList(),
      'master_addon_apllied':
          master_addon_apllied.map((x) => x.toMap()).toList(),
      'cOption': cOption?.toMap(),
      'productPhoto': productPhoto,
      'amountDetails': amountDetails?.toMap(),
      'type': type,
      'identifierName': identifierName,
      'description': description,
      'ingredients': ingredients,
    };
  }

  factory CartItemDataModel.fromMap(Map<String, dynamic> map) {
    return CartItemDataModel(
      pID: map['pID'] != null ? map['pID'] as String : null,
      productName:
          map['productName'] != null ? map['productName'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      cartID: map['cartID'] != null ? map['cartID'] as String : null,
      product_price:
          map['product_price'] != null ? map['product_price'] as String : null,
      product_total_price: map['product_total_price'] != null
          ? map['product_total_price'] as String
          : null,
      product_normal_price: map['product_normal_price'] != null
          ? map['product_normal_price'] as String
          : null,
      total: map['total'] != null ? map['total'] as int : null,
      display_total:
          map['display_total'] != null ? map['display_total'] as String : null,
      variation: map['variation'] != null ? map['variation'] as String : null,
      addon_apllied: List<AppliedAddonsDetails>.from(
        (map['addon_apllied'] ?? []).map<AppliedAddonsDetails>(
          (x) => AppliedAddonsDetails.fromMap(x as Map<String, dynamic>),
        ),
      ),
      master_addon_apllied: List<AppliedAddonsDetails>.from(
        (map['master_addon_apllied'] ?? []).map<AppliedAddonsDetails>(
          (x) => AppliedAddonsDetails.fromMap(x as Map<String, dynamic>),
        ),
      ),
      cOption: map['cOption'] != null
          ? CartCOptionsDataModel.fromMap(
              map['cOption'] as Map<String, dynamic>)
          : null,
      productPhoto:
          map['productPhoto'] != null ? map['productPhoto'] as String : null,
      amountDetails: map['amountDetails'] != null
          ? CartAmountDetailsDataModel.fromMap(
              map['amountDetails'] as Map<String, dynamic>)
          : null,
      type: map['type'] != null ? map['type'] as String : null,
      identifierName: map['identifierName'] != null
          ? map['identifierName'] as String
          : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      ingredients:
          map['ingredients'] != null ? map['ingredients'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemDataModel.fromJson(String source) =>
      CartItemDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  double get getModifiersTotal {
    final total = addon_apllied.isNotEmpty
        ? addon_apllied
            .expand((e) => e.choosedOption.map((e) => double.parse(
                (e.priceSingle ?? "0.00")
                    .replaceAll(AppConfig.instance.country.symbol, ""))))
            .reduce((a, b) => a + b)
        : 0.0;

    final totalMasterAddons = master_addon_apllied.isNotEmpty
        ? master_addon_apllied
            .expand((e) => e.choosedOption.map((e) => double.parse(
                (e.priceSingle ?? "0.00")
                    .replaceAll(AppConfig.instance.country.symbol, ""))))
            .reduce((a, b) => a + b)
        : 0.0;

    return total + totalMasterAddons;
  }

  @override
  String toString() {
    return 'CartItemDataModel(pID: $pID, productName: $productName, quantity: $quantity, cartID: $cartID, product_price: $product_price, product_total_price: $product_total_price, product_normal_price: $product_normal_price,total: $total, display_total: $display_total, variation: $variation, addon_apllied: $addon_apllied, master_addon_apllied: $master_addon_apllied, cOption: $cOption, productPhoto: $productPhoto, amountDetails: $amountDetails, type: $type, identifierName: $identifierName, description: $description, ingredients: $ingredients)';
  }

  @override
  bool operator ==(covariant CartItemDataModel other) {
    if (identical(this, other)) return true;

    return other.pID == pID &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.cartID == cartID &&
        other.product_price == product_price &&
        other.product_total_price == product_total_price &&
        other.product_normal_price == product_normal_price &&
        other.total == total &&
        other.display_total == display_total &&
        other.variation == variation &&
        listEquals(other.addon_apllied, addon_apllied) &&
        listEquals(other.master_addon_apllied, master_addon_apllied) &&
        other.cOption == cOption &&
        other.productPhoto == productPhoto &&
        other.amountDetails == amountDetails &&
        other.type == type &&
        other.identifierName == identifierName &&
        other.description == description &&
        other.ingredients == ingredients;
  }

  @override
  int get hashCode {
    return pID.hashCode ^
        productName.hashCode ^
        quantity.hashCode ^
        cartID.hashCode ^
        product_price.hashCode ^
        product_total_price.hashCode ^
        product_normal_price.hashCode ^
        total.hashCode ^
        display_total.hashCode ^
        variation.hashCode ^
        addon_apllied.hashCode ^
        master_addon_apllied.hashCode ^
        cOption.hashCode ^
        productPhoto.hashCode ^
        amountDetails.hashCode ^
        type.hashCode ^
        identifierName.hashCode ^
        description.hashCode ^
        ingredients.hashCode;
  }
}

class AppliedAddonsDetails {
  final String? title;
  final List<ChoosedModifierOption> choosedOption;

  AppliedAddonsDetails({
    this.title,
    this.choosedOption = const [],
  });

  AppliedAddonsDetails copyWith({
    String? title,
    List<ChoosedModifierOption>? choosedOption,
  }) {
    return AppliedAddonsDetails(
      title: title ?? this.title,
      choosedOption: choosedOption ?? this.choosedOption,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'choosedOption': choosedOption.map((x) => x.toMap()).toList(),
    };
  }

  factory AppliedAddonsDetails.fromMap(Map<String, dynamic> map) {
    return AppliedAddonsDetails(
      title: map['title'] != null ? map['title'] as String : null,
      choosedOption: List<ChoosedModifierOption>.from(
        (map['choosedOption'] ?? []).map<ChoosedModifierOption?>(
          (x) => ChoosedModifierOption.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppliedAddonsDetails.fromJson(String source) =>
      AppliedAddonsDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AppliedAddonsDetails(title: $title, choosedOption: $choosedOption)';

  @override
  bool operator ==(covariant AppliedAddonsDetails other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        listEquals(other.choosedOption, choosedOption);
  }

  @override
  int get hashCode => title.hashCode ^ choosedOption.hashCode;
}

class ChoosedModifierOption {
  final String? text;
  final String? price;
  final String? priceSingle;

  ChoosedModifierOption({
    this.text,
    this.price,
    this.priceSingle,
  });

  ChoosedModifierOption copyWith({
    String? text,
    String? price,
    String? priceSingle,
  }) {
    return ChoosedModifierOption(
      text: text ?? this.text,
      price: price ?? this.price,
      priceSingle: priceSingle ?? this.priceSingle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'price': price,
      'itemPrice': priceSingle,
    };
  }

  factory ChoosedModifierOption.fromMap(Map<String, dynamic> map) {
    return ChoosedModifierOption(
      text: map['text'] != null ? map['text'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      priceSingle: map['itemPrice'] != null ? map['itemPrice'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChoosedModifierOption.fromJson(String source) =>
      ChoosedModifierOption.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChoosedModifierOption(text: $text, price: $price, priceSingle: $priceSingle)';

  @override
  bool operator ==(covariant ChoosedModifierOption other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.price == price &&
        other.priceSingle == priceSingle;
  }

  @override
  int get hashCode => text.hashCode ^ price.hashCode ^ priceSingle.hashCode;
}

class CartItemTotalSummary {
  final int? cartTotalPrice;
  final String? cartTotalPriceDisplay;
  final int? cartDiscountTotal;
  final String? cartDiscountTotalDisplay;

  CartItemTotalSummary({
    this.cartTotalPrice,
    this.cartTotalPriceDisplay,
    this.cartDiscountTotal,
    this.cartDiscountTotalDisplay,
  });

  CartItemTotalSummary copyWith({
    int? cartTotalPrice,
    String? cartTotalPriceDisplay,
    int? cartDiscountTotal,
    String? cartDiscountTotalDisplay,
  }) {
    return CartItemTotalSummary(
      cartTotalPrice: cartTotalPrice ?? this.cartTotalPrice,
      cartTotalPriceDisplay:
          cartTotalPriceDisplay ?? this.cartTotalPriceDisplay,
      cartDiscountTotal: cartDiscountTotal ?? this.cartDiscountTotal,
      cartDiscountTotalDisplay:
          cartDiscountTotalDisplay ?? this.cartDiscountTotalDisplay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartTotalPrice': cartTotalPrice,
      'cartTotalPriceDisplay': cartTotalPriceDisplay,
      'cartDiscountTotal': cartDiscountTotal,
      'cartDiscountTotalDisplay': cartDiscountTotalDisplay,
    };
  }

  factory CartItemTotalSummary.fromMap(Map<String, dynamic> map) {
    return CartItemTotalSummary(
      cartTotalPrice:
          map['cartTotalPrice'] != null ? map['cartTotalPrice'] as int : null,
      cartTotalPriceDisplay: map['cartTotalPriceDisplay'] != null
          ? map['cartTotalPriceDisplay'] as String
          : null,
      cartDiscountTotal: map['cartDiscountTotal'] != null
          ? map['cartDiscountTotal'] as int
          : null,
      cartDiscountTotalDisplay: map['cartDiscountTotalDisplay'] != null
          ? map['cartDiscountTotalDisplay'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemTotalSummary.fromJson(String source) =>
      CartItemTotalSummary.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartItemTotalSummary(cartTotalPrice: $cartTotalPrice, cartTotalPriceDisplay: $cartTotalPriceDisplay, cartDiscountTotal: $cartDiscountTotal, cartDiscountTotalDisplay: $cartDiscountTotalDisplay)';

  @override
  bool operator ==(covariant CartItemTotalSummary other) {
    if (identical(this, other)) return true;

    return other.cartTotalPrice == cartTotalPrice &&
        other.cartTotalPriceDisplay == cartTotalPriceDisplay &&
        other.cartDiscountTotal == cartDiscountTotal &&
        other.cartDiscountTotalDisplay == cartDiscountTotalDisplay;
  }

  @override
  int get hashCode =>
      cartTotalPrice.hashCode ^
      cartTotalPriceDisplay.hashCode ^
      cartDiscountTotal.hashCode ^
      cartDiscountTotalDisplay.hashCode;
}

class CartItemPaymentDetails {
  final String? cod;
  final String? stripe;
  final String? shopStatus;
  final String? QrUPI;
  final String? QrUPI_Image;

  CartItemPaymentDetails({
    this.cod,
    this.stripe,
    this.shopStatus,
    this.QrUPI,
    this.QrUPI_Image,
  });

  CartItemPaymentDetails copyWith({
    String? cod,
    String? stripe,
    String? shopStatus,
    String? QrUPI,
    String? QrUPI_Image,
  }) {
    return CartItemPaymentDetails(
      cod: cod ?? this.cod,
      stripe: stripe ?? this.stripe,
      shopStatus: shopStatus ?? this.shopStatus,
      QrUPI: QrUPI ?? this.QrUPI,
      QrUPI_Image: QrUPI_Image ?? this.QrUPI_Image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cod': cod,
      'stripe': stripe,
      'shopStatus': shopStatus,
      'QrUPI': QrUPI,
      'QrUPI_Image': QrUPI_Image,
    };
  }

  factory CartItemPaymentDetails.fromMap(Map<String, dynamic> map) {
    return CartItemPaymentDetails(
      cod: map['cod'] != null ? map['cod'] as String : null,
      stripe: map['stripe'] != null ? map['stripe'] as String : null,
      shopStatus:
          map['shopStatus'] != null ? map['shopStatus'] as String : null,
      QrUPI: map['QrUPI'] != null ? map['QrUPI'] as String : null,
      QrUPI_Image:
          map['QrUPI_Image'] != null ? map['QrUPI_Image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemPaymentDetails.fromJson(String source) =>
      CartItemPaymentDetails.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartItemPaymentDetails(cod: $cod, stripe: $stripe, shopStatus: $shopStatus, QrUPI: $QrUPI, QrUPI_Image: $QrUPI_Image)';

  @override
  bool operator ==(covariant CartItemPaymentDetails other) {
    if (identical(this, other)) return true;

    return other.cod == cod &&
        other.stripe == stripe &&
        other.shopStatus == shopStatus &&
        other.QrUPI == QrUPI &&
        other.QrUPI_Image == QrUPI_Image;
  }

  @override
  int get hashCode =>
      cod.hashCode ^
      stripe.hashCode ^
      shopStatus.hashCode ^
      QrUPI.hashCode ^
      QrUPI_Image.hashCode;

  bool get isStripeEnabled => stripe == 'Enabled';
  bool get isCODEnabled => cod == 'Enabled';
}

class CartAmountDetailsDataModel {
  final bool? isOfferApplied;
  final bool? isTaxApplied;
  final int? totalAmountWithAddon;
  final int? totalAmountWithAddonExcTax;
  final int? totalAmountWithAddonNormal;
  final int? totalDiscount;
  final CartAmountDetailsDisplayDataModel? display;
  final CartAmountItemDetailsDataModel? itemDetails;
  final CartAmountTaxConfigDataModel? taxConfig;

  CartAmountDetailsDataModel({
    this.isOfferApplied,
    this.isTaxApplied,
    this.totalAmountWithAddon,
    this.totalAmountWithAddonExcTax,
    this.totalAmountWithAddonNormal,
    this.totalDiscount,
    this.display,
    this.itemDetails,
    this.taxConfig,
  });

  CartAmountDetailsDataModel copyWith({
    bool? isOfferApplied,
    bool? isTaxApplied,
    int? totalAmountWithAddon,
    int? totalAmountWithAddonExcTax,
    int? totalAmountWithAddonNormal,
    int? totalDiscount,
    CartAmountDetailsDisplayDataModel? display,
    CartAmountItemDetailsDataModel? itemDetails,
    CartAmountTaxConfigDataModel? taxConfig,
  }) {
    return CartAmountDetailsDataModel(
      isOfferApplied: isOfferApplied ?? this.isOfferApplied,
      isTaxApplied: isTaxApplied ?? this.isTaxApplied,
      totalAmountWithAddon: totalAmountWithAddon ?? this.totalAmountWithAddon,
      totalAmountWithAddonExcTax:
          totalAmountWithAddonExcTax ?? this.totalAmountWithAddonExcTax,
      totalAmountWithAddonNormal:
          totalAmountWithAddonNormal ?? this.totalAmountWithAddonNormal,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      display: display ?? this.display,
      itemDetails: itemDetails ?? this.itemDetails,
      taxConfig: taxConfig ?? this.taxConfig,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isOfferApplied': isOfferApplied,
      'isTaxApplied': isTaxApplied,
      'totalAmountWithAddon': totalAmountWithAddon,
      'totalAmountWithAddonExcTax': totalAmountWithAddonExcTax,
      'totalAmountWithAddon_Normal': totalAmountWithAddonNormal,
      'totalDiscount': totalDiscount,
      'display': display?.toMap(),
      'itemDetails': itemDetails?.toMap(),
      'taxConfig': taxConfig?.toMap(),
    };
  }

  factory CartAmountDetailsDataModel.fromMap(Map<String, dynamic> map) {
    return CartAmountDetailsDataModel(
      isOfferApplied:
          map['isOfferApplied'] != null ? map['isOfferApplied'] as bool : null,
      isTaxApplied:
          map['isTaxApplied'] != null ? map['isTaxApplied'] as bool : null,
      totalAmountWithAddon: map['totalAmountWithAddon'] != null
          ? map['totalAmountWithAddon'] as int
          : null,
      totalAmountWithAddonExcTax: map['totalAmountWithAddonExcTax'] != null
          ? map['totalAmountWithAddonExcTax'] as int
          : null,
      totalAmountWithAddonNormal: map['totalAmountWithAddon_Normal'] != null
          ? map['totalAmountWithAddon_Normal'] as int
          : null,
      totalDiscount:
          map['totalDiscount'] != null ? map['totalDiscount'] as int : null,
      display: map['display'] != null
          ? CartAmountDetailsDisplayDataModel.fromMap(
              map['display'] as Map<String, dynamic>)
          : null,
      itemDetails: map['ItemDetails'] != null
          ? CartAmountItemDetailsDataModel.fromMap(
              map['ItemDetails'] as Map<String, dynamic>)
          : null,
      taxConfig: map['TaxConfig'] != null
          ? CartAmountTaxConfigDataModel.fromMap(
              map['TaxConfig'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartAmountDetailsDataModel.fromJson(String source) =>
      CartAmountDetailsDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartAmountDetailsDataModel(isOfferApplied: $isOfferApplied, isTaxApplied: $isTaxApplied, totalAmountWithAddon: $totalAmountWithAddon, totalAmountWithAddonExcTax: $totalAmountWithAddonExcTax, totalAmountWithAddonNormal: $totalAmountWithAddonNormal, totalDiscount: $totalDiscount, display: $display, itemDetails: $itemDetails, taxConfig: $taxConfig)';

  @override
  bool operator ==(covariant CartAmountDetailsDataModel other) {
    if (identical(this, other)) return true;

    return other.isOfferApplied == isOfferApplied &&
        other.isTaxApplied == isTaxApplied &&
        other.totalAmountWithAddon == totalAmountWithAddon &&
        other.totalAmountWithAddonExcTax == totalAmountWithAddonExcTax &&
        other.totalAmountWithAddonNormal == totalAmountWithAddonNormal &&
        other.totalDiscount == totalDiscount &&
        other.display == display &&
        other.itemDetails == itemDetails &&
        other.taxConfig == taxConfig;
  }

  @override
  int get hashCode =>
      isOfferApplied.hashCode ^
      isTaxApplied.hashCode ^
      totalAmountWithAddon.hashCode ^
      totalAmountWithAddonExcTax.hashCode ^
      totalAmountWithAddonNormal.hashCode ^
      totalDiscount.hashCode ^
      display.hashCode ^
      itemDetails.hashCode ^
      taxConfig.hashCode;
}

class CartAmountDetailsDisplayDataModel {
  final String? totalAmountWithAddon;
  final String? totalAmountWithAddonNormal;
  final String? totalDiscount;

  CartAmountDetailsDisplayDataModel({
    this.totalAmountWithAddon,
    this.totalAmountWithAddonNormal,
    this.totalDiscount,
  });

  CartAmountDetailsDisplayDataModel copyWith({
    bool? isOfferApplied,
    String? totalAmountWithAddon,
    String? totalAmountWithAddonNormal,
    String? totalDiscount,
  }) {
    return CartAmountDetailsDisplayDataModel(
      totalAmountWithAddon: totalAmountWithAddon ?? this.totalAmountWithAddon,
      totalAmountWithAddonNormal:
          totalAmountWithAddonNormal ?? this.totalAmountWithAddonNormal,
      totalDiscount: totalDiscount ?? this.totalDiscount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalAmountWithAddon': totalAmountWithAddon,
      'totalAmountWithAddon_Normal': totalAmountWithAddonNormal,
      'totalDiscount': totalDiscount,
    };
  }

  factory CartAmountDetailsDisplayDataModel.fromMap(Map<String, dynamic> map) {
    return CartAmountDetailsDisplayDataModel(
      totalAmountWithAddon: map['totalAmountWithAddon'] != null
          ? map['totalAmountWithAddon'] as String
          : null,
      totalAmountWithAddonNormal: map['totalAmountWithAddon_Normal'] != null
          ? map['totalAmountWithAddon_Normal'] as String
          : null,
      totalDiscount:
          map['totalDiscount'] != null ? map['totalDiscount'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartAmountDetailsDisplayDataModel.fromJson(String source) =>
      CartAmountDetailsDisplayDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartAmountDetailsDisplayDataModel(totalAmountWithAddon: $totalAmountWithAddon, totalAmountWithAddonNormal: $totalAmountWithAddonNormal, totalDiscount: $totalDiscount)';

  @override
  bool operator ==(covariant CartAmountDetailsDisplayDataModel other) {
    if (identical(this, other)) return true;

    return other.totalAmountWithAddon == totalAmountWithAddon &&
        other.totalAmountWithAddonNormal == totalAmountWithAddonNormal &&
        other.totalDiscount == totalDiscount;
  }

  @override
  int get hashCode =>
      totalAmountWithAddon.hashCode ^
      totalAmountWithAddonNormal.hashCode ^
      totalDiscount.hashCode;
}

class CartAmountItemDetailsDataModel {
  final int? amount;
  final int? totalAmount;
  final int? amountNormal;
  final int? totalAmountNormal;
  final int? discount;
  final int? totalDiscount;
  final CartAmountItemDetailsDisplayDataModel? display;

  CartAmountItemDetailsDataModel({
    this.amount,
    this.totalAmount,
    this.amountNormal,
    this.totalAmountNormal,
    this.discount,
    this.totalDiscount,
    this.display,
  });

  CartAmountItemDetailsDataModel copyWith({
    int? amount,
    int? totalAmount,
    int? amountNormal,
    int? totalAmountNormal,
    int? discount,
    int? totalDiscount,
    CartAmountItemDetailsDisplayDataModel? display,
  }) {
    return CartAmountItemDetailsDataModel(
      amount: amount ?? this.amount,
      totalAmount: totalAmount ?? this.totalAmount,
      amountNormal: amountNormal ?? this.amountNormal,
      totalAmountNormal: totalAmountNormal ?? this.totalAmountNormal,
      discount: discount ?? this.discount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      display: display ?? this.display,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'totalAmount': totalAmount,
      'amount_normal': amountNormal,
      'totalAmount_normal': totalAmountNormal,
      'discount': discount,
      'totalDiscount': totalDiscount,
      'display': display?.toMap(),
    };
  }

  factory CartAmountItemDetailsDataModel.fromMap(Map<String, dynamic> map) {
    return CartAmountItemDetailsDataModel(
      amount: map['amount'] != null ? map['amount'] as int : null,
      totalAmount:
          map['totalAmount'] != null ? map['totalAmount'] as int : null,
      amountNormal:
          map['amount_normal'] != null ? map['amount_normal'] as int : null,
      totalAmountNormal: map['totalAmount_normal'] != null
          ? map['totalAmount_normal'] as int
          : null,
      discount: map['discount'] != null ? map['discount'] as int : null,
      totalDiscount:
          map['totalDiscount'] != null ? map['totalDiscount'] as int : null,
      display: map['display'] != null
          ? CartAmountItemDetailsDisplayDataModel.fromMap(
              map['display'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartAmountItemDetailsDataModel.fromJson(String source) =>
      CartAmountItemDetailsDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartAmountItemDetailsDataModel(amount: $amount, totalAmount: $totalAmount, amountNormal: $amountNormal, totalAmountNormal: $totalAmountNormal, discount: $discount, totalDiscount: $totalDiscount, display: $display)';

  @override
  bool operator ==(covariant CartAmountItemDetailsDataModel other) {
    if (identical(this, other)) return true;

    return other.amount == amount &&
        other.totalAmount == totalAmount &&
        other.amountNormal == amountNormal &&
        other.totalAmountNormal == totalAmountNormal &&
        other.discount == discount &&
        other.totalDiscount == totalDiscount &&
        other.display == display;
  }

  @override
  int get hashCode =>
      amount.hashCode ^
      totalAmount.hashCode ^
      amountNormal.hashCode ^
      totalAmountNormal.hashCode ^
      discount.hashCode ^
      totalDiscount.hashCode ^
      display.hashCode;
}

class CartAmountItemDetailsDisplayDataModel {
  final String? amount;
  final String? totalAmount;
  final String? amountNormal;
  final String? totalAmountNormal;
  final String? discount;
  final String? totalDiscount;
  final String? totalAmountWithAddon;

  CartAmountItemDetailsDisplayDataModel({
    this.amount,
    this.totalAmount,
    this.amountNormal,
    this.totalAmountNormal,
    this.discount,
    this.totalDiscount,
    this.totalAmountWithAddon,
  });

  CartAmountItemDetailsDisplayDataModel copyWith({
    String? amount,
    String? totalAmount,
    String? amountNormal,
    String? totalAmountNormal,
    String? discount,
    String? totalDiscount,
    String? totalAmountWithAddon,
  }) {
    return CartAmountItemDetailsDisplayDataModel(
        amount: amount ?? this.amount,
        totalAmount: totalAmount ?? this.totalAmount,
        amountNormal: amountNormal ?? this.amountNormal,
        totalAmountNormal: totalAmountNormal ?? this.totalAmountNormal,
        discount: discount ?? this.discount,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        totalAmountWithAddon:
            totalAmountWithAddon ?? this.totalAmountWithAddon);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'totalAmount': totalAmount,
      'amount_normal': amountNormal,
      'totalAmount_normal': totalAmountNormal,
      'discount': discount,
      'totalDiscount': totalDiscount,
      'totalAmountWithAddon': totalAmountWithAddon,
    };
  }

  factory CartAmountItemDetailsDisplayDataModel.fromMap(
      Map<String, dynamic> map) {
    return CartAmountItemDetailsDisplayDataModel(
      amount: map['amount'] != null ? map['amount'] as String : null,
      totalAmount:
          map['totalAmount'] != null ? map['totalAmount'] as String : null,
      amountNormal:
          map['amount_normal'] != null ? map['amount_normal'] as String : null,
      totalAmountNormal: map['totalAmount_normal'] != null
          ? map['totalAmount_normal'] as String
          : null,
      discount: map['discount'] != null ? map['discount'] as String : null,
      totalDiscount:
          map['totalDiscount'] != null ? map['totalDiscount'] as String : null,
      totalAmountWithAddon: map['discoutotalAmountWithAddonnt'] != null
          ? map['totalAmountWithAddon'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartAmountItemDetailsDisplayDataModel.fromJson(String source) =>
      CartAmountItemDetailsDisplayDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartAmountItemDetailsDisplayDataModel(amount: $amount, totalAmount: $totalAmount, amountNormal: $amountNormal, totalAmountNormal: $totalAmountNormal, discount: $discount, totalDiscount: $totalDiscount,totalAmountWithAddon : $totalAmountWithAddon)';

  @override
  bool operator ==(covariant CartAmountItemDetailsDisplayDataModel other) {
    if (identical(this, other)) return true;

    return other.amount == amount &&
        other.totalAmount == totalAmount &&
        other.amountNormal == amountNormal &&
        other.totalAmountNormal == totalAmountNormal &&
        other.discount == discount &&
        other.totalAmountWithAddon == totalAmountWithAddon &&
        other.totalDiscount == totalDiscount;
  }

  @override
  int get hashCode =>
      amount.hashCode ^
      totalAmount.hashCode ^
      amountNormal.hashCode ^
      totalAmountNormal.hashCode ^
      discount.hashCode ^
      totalAmountWithAddon.hashCode ^
      totalDiscount.hashCode;
}

class CartAmountTaxConfigDataModel {
  final String? appliedSlab;
  final String? appliedSlabLabel;
  CartAmountTaxConfigDataModel({
    this.appliedSlab,
    this.appliedSlabLabel,
  });

  CartAmountTaxConfigDataModel copyWith({
    String? appliedSlab,
    String? appliedSlabLabel,
  }) {
    return CartAmountTaxConfigDataModel(
      appliedSlab: appliedSlab ?? this.appliedSlab,
      appliedSlabLabel: appliedSlabLabel ?? this.appliedSlabLabel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appliedSlab': appliedSlab,
      'appliedSlabLabel': appliedSlabLabel,
    };
  }

  factory CartAmountTaxConfigDataModel.fromMap(Map<String, dynamic> map) {
    return CartAmountTaxConfigDataModel(
      appliedSlab:
          map['appliedSlab'] != null ? map['appliedSlab'] as String : null,
      appliedSlabLabel: map['appliedSlabLabel'] != null
          ? map['appliedSlabLabel'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartAmountTaxConfigDataModel.fromJson(String source) =>
      CartAmountTaxConfigDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartAmountTaxConfigDataModel(appliedSlab: $appliedSlab, appliedSlabLabel: $appliedSlabLabel)';

  @override
  bool operator ==(covariant CartAmountTaxConfigDataModel other) {
    if (identical(this, other)) return true;

    return other.appliedSlab == appliedSlab &&
        other.appliedSlabLabel == appliedSlabLabel;
  }

  @override
  int get hashCode => appliedSlab.hashCode ^ appliedSlabLabel.hashCode;
}
