// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:customer_core/src/domain/cart/models/cart_details_model.dart';

class CalculatedDeliveryChargeDetailsModel {
  final String? message;
  final String? status;
  final String? userType;
  final String? cartGrossAmount;
  final String? cartDiscountAmount;
  final String? cartTotalAmount;
  final String? deliveryDiscount;
  final String? cartNetAmount_ExcludingTax;
  final String? taxTotalAmount;
  final String? cart_NetAmount;
  final String? deliveryFeeAmount;
  final String? cart_NetAmount_IncludingDelivery;
  final String? totalDiscount;
  final String? minimumAmountForDelivery;
  final String? minimumAmountType;
  final String? isTaxApplied;

  final DeliveryFeeGeneralData? generalData;
  final DeliveryFeeDeliverySettings? calculatedDeliverySettings;
  final DeliveryFeeAmountInPaisa? amountInPaisa;
  final DeliveryFeeAmountFormatted? amountFormatted;
  final List<DeliveryFeeTaxDetailsGroup> taxDetailsGroup;
  final CartDetailsModel? cartData;

  

  CalculatedDeliveryChargeDetailsModel({
    this.message,
    this.status,
    this.userType,
    this.cart_NetAmount,
    this.deliveryFeeAmount,
    this.generalData,
    this.calculatedDeliverySettings,
    this.cartGrossAmount,
    this.cartDiscountAmount,
    this.cartTotalAmount,
    this.deliveryDiscount,
    this.cartNetAmount_ExcludingTax,
    this.taxTotalAmount,
    this.cart_NetAmount_IncludingDelivery,
    this.totalDiscount,
    this.minimumAmountForDelivery,
    this.minimumAmountType,
    this.isTaxApplied,
    this.amountInPaisa,
    this.amountFormatted,
    this.taxDetailsGroup = const [],
    this.cartData,

  });

  CalculatedDeliveryChargeDetailsModel copyWith({
    String? message,
    String? status,
    String? userType,
    String? cart_NetAmount,
    String? deliveryFeeAmount,
    String? isTaxApplied,
    String? minimumAmountForDelivery,
    String? minimumAmountType,
    String? totalDiscount,
    String? cart_NetAmount_IncludingDelivery,
    String? taxTotalAmount,
    String? cartNetAmount_ExcludingTax,
    String? deliveryDiscount,
    String? cartTotalAmount,
    String? cartDiscountAmount,
    String? cartGrossAmount,
    DeliveryFeeGeneralData? generalData,
    DeliveryFeeDeliverySettings? calculatedDeliverySettings,
    DeliveryFeeAmountInPaisa? amountInPaisa,
      DeliveryFeeAmountFormatted? amountFormatted,
      List<DeliveryFeeTaxDetailsGroup>? taxDetailsGroup,
      CartDetailsModel? cartData,
  }) {
    return CalculatedDeliveryChargeDetailsModel(
      message: message ?? this.message,
      status: status ?? this.status,
      userType: userType ?? this.userType,
      cartDiscountAmount: cartDiscountAmount ?? this.cartDiscountAmount,
      cartGrossAmount: cartGrossAmount ?? this.cartGrossAmount,
      cartTotalAmount: cartTotalAmount ?? this.cartTotalAmount,
      deliveryDiscount: deliveryDiscount ?? this.deliveryDiscount,
      cartNetAmount_ExcludingTax:
          cartNetAmount_ExcludingTax ?? this.cartNetAmount_ExcludingTax,
      taxTotalAmount: taxTotalAmount ?? this.taxTotalAmount,
      cart_NetAmount_IncludingDelivery:
          cart_NetAmount_IncludingDelivery ?? this.cart_NetAmount_IncludingDelivery,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      minimumAmountForDelivery: minimumAmountForDelivery ?? this.minimumAmountForDelivery,
      minimumAmountType: minimumAmountType ?? this.minimumAmountType,
      isTaxApplied: isTaxApplied ?? this.isTaxApplied,
      cart_NetAmount: cart_NetAmount ?? this.cart_NetAmount,
      deliveryFeeAmount: deliveryFeeAmount ?? this.deliveryFeeAmount,
      generalData: generalData ?? this.generalData,
      calculatedDeliverySettings:
          calculatedDeliverySettings ?? this.calculatedDeliverySettings,
          amountInPaisa: amountInPaisa ?? this.amountInPaisa,
          amountFormatted: amountFormatted ?? this.amountFormatted,
          taxDetailsGroup: taxDetailsGroup ?? this.taxDetailsGroup,
          cartData: cartData ?? this.cartData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
     
      'message': message,
      'status': status,
      'userType': userType,
      'cartGrossAmount': cartGrossAmount,
      'cartDiscountAmount': cartDiscountAmount,
      'cartTotalAmount': cartTotalAmount,
      'deliveryDiscount': deliveryDiscount,
      'cartNetAmount_ExcludingTax': cartNetAmount_ExcludingTax,
      'taxTotalAmount': taxTotalAmount,
      'cart_NetAmount_IncludingDelivery': cart_NetAmount_IncludingDelivery,
      'totalDiscount': totalDiscount,
      'minimumAmountForDelivery': minimumAmountForDelivery,
      'minimumAmountType': minimumAmountType,
      'isTaxApplied': isTaxApplied,
      'cart_NetAmount': cart_NetAmount,
      'deliveryFeeAmount': deliveryFeeAmount,
      'generalData': generalData?.toMap(),
      'calculatedDeliverySettings': calculatedDeliverySettings?.toMap(),
      'amountInPaisa': amountInPaisa?.toMap(),
      'amountFormatted': amountFormatted?.toMap(),
      'taxDetailsGroup': taxDetailsGroup,
        'cartData': cartData?.toMap(),
    };
  }

  factory CalculatedDeliveryChargeDetailsModel.fromMap(
      Map<String, dynamic> map) {
    return CalculatedDeliveryChargeDetailsModel(
      message: map['message'] != null ? map['message'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      userType: map['userType'] != null ? map['userType'] as String : null,
      cartGrossAmount: map['cartGrossAmount'] != null
          ? map['cartGrossAmount'] as String
          : null,
      cartDiscountAmount: map['cartDiscountAmount'] != null
          ? map['cartDiscountAmount'] as String
          : null,
      cartTotalAmount: map['cartTotalAmount'] != null
          ? map['cartTotalAmount'] as String
          : null,
      deliveryDiscount: map['deliveryDiscount'] != null
          ? map['deliveryDiscount'] as String
          : null,
      cartNetAmount_ExcludingTax: map['cartNetAmount_ExcludingTax'] != null
          ? map['cartNetAmount_ExcludingTax'] as String
          : null,
      taxTotalAmount: map['taxTotalAmount'] != null
          ? map['taxTotalAmount'] as String
          : null,
      cart_NetAmount_IncludingDelivery: map['cart_NetAmount_IncludingDelivery'] != null
          ? map['cart_NetAmount_IncludingDelivery'] as String
          : null,
      totalDiscount: map['totalDiscount'] != null
          ? map['totalDiscount'] as String
          : null,
      minimumAmountForDelivery: map['minimumAmountForDelivery'] != null
          ? map['minimumAmountForDelivery'] as String
          : null,
      minimumAmountType: map['minimumAmountType'] != null
          ? map['minimumAmountType'] as String
          : null,
      isTaxApplied: map['isTaxApplied'] != null
          ? map['isTaxApplied'] as String
          : null,
      cart_NetAmount: map['cart_NetAmount'] != null
          ? map['cart_NetAmount'] as String
          : null,
      deliveryFeeAmount: map['deliveryFeeAmount'] != null
          ? map['deliveryFeeAmount'] as String
          : null,
      generalData: map['generalData'] != null
          ? DeliveryFeeGeneralData.fromMap(
              map['generalData'] as Map<String, dynamic>)
          : null,
      calculatedDeliverySettings: map['calculatedDeliverySettings'] != null
          ? DeliveryFeeDeliverySettings.fromMap(
              map['calculatedDeliverySettings'] as Map<String, dynamic>)
          : null,
      amountInPaisa: map['amountInPaisa'] != null
          ? DeliveryFeeAmountInPaisa.fromMap(
              map['amountInPaisa'] as Map<String, dynamic>)
          : null,
      amountFormatted: map['amountFormatted'] != null
          ? DeliveryFeeAmountFormatted.fromMap(
              map['amountFormatted'] as Map<String, dynamic>)
          : null,
      taxDetailsGroup: (map['taxDetailsGroup'] as List<dynamic>?)
              ?.map((e) => DeliveryFeeTaxDetailsGroup.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      cartData: map['cartData'] != null
          ? CartDetailsModel.fromMap(map['cartData'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalculatedDeliveryChargeDetailsModel.fromJson(String source) =>
      CalculatedDeliveryChargeDetailsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CalculatedDeliveryChargeDetailsModel(message: $message, status: $status, userType: $userType, cart_NetAmount: $cart_NetAmount, deliveryFeeAmount: $deliveryFeeAmount, generalData: $generalData, calculatedDeliverySettings: $calculatedDeliverySettings, cartGrossAmount: $cartGrossAmount, cartDiscountAmount: $cartDiscountAmount, cartTotalAmount: $cartTotalAmount, deliveryDiscount: $deliveryDiscount, cartNetAmount_ExcludingTax: $cartNetAmount_ExcludingTax, taxTotalAmount: $taxTotalAmount, cart_NetAmount_IncludingDelivery: $cart_NetAmount_IncludingDelivery, totalDiscount: $totalDiscount, minimumAmountForDelivery: $minimumAmountForDelivery, minimumAmountType: $minimumAmountType, isTaxApplied: $isTaxApplied, amountInPaisa: $amountInPaisa, amountFormatted: $amountFormatted, taxDetailsGroup: $taxDetailsGroup, cartData: $cartData)';
  }

  @override
  bool operator ==(covariant CalculatedDeliveryChargeDetailsModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        other.userType == userType &&
        other.cartDiscountAmount == cartDiscountAmount &&
        other.cartTotalAmount == cartTotalAmount &&
        other.deliveryDiscount == deliveryDiscount &&
        other.cartNetAmount_ExcludingTax == cartNetAmount_ExcludingTax &&
        other.taxTotalAmount == taxTotalAmount &&
        other.cart_NetAmount_IncludingDelivery == cart_NetAmount_IncludingDelivery &&
        other.totalDiscount == totalDiscount &&
        other.minimumAmountForDelivery == minimumAmountForDelivery &&
        other.minimumAmountType == minimumAmountType &&
        other.isTaxApplied == isTaxApplied &&
        other.cart_NetAmount == cart_NetAmount &&
        other.deliveryFeeAmount == deliveryFeeAmount &&
        other.generalData == generalData &&
        other.calculatedDeliverySettings == calculatedDeliverySettings &&
        other.amountInPaisa == amountInPaisa &&
        other.amountFormatted == amountFormatted &&
        other.taxDetailsGroup == taxDetailsGroup &&
        other.cartData == cartData;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status.hashCode ^
        userType.hashCode ^
        cartDiscountAmount.hashCode ^
        cartTotalAmount.hashCode ^
        deliveryDiscount.hashCode ^
        cartNetAmount_ExcludingTax.hashCode ^
        taxTotalAmount.hashCode ^
        cart_NetAmount_IncludingDelivery.hashCode ^
        totalDiscount.hashCode ^
        minimumAmountForDelivery.hashCode ^
        minimumAmountType.hashCode ^
        isTaxApplied.hashCode ^
        cart_NetAmount.hashCode ^
        deliveryFeeAmount.hashCode ^
        generalData.hashCode ^
        calculatedDeliverySettings.hashCode ^
        amountInPaisa.hashCode ^
        amountFormatted.hashCode ^
        taxDetailsGroup.hashCode ^
        cartData.hashCode;
  }
}

class DeliveryFeeGeneralData {
  final String? shopID;
  final String? shopName;
  final String? sourcePostCode;
  final String? destinationPostCode;
  final String? distance;
  final int? calibratedDistance;
  final String? duration;
  final int? cartItemsCount;
  final double? discountPercentage;

  DeliveryFeeGeneralData({
    this.shopID,
    this.shopName,
    this.sourcePostCode,
    this.destinationPostCode,
    this.distance,
    this.calibratedDistance,
    this.duration,
    this.cartItemsCount,
    this.discountPercentage,
  });

  DeliveryFeeGeneralData copyWith({
    String? shopID,
    String? shopName,
    String? sourcePostCode,
    String? destinationPostCode,
    String? distance,
    int? calibratedDistance,
    String? duration,
    int? cartItemsCount,
    double? discountPercentage,
  }) {
    return DeliveryFeeGeneralData(
      shopID: shopID ?? this.shopID,
      shopName: shopName ?? this.shopName,
      sourcePostCode: sourcePostCode ?? this.sourcePostCode,
      destinationPostCode: destinationPostCode ?? this.destinationPostCode,
      distance: distance ?? this.distance,
      calibratedDistance: calibratedDistance ?? this.calibratedDistance,
      duration: duration ?? this.duration,
      cartItemsCount: cartItemsCount ?? this.cartItemsCount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shopID': shopID,
      'shopName': shopName,
      'sourcePostCode': sourcePostCode,
      'destinationPostCode': destinationPostCode,
      'distance': distance,
      'calibratedDistance': calibratedDistance,
      'duration': duration,
      'cartItemsCount': cartItemsCount,
      'discountPercentage': discountPercentage,
    };
  }

  factory DeliveryFeeGeneralData.fromMap(Map<String, dynamic> map) {
    return DeliveryFeeGeneralData(
      shopID: map['shopID'] != null ? map['shopID'] as String : null,
      shopName: map['shopName'] != null ? map['shopName'] as String : null,
      sourcePostCode: map['sourcePostCode'] != null
          ? map['sourcePostCode'] as String
          : null,
      destinationPostCode: map['destinationPostCode'] != null
          ? map['destinationPostCode'] as String
          : null,
      distance: map['distance'] != null ? map['distance'] as String : null,
      calibratedDistance: map['calibratedDistance'] != null
          ? map['calibratedDistance'] as int
          : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      cartItemsCount:
          map['cartItemsCount'] != null ? map['cartItemsCount'] as int : null,
      discountPercentage: map['discountPercentage'] != null
          ? map['discountPercentage'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryFeeGeneralData.fromJson(String source) =>
      DeliveryFeeGeneralData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CalculateDeliveryFeeGeneralDataModel(shopID: $shopID, shopName: $shopName, sourcePostCode: $sourcePostCode, destinationPostCode: $destinationPostCode, distance: $distance, calibratedDistance: $calibratedDistance, duration: $duration, cartItemsCount: $cartItemsCount, discountPercentage: $discountPercentage)';
  }

  @override
  bool operator ==(covariant DeliveryFeeGeneralData other) {
    if (identical(this, other)) return true;

    return other.shopID == shopID &&
        other.shopName == shopName &&
        other.sourcePostCode == sourcePostCode &&
        other.destinationPostCode == destinationPostCode &&
        other.distance == distance &&
        other.calibratedDistance == calibratedDistance &&
        other.duration == duration &&
        other.cartItemsCount == cartItemsCount &&
        other.discountPercentage == discountPercentage;
  }

  @override
  int get hashCode {
    return shopID.hashCode ^
        shopName.hashCode ^
        sourcePostCode.hashCode ^
        destinationPostCode.hashCode ^
        distance.hashCode ^
        calibratedDistance.hashCode ^
        duration.hashCode ^
        cartItemsCount.hashCode ^
        discountPercentage.hashCode;
  }
}

class DeliveryFeeDeliverySettings {
  final String? fixedDeliveryCharges;
  final String? freeDelivery;
  final int? calibratedDistance;
  final int? freeDeliveryRadius;
  final double? maxDeliveryRadius;
  final int? ratePerMile;
  final String? deliveryChargeType;
  final int? freeDeliveryMinOrder;
  final String? calculateNormalDeliveryFee;

  DeliveryFeeDeliverySettings({
    this.fixedDeliveryCharges,
    this.freeDelivery,
    this.calibratedDistance,
    this.freeDeliveryRadius,
    this.maxDeliveryRadius,
    this.ratePerMile,
    this.deliveryChargeType,
    this.freeDeliveryMinOrder,
    this.calculateNormalDeliveryFee,
  });

  DeliveryFeeDeliverySettings copyWith({
    String? fixedDeliveryCharges,
    String? freeDelivery,
    int? calibratedDistance,
    int? freeDeliveryRadius,
    double? maxDeliveryRadius,
    int? ratePerMile,
    String? deliveryChargeType,
    int? freeDeliveryMinOrder,
    String? calculateNormalDeliveryFee,
  }) {
    return DeliveryFeeDeliverySettings(
      fixedDeliveryCharges: fixedDeliveryCharges ?? this.fixedDeliveryCharges,
      freeDelivery: freeDelivery ?? this.freeDelivery,
      calibratedDistance: calibratedDistance ?? this.calibratedDistance,
      freeDeliveryRadius: freeDeliveryRadius ?? this.freeDeliveryRadius,
      maxDeliveryRadius: maxDeliveryRadius ?? this.maxDeliveryRadius,
      ratePerMile: ratePerMile ?? this.ratePerMile,
      deliveryChargeType: deliveryChargeType ?? this.deliveryChargeType,
      freeDeliveryMinOrder: freeDeliveryMinOrder ?? this.freeDeliveryMinOrder,
      calculateNormalDeliveryFee:
          calculateNormalDeliveryFee ?? this.calculateNormalDeliveryFee,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fixedDeliveryCharges': fixedDeliveryCharges,
      'freeDelivery': freeDelivery,
      'calibratedDistance': calibratedDistance,
      'freeDeliveryRadius': freeDeliveryRadius,
      'maxDeliveryRadius': maxDeliveryRadius,
      'ratePerMile': ratePerMile,
      'deliveryChargeType': deliveryChargeType,
      'freeDeliveryMinOrder': freeDeliveryMinOrder,
      'calculateNormalDeliveryFee': calculateNormalDeliveryFee,
    };
  }

  factory DeliveryFeeDeliverySettings.fromMap(Map<String, dynamic> map) {
    return DeliveryFeeDeliverySettings(
      fixedDeliveryCharges: map['fixedDeliveryCharges'] != null
          ? map['fixedDeliveryCharges'] as String
          : null,
      freeDelivery:
          map['freeDelivery'] != null ? map['freeDelivery'] as String : null,
      calibratedDistance: map['calibratedDistance'] != null
          ? map['calibratedDistance'] as int
          : null,
      freeDeliveryRadius: map['freeDeliveryRadius'] != null
          ? map['freeDeliveryRadius'] as int
          : null,
      maxDeliveryRadius: map['maxDeliveryRadius'] != null
          ? map["maxDeliveryRadius"] is int
              ? (map["maxDeliveryRadius"] as int).toDouble()
              : map["maxDeliveryRadius"]
          : null,
      ratePerMile:
          map['ratePerMile'] != null ? map['ratePerMile'] as int : null,
      deliveryChargeType: map['deliveryChargeType'] != null
          ? map['deliveryChargeType'] as String
          : null,
      freeDeliveryMinOrder: map['freeDeliveryMinOrder'] != null
          ? map['freeDeliveryMinOrder'] as int
          : null,
      calculateNormalDeliveryFee: map['calculateNormalDeliveryFee'] != null
          ? map['calculateNormalDeliveryFee'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryFeeDeliverySettings.fromJson(String source) =>
      DeliveryFeeDeliverySettings.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CalculateDeliveryFeeDeliverySettingsDataModel(fixedDeliveryCharges: $fixedDeliveryCharges, freeDelivery: $freeDelivery, calibratedDistance: $calibratedDistance, freeDeliveryRadius: $freeDeliveryRadius, maxDeliveryRadius: $maxDeliveryRadius, ratePerMile: $ratePerMile, deliveryChargeType: $deliveryChargeType, freeDeliveryMinOrder: $freeDeliveryMinOrder, calculateNormalDeliveryFee: $calculateNormalDeliveryFee)';
  }

  @override
  bool operator ==(covariant DeliveryFeeDeliverySettings other) {
    if (identical(this, other)) return true;

    return other.fixedDeliveryCharges == fixedDeliveryCharges &&
        other.freeDelivery == freeDelivery &&
        other.calibratedDistance == calibratedDistance &&
        other.freeDeliveryRadius == freeDeliveryRadius &&
        other.maxDeliveryRadius == maxDeliveryRadius &&
        other.ratePerMile == ratePerMile &&
        other.deliveryChargeType == deliveryChargeType &&
        other.freeDeliveryMinOrder == freeDeliveryMinOrder &&
        other.calculateNormalDeliveryFee == calculateNormalDeliveryFee;
  }

  @override
  int get hashCode {
    return fixedDeliveryCharges.hashCode ^
        freeDelivery.hashCode ^
        calibratedDistance.hashCode ^
        freeDeliveryRadius.hashCode ^
        maxDeliveryRadius.hashCode ^
        ratePerMile.hashCode ^
        deliveryChargeType.hashCode ^
        freeDeliveryMinOrder.hashCode ^
        calculateNormalDeliveryFee.hashCode;
  }
}

class DeliveryFeeAmountInPaisa {
   

final int? cartGrossAmount;
  final int? cartDiscountAmount;
  final int? cartTotalAmount;
  final int? deliveryDiscount;
  final int? cartNetAmount_ExcludingTax;
  final int? taxTotalAmount;
  final int? cart_NetAmount;
  final int? deliveryFeeAmount;
  final int? cart_NetAmount_IncludingDelivery;
  final int? totalDiscount;
  DeliveryFeeAmountInPaisa({
    this.cartGrossAmount,
    this.cartDiscountAmount,
    this.cartTotalAmount,
    this.deliveryDiscount,
    this.cartNetAmount_ExcludingTax,
    this.taxTotalAmount,
    this.cart_NetAmount,
    this.deliveryFeeAmount,
    this.cart_NetAmount_IncludingDelivery,
    this.totalDiscount,
  });



  DeliveryFeeAmountInPaisa copyWith({
    int? cartGrossAmount,
    int? cartDiscountAmount,
    int? cartTotalAmount,
    int? deliveryDiscount,
    int? cartNetAmount_ExcludingTax,
    int? taxTotalAmount,
    int? cart_NetAmount,
    int? deliveryFeeAmount,
    int? cart_NetAmount_IncludingDelivery,
    int? totalDiscount,
  }) {
    return DeliveryFeeAmountInPaisa(
      cartGrossAmount: cartGrossAmount ?? this.cartGrossAmount,
      cartDiscountAmount: cartDiscountAmount ?? this.cartDiscountAmount,
      cartTotalAmount: cartTotalAmount ?? this.cartTotalAmount,
      deliveryDiscount: deliveryDiscount ?? this.deliveryDiscount,
      cartNetAmount_ExcludingTax: cartNetAmount_ExcludingTax ?? this.cartNetAmount_ExcludingTax,
      taxTotalAmount: taxTotalAmount ?? this.taxTotalAmount,
      cart_NetAmount: cart_NetAmount ?? this.cart_NetAmount,
      deliveryFeeAmount: deliveryFeeAmount ?? this.deliveryFeeAmount,
      cart_NetAmount_IncludingDelivery: cart_NetAmount_IncludingDelivery ?? this.cart_NetAmount_IncludingDelivery,
      totalDiscount: totalDiscount ?? this.totalDiscount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartGrossAmount': cartGrossAmount,
      'cartDiscountAmount': cartDiscountAmount,
      'cartTotalAmount': cartTotalAmount,
      'deliveryDiscount': deliveryDiscount,
      'cartNetAmount_ExcludingTax': cartNetAmount_ExcludingTax,
      'taxTotalAmount': taxTotalAmount,
      'cart_NetAmount': cart_NetAmount,
      'deliveryFeeAmount': deliveryFeeAmount,
      'cart_NetAmount_IncludingDelivery': cart_NetAmount_IncludingDelivery,
      'totalDiscount': totalDiscount,
    };
  }

  factory DeliveryFeeAmountInPaisa.fromMap(Map<String, dynamic> map) {
    return DeliveryFeeAmountInPaisa(
      cartGrossAmount: map['cartGrossAmount'] != null ? map['cartGrossAmount'] as int : null,
      cartDiscountAmount: map['cartDiscountAmount'] != null ? map['cartDiscountAmount'] as int : null,
      cartTotalAmount: map['cartTotalAmount'] != null ? map['cartTotalAmount'] as int : null,
      deliveryDiscount: map['deliveryDiscount'] != null ? map['deliveryDiscount'] as int : null,
      cartNetAmount_ExcludingTax: map['cartNetAmount_ExcludingTax'] != null ? map['cartNetAmount_ExcludingTax'] as int : null,
      taxTotalAmount: map['taxTotalAmount'] != null ? map['taxTotalAmount'] as int : null,
      cart_NetAmount: map['cart_NetAmount'] != null ? map['cart_NetAmount'] as int : null,
      deliveryFeeAmount: map['deliveryFeeAmount'] != null ? map['deliveryFeeAmount'] as int : null,
      cart_NetAmount_IncludingDelivery: map['cart_NetAmount_IncludingDelivery'] != null ? map['cart_NetAmount_IncludingDelivery'] as int : null,
      totalDiscount: map['totalDiscount'] != null ? map['totalDiscount'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryFeeAmountInPaisa.fromJson(String source) => DeliveryFeeAmountInPaisa.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryFeeAmountInPaisa(cartGrossAmount: $cartGrossAmount, cartDiscountAmount: $cartDiscountAmount, cartTotalAmount: $cartTotalAmount, deliveryDiscount: $deliveryDiscount, cartNetAmount_ExcludingTax: $cartNetAmount_ExcludingTax, taxTotalAmount: $taxTotalAmount, cart_NetAmount: $cart_NetAmount, deliveryFeeAmount: $deliveryFeeAmount, cart_NetAmount_IncludingDelivery: $cart_NetAmount_IncludingDelivery, totalDiscount: $totalDiscount)';
  }

  @override
  bool operator ==(covariant DeliveryFeeAmountInPaisa other) {
    if (identical(this, other)) return true;
  
    return 
      other.cartGrossAmount == cartGrossAmount &&
      other.cartDiscountAmount == cartDiscountAmount &&
      other.cartTotalAmount == cartTotalAmount &&
      other.deliveryDiscount == deliveryDiscount &&
      other.cartNetAmount_ExcludingTax == cartNetAmount_ExcludingTax &&
      other.taxTotalAmount == taxTotalAmount &&
      other.cart_NetAmount == cart_NetAmount &&
      other.deliveryFeeAmount == deliveryFeeAmount &&
      other.cart_NetAmount_IncludingDelivery == cart_NetAmount_IncludingDelivery &&
      other.totalDiscount == totalDiscount;
  }

  @override
  int get hashCode {
    return cartGrossAmount.hashCode ^
      cartDiscountAmount.hashCode ^
      cartTotalAmount.hashCode ^
      deliveryDiscount.hashCode ^
      cartNetAmount_ExcludingTax.hashCode ^
      taxTotalAmount.hashCode ^
      cart_NetAmount.hashCode ^
      deliveryFeeAmount.hashCode ^
      cart_NetAmount_IncludingDelivery.hashCode ^
      totalDiscount.hashCode;
  }
}

class DeliveryFeeAmountFormatted {
   

final String? cartGrossAmount;
  final String? cartDiscountAmount;
  final String? cartTotalAmount;
  final String? deliveryDiscount;
  final String? cartNetAmount_ExcludingTax;
  final String? taxTotalAmount;
  final String? cart_NetAmount;
  final String? deliveryFeeAmount;
  final String? cart_NetAmount_IncludingDelivery;
  final String? totalDiscount;
  DeliveryFeeAmountFormatted({
    this.cartGrossAmount,
    this.cartDiscountAmount,
    this.cartTotalAmount,
    this.deliveryDiscount,
    this.cartNetAmount_ExcludingTax,
    this.taxTotalAmount,
    this.cart_NetAmount,
    this.deliveryFeeAmount,
    this.cart_NetAmount_IncludingDelivery,
    this.totalDiscount,
  });

  DeliveryFeeAmountFormatted copyWith({
    String? cartGrossAmount,
    String? cartDiscountAmount,
    String? cartTotalAmount,
    String? deliveryDiscount,
    String? cartNetAmount_ExcludingTax,
    String? taxTotalAmount,
    String? cart_NetAmount,
    String? deliveryFeeAmount,
    String? cart_NetAmount_IncludingDelivery,
    String? totalDiscount,
  }) {
    return DeliveryFeeAmountFormatted(
      cartGrossAmount: cartGrossAmount ?? this.cartGrossAmount,
      cartDiscountAmount: cartDiscountAmount ?? this.cartDiscountAmount,
      cartTotalAmount: cartTotalAmount ?? this.cartTotalAmount,
      deliveryDiscount: deliveryDiscount ?? this.deliveryDiscount,
      cartNetAmount_ExcludingTax: cartNetAmount_ExcludingTax ?? this.cartNetAmount_ExcludingTax,
      taxTotalAmount: taxTotalAmount ?? this.taxTotalAmount,
      cart_NetAmount: cart_NetAmount ?? this.cart_NetAmount,
      deliveryFeeAmount: deliveryFeeAmount ?? this.deliveryFeeAmount,
      cart_NetAmount_IncludingDelivery: cart_NetAmount_IncludingDelivery ?? this.cart_NetAmount_IncludingDelivery,
      totalDiscount: totalDiscount ?? this.totalDiscount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartGrossAmount': cartGrossAmount,
      'cartDiscountAmount': cartDiscountAmount,
      'cartTotalAmount': cartTotalAmount,
      'deliveryDiscount': deliveryDiscount,
      'cartNetAmount_ExcludingTax': cartNetAmount_ExcludingTax,
      'taxTotalAmount': taxTotalAmount,
      'cart_NetAmount': cart_NetAmount,
      'deliveryFeeAmount': deliveryFeeAmount,
      'cart_NetAmount_IncludingDelivery': cart_NetAmount_IncludingDelivery,
      'totalDiscount': totalDiscount,
    };
  }

  factory DeliveryFeeAmountFormatted.fromMap(Map<String, dynamic> map) {
    return DeliveryFeeAmountFormatted(
      cartGrossAmount: map['cartGrossAmount'] != null ? map['cartGrossAmount'] as String : null,
      cartDiscountAmount: map['cartDiscountAmount'] != null ? map['cartDiscountAmount'] as String : null,
      cartTotalAmount: map['cartTotalAmount'] != null ? map['cartTotalAmount'] as String : null,
      deliveryDiscount: map['deliveryDiscount'] != null ? map['deliveryDiscount'] as String : null,
      cartNetAmount_ExcludingTax: map['cartNetAmount_ExcludingTax'] != null ? map['cartNetAmount_ExcludingTax'] as String : null,
      taxTotalAmount: map['taxTotalAmount'] != null ? map['taxTotalAmount'] as String : null,
      cart_NetAmount: map['cart_NetAmount'] != null ? map['cart_NetAmount'] as String : null,
      deliveryFeeAmount: map['deliveryFeeAmount'] != null ? map['deliveryFeeAmount'] as String : null,
      cart_NetAmount_IncludingDelivery: map['cart_NetAmount_IncludingDelivery'] != null ? map['cart_NetAmount_IncludingDelivery'] as String : null,
      totalDiscount: map['totalDiscount'] != null ? map['totalDiscount'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryFeeAmountFormatted.fromJson(String source) => DeliveryFeeAmountFormatted.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryFeeAmountFormatted(cartGrossAmount: $cartGrossAmount, cartDiscountAmount: $cartDiscountAmount, cartTotalAmount: $cartTotalAmount, deliveryDiscount: $deliveryDiscount, cartNetAmount_ExcludingTax: $cartNetAmount_ExcludingTax, taxTotalAmount: $taxTotalAmount, cart_NetAmount: $cart_NetAmount, deliveryFeeAmount: $deliveryFeeAmount, cart_NetAmount_IncludingDelivery: $cart_NetAmount_IncludingDelivery, totalDiscount: $totalDiscount)';
  }

  @override
  bool operator ==(covariant DeliveryFeeAmountFormatted other) {
    if (identical(this, other)) return true;
  
    return 
      other.cartGrossAmount == cartGrossAmount &&
      other.cartDiscountAmount == cartDiscountAmount &&
      other.cartTotalAmount == cartTotalAmount &&
      other.deliveryDiscount == deliveryDiscount &&
      other.cartNetAmount_ExcludingTax == cartNetAmount_ExcludingTax &&
      other.taxTotalAmount == taxTotalAmount &&
      other.cart_NetAmount == cart_NetAmount &&
      other.deliveryFeeAmount == deliveryFeeAmount &&
      other.cart_NetAmount_IncludingDelivery == cart_NetAmount_IncludingDelivery &&
      other.totalDiscount == totalDiscount;
  }

  @override
  int get hashCode {
    return cartGrossAmount.hashCode ^
      cartDiscountAmount.hashCode ^
      cartTotalAmount.hashCode ^
      deliveryDiscount.hashCode ^
      cartNetAmount_ExcludingTax.hashCode ^
      taxTotalAmount.hashCode ^
      cart_NetAmount.hashCode ^
      deliveryFeeAmount.hashCode ^
      cart_NetAmount_IncludingDelivery.hashCode ^
      totalDiscount.hashCode;
  }
}

class DeliveryFeeTaxDetailsGroup {
  final String? taxSlab;
  final String? totalTax;
  final int? totalTaxPaisa;
  DeliveryFeeTaxDetailsGroup({
    this.taxSlab,
    this.totalTax,
    this.totalTaxPaisa,
  });

  

  DeliveryFeeTaxDetailsGroup copyWith({
    String? taxSlab,
    String? totalTax,
    int? totalTaxPaisa,
  }) {
    return DeliveryFeeTaxDetailsGroup(
      taxSlab: taxSlab ?? this.taxSlab,
      totalTax: totalTax ?? this.totalTax,
      totalTaxPaisa: totalTaxPaisa ?? this.totalTaxPaisa,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taxSlab': taxSlab,
      'totalTax': totalTax,
      'totalTaxPaisa': totalTaxPaisa,
    };
  }

  factory DeliveryFeeTaxDetailsGroup.fromMap(Map<String, dynamic> map) {
    return DeliveryFeeTaxDetailsGroup(
      taxSlab: map['taxSlab'] != null ? map['taxSlab'] as String : null,
      totalTax: map['totalTax'] != null ? map['totalTax'] as String : null,
      totalTaxPaisa: map['totalTaxPaisa'] != null ? map['totalTaxPaisa'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryFeeTaxDetailsGroup.fromJson(String source) => DeliveryFeeTaxDetailsGroup.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DeliveryFeeTaxDetailsGroup(taxSlab: $taxSlab, totalTax: $totalTax, totalTaxPaisa: $totalTaxPaisa)';

  @override
  bool operator ==(covariant DeliveryFeeTaxDetailsGroup other) {
    if (identical(this, other)) return true;
  
    return 
      other.taxSlab == taxSlab &&
      other.totalTax == totalTax &&
      other.totalTaxPaisa == totalTaxPaisa;
  }

  @override
  int get hashCode => taxSlab.hashCode ^ totalTax.hashCode ^ totalTaxPaisa.hashCode;
}
