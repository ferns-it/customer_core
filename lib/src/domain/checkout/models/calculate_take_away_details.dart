// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:customer_core/src/domain/cart/models/cart_details_model.dart';
import 'package:customer_core/src/domain/checkout/models/calculated_delivery_charge_details_model.dart';

class CalculateTakeAwayDetails {

  final String? cartGrossAmount;
  final String? cartDiscountAmount;
  final String? cartTotalAmount;
  final String? takeAwayDiscount;
  final String? cartNetAmount_ExcludingTax;
  final String? taxTotalAmount;
  final String? cart_NetAmount;
  final String? totalDiscount;
  final String? userType;
  final String? message;
  final String? status;
  final String? isTaxApplied;
  final GeneralData? generalData;
  final CalculateTakeawayAmountInPaisa? amountInPaisa;
  final CalculateTakeawayAmountFormatted? amountFormatted;
  final List<DeliveryFeeTaxDetailsGroup> taxDetailsGroup;
  final CartDetailsModel? cartData;
  CalculateTakeAwayDetails({
    this.cartGrossAmount,
    this.cartDiscountAmount,
    this.cartTotalAmount,
    this.takeAwayDiscount,
    this.cartNetAmount_ExcludingTax,
    this.taxTotalAmount,
    this.cart_NetAmount,
    this.totalDiscount,
    this.userType,
    this.message,
    this.status,
    this.isTaxApplied,
    this.generalData,
    this.amountInPaisa,
    this.amountFormatted,
     this.taxDetailsGroup =const [],
    this.cartData,
  });



  

  CalculateTakeAwayDetails copyWith({
    String? cartGrossAmount,
    String? cartDiscountAmount,
    String? cartTotalAmount,
    String? takeAwayDiscount,
    String? cartNetAmount_ExcludingTax,
    String? taxTotalAmount,
    String? cart_NetAmount,
    String? totalDiscount,
    String? userType,
    String? message,
    String? status,
    String? isTaxApplied,
    GeneralData? generalData,
    CalculateTakeawayAmountInPaisa? amountInPaisa,
    CalculateTakeawayAmountFormatted? amountFormatted,
    List<DeliveryFeeTaxDetailsGroup>? taxDetailsGroup,
    CartDetailsModel? cartData,
  }) {
    return CalculateTakeAwayDetails(
      cartGrossAmount: cartGrossAmount ?? this.cartGrossAmount,
      cartDiscountAmount: cartDiscountAmount ?? this.cartDiscountAmount,
      cartTotalAmount: cartTotalAmount ?? this.cartTotalAmount,
      takeAwayDiscount: takeAwayDiscount ?? this.takeAwayDiscount,
      cartNetAmount_ExcludingTax: cartNetAmount_ExcludingTax ?? this.cartNetAmount_ExcludingTax,
      taxTotalAmount: taxTotalAmount ?? this.taxTotalAmount,
      cart_NetAmount: cart_NetAmount ?? this.cart_NetAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      userType: userType ?? this.userType,
      message: message ?? this.message,
      status: status ?? this.status,
      isTaxApplied: isTaxApplied ?? this.isTaxApplied,
      generalData: generalData ?? this.generalData,
      amountInPaisa: amountInPaisa ?? this.amountInPaisa,
      amountFormatted: amountFormatted ?? this.amountFormatted,
      taxDetailsGroup: taxDetailsGroup ?? this.taxDetailsGroup,
      cartData: cartData ?? this.cartData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartGrossAmount': cartGrossAmount,
      'cartDiscountAmount': cartDiscountAmount,
      'cartTotalAmount': cartTotalAmount,
      'takeAwayDiscount': takeAwayDiscount,
      'cartNetAmount_ExcludingTax': cartNetAmount_ExcludingTax,
      'taxTotalAmount': taxTotalAmount,
      'cart_NetAmount': cart_NetAmount,
      'totalDiscount': totalDiscount,
      'userType': userType,
      'message': message,
      'status': status,
      'isTaxApplied': isTaxApplied,
      'generalData': generalData?.toMap(),
      'amountInPaisa': amountInPaisa?.toMap(),
      'amountFormatted': amountFormatted?.toMap(),
      'taxDetailsGroup': taxDetailsGroup.map((x) => x.toMap()).toList(),
      'cartData': cartData?.toMap(),
    };
  }

  factory CalculateTakeAwayDetails.fromMap(Map<String, dynamic> map) {
    return CalculateTakeAwayDetails(
      cartGrossAmount: map['cartGrossAmount'] != null ? map['cartGrossAmount'] as String : null,
      cartDiscountAmount: map['cartDiscountAmount'] != null ? map['cartDiscountAmount'] as String : null,
      cartTotalAmount: map['cartTotalAmount'] != null ? map['cartTotalAmount'] as String : null,
      takeAwayDiscount: map['takeAwayDiscount'] != null ? map['takeAwayDiscount'] as String : null,
      cartNetAmount_ExcludingTax: map['cartNetAmount_ExcludingTax'] != null ? map['cartNetAmount_ExcludingTax'] as String : null,
      taxTotalAmount: map['taxTotalAmount'] != null ? map['taxTotalAmount'] as String : null,
      cart_NetAmount: map['cart_NetAmount'] != null ? map['cart_NetAmount'] as String : null,
      totalDiscount: map['totalDiscount'] != null ? map['totalDiscount'] as String : null,
      userType: map['userType'] != null ? map['userType'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      isTaxApplied: map['isTaxApplied'] != null ? map['isTaxApplied'] as String : null,
      generalData: map['generalData'] != null ? GeneralData.fromMap(map['generalData'] as Map<String,dynamic>) : null,
      amountInPaisa: map['amountInPaisa'] != null ? CalculateTakeawayAmountInPaisa.fromMap(map['amountInPaisa'] as Map<String,dynamic>) : null,
      amountFormatted: map['amountFormatted'] != null ? CalculateTakeawayAmountFormatted.fromMap(map['amountFormatted'] as Map<String,dynamic>) : null,
      taxDetailsGroup: List<DeliveryFeeTaxDetailsGroup>.from((map['taxDetailsGroup'] as List<dynamic>).map<DeliveryFeeTaxDetailsGroup>((x) => DeliveryFeeTaxDetailsGroup.fromMap(x as Map<String,dynamic>),),),
      cartData: map['cartData'] != null ? CartDetailsModel.fromMap(map['cartData'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalculateTakeAwayDetails.fromJson(String source) => CalculateTakeAwayDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CalculateTakeAwayDetails(cartGrossAmount: $cartGrossAmount, cartDiscountAmount: $cartDiscountAmount, cartTotalAmount: $cartTotalAmount, takeAwayDiscount: $takeAwayDiscount, cartNetAmount_ExcludingTax: $cartNetAmount_ExcludingTax, taxTotalAmount: $taxTotalAmount, cart_NetAmount: $cart_NetAmount, totalDiscount: $totalDiscount, userType: $userType, message: $message, status: $status, isTaxApplied: $isTaxApplied, generalData: $generalData, amountInPaisa: $amountInPaisa, amountFormatted: $amountFormatted, taxDetailsGroup: $taxDetailsGroup, cartData: $cartData)';
  }

  @override
  bool operator ==(covariant CalculateTakeAwayDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.cartGrossAmount == cartGrossAmount &&
      other.cartDiscountAmount == cartDiscountAmount &&
      other.cartTotalAmount == cartTotalAmount &&
      other.takeAwayDiscount == takeAwayDiscount &&
      other.cartNetAmount_ExcludingTax == cartNetAmount_ExcludingTax &&
      other.taxTotalAmount == taxTotalAmount &&
      other.cart_NetAmount == cart_NetAmount &&
      other.totalDiscount == totalDiscount &&
      other.userType == userType &&
      other.message == message &&
      other.status == status &&
      other.isTaxApplied == isTaxApplied &&
      other.generalData == generalData &&
      other.amountInPaisa == amountInPaisa &&
      other.amountFormatted == amountFormatted &&
      listEquals(other.taxDetailsGroup, taxDetailsGroup) &&
      other.cartData == cartData;
  }

  @override
  int get hashCode {
    return cartGrossAmount.hashCode ^
      cartDiscountAmount.hashCode ^
      cartTotalAmount.hashCode ^
      takeAwayDiscount.hashCode ^
      cartNetAmount_ExcludingTax.hashCode ^
      taxTotalAmount.hashCode ^
      cart_NetAmount.hashCode ^
      totalDiscount.hashCode ^
      userType.hashCode ^
      message.hashCode ^
      status.hashCode ^
      isTaxApplied.hashCode ^
      generalData.hashCode ^
      amountInPaisa.hashCode ^
      amountFormatted.hashCode ^
      taxDetailsGroup.hashCode ^
      cartData.hashCode;
  }
}

class GeneralData {
  GeneralData({
    required this.pickupTime,
    required this.takeAwayDiscountPercentage,
    required this.minimumAmtForTakeAwayDiscount,
    required this.shopName,
    required this.shopId,
    required this.takeAway,
    required this.takeAwayTempOff,
  });

  final PickupTime? pickupTime;
  final String? takeAwayDiscountPercentage;
  final String? minimumAmtForTakeAwayDiscount;
  final String? shopName;
  final String? shopId;
  final String? takeAway;
  final String? takeAwayTempOff;

  GeneralData copyWith({
    PickupTime? pickupTime,
    String? takeAwayDiscountPercentage,
    String? minimumAmtForTakeAwayDiscount,
    String? shopName,
    String? shopId,
    String? takeAway,
    String? takeAwayTempOff,
  }) {
    return GeneralData(
      pickupTime: pickupTime ?? this.pickupTime,
      takeAwayDiscountPercentage:
          takeAwayDiscountPercentage ?? this.takeAwayDiscountPercentage,
      minimumAmtForTakeAwayDiscount:
          minimumAmtForTakeAwayDiscount ?? this.minimumAmtForTakeAwayDiscount,
      shopName: shopName ?? this.shopName,
      shopId: shopId ?? this.shopId,
      takeAway: takeAway ?? this.takeAway,
      takeAwayTempOff: takeAwayTempOff ?? this.takeAwayTempOff,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pickupTime': pickupTime?.toMap(),
      'takeAwayDiscountPercentage': takeAwayDiscountPercentage,
      'minimumAmtForTakeAwayDiscount': minimumAmtForTakeAwayDiscount,
      'shopName': shopName,
      'shopId': shopId,
      'takeAway': takeAway,
      'takeAwayTempOff': takeAwayTempOff,
    };
  }

  factory GeneralData.fromMap(Map<String, dynamic> map) {
    return GeneralData(
      pickupTime: map['pickupTime'] != null
          ? PickupTime.fromMap(map['pickupTime'] as Map<String, dynamic>)
          : null,
      takeAwayDiscountPercentage: map['takeAwayDiscountPercentage'] != null
          ? map['takeAwayDiscountPercentage'] as String
          : null,
      minimumAmtForTakeAwayDiscount:
          map['minimumAmtForTakeAwayDiscount'] != null
              ? map['minimumAmtForTakeAwayDiscount'] as String
              : null,
      shopName: map['shopName'] != null ? map['shopName'] as String : null,
      shopId: map['shopId'] != null ? map['shopId'] as String : null,
      takeAway: map['takeAway'] != null ? map['takeAway'] as String : null,
      takeAwayTempOff: map['takeAwayTempOff'] != null
          ? map['takeAwayTempOff'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GeneralData.fromJson(String source) =>
      GeneralData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GeneralData(pickupTime: $pickupTime, takeAwayDiscountPercentage: $takeAwayDiscountPercentage, minimumAmtForTakeAwayDiscount: $minimumAmtForTakeAwayDiscount, shopName: $shopName, shopId: $shopId, takeAway: $takeAway, takeAwayTempOff: $takeAwayTempOff)';
  }

  @override
  bool operator ==(covariant GeneralData other) {
    if (identical(this, other)) return true;

    return other.pickupTime == pickupTime &&
        other.takeAwayDiscountPercentage == takeAwayDiscountPercentage &&
        other.minimumAmtForTakeAwayDiscount == minimumAmtForTakeAwayDiscount &&
        other.shopName == shopName &&
        other.shopId == shopId &&
        other.takeAway == takeAway &&
        other.takeAwayTempOff == takeAwayTempOff;
  }

  @override
  int get hashCode {
    return pickupTime.hashCode ^
        takeAwayDiscountPercentage.hashCode ^
        minimumAmtForTakeAwayDiscount.hashCode ^
        shopName.hashCode ^
        shopId.hashCode ^
        takeAway.hashCode ^
        takeAwayTempOff.hashCode;
  }
}

class PickupTime {
  PickupTime({
    this.valid,
    this.currentTime,
    this.pickupTime,
  });

  final String? valid;
  final DateTime? currentTime;
  final DateTime? pickupTime;

  PickupTime copyWith({
    String? valid,
    DateTime? currentTime,
    DateTime? pickupTime,
  }) {
    return PickupTime(
      valid: valid ?? this.valid,
      currentTime: currentTime ?? this.currentTime,
      pickupTime: pickupTime ?? this.pickupTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'valid': valid,
      'currentTime': currentTime?.millisecondsSinceEpoch,
      'pickupTime': pickupTime?.millisecondsSinceEpoch,
    };
  }

  factory PickupTime.fromMap(Map<String, dynamic> map) {
    return PickupTime(
      valid: map['valid'] != null ? map['valid'] as String : null,
      currentTime: map['currentTime'] != null
          ? DateTime.parse(map['currentTime'])
          : null,
      pickupTime:
          map['pickupTime'] != null ? DateTime.parse(map['pickupTime']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PickupTime.fromJson(String source) =>
      PickupTime.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PickupTime(valid: $valid, currentTime: $currentTime, pickupTime: $pickupTime)';

  @override
  bool operator ==(covariant PickupTime other) {
    if (identical(this, other)) return true;

    return other.valid == valid &&
        other.currentTime == currentTime &&
        other.pickupTime == pickupTime;
  }

  @override
  int get hashCode =>
      valid.hashCode ^ currentTime.hashCode ^ pickupTime.hashCode;
}


class CalculateTakeawayAmountFormatted {
         final String? cartGrossAmount;
      final String? cartDiscountAmount;
      final String? cartTotalAmount;
      final String? takeAwayDiscount;
      final String? cartNetAmount_ExcludingTax;
      final String? taxTotalAmount;
      final String? cart_NetAmount;
      final String? totalDiscount;
  CalculateTakeawayAmountFormatted({
    this.cartGrossAmount,
    this.cartDiscountAmount,
    this.cartTotalAmount,
    this.takeAwayDiscount,
    this.cartNetAmount_ExcludingTax,
    this.taxTotalAmount,
    this.cart_NetAmount,
    this.totalDiscount,
  });
      

  CalculateTakeawayAmountFormatted copyWith({
    String? cartGrossAmount,
    String? cartDiscountAmount,
    String? cartTotalAmount,
    String? takeAwayDiscount,
    String? cartNetAmount_ExcludingTax,
    String? taxTotalAmount,
    String? cart_NetAmount,
    String? totalDiscount,
  }) {
    return CalculateTakeawayAmountFormatted(
      cartGrossAmount: cartGrossAmount ?? this.cartGrossAmount,
      cartDiscountAmount: cartDiscountAmount ?? this.cartDiscountAmount,
      cartTotalAmount: cartTotalAmount ?? this.cartTotalAmount,
      takeAwayDiscount: takeAwayDiscount ?? this.takeAwayDiscount,
      cartNetAmount_ExcludingTax: cartNetAmount_ExcludingTax ?? this.cartNetAmount_ExcludingTax,
      taxTotalAmount: taxTotalAmount ?? this.taxTotalAmount,
      cart_NetAmount: cart_NetAmount ?? this.cart_NetAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartGrossAmount': cartGrossAmount,
      'cartDiscountAmount': cartDiscountAmount,
      'cartTotalAmount': cartTotalAmount,
      'takeAwayDiscount': takeAwayDiscount,
      'cartNetAmount_ExcludingTax': cartNetAmount_ExcludingTax,
      'taxTotalAmount': taxTotalAmount,
      'cart_NetAmount': cart_NetAmount,
      'totalDiscount': totalDiscount,
    };
  }

  factory CalculateTakeawayAmountFormatted.fromMap(Map<String, dynamic> map) {
    return CalculateTakeawayAmountFormatted(
      cartGrossAmount: map['cartGrossAmount'] != null ? map['cartGrossAmount'] as String : null,
      cartDiscountAmount: map['cartDiscountAmount'] != null ? map['cartDiscountAmount'] as String : null,
      cartTotalAmount: map['cartTotalAmount'] != null ? map['cartTotalAmount'] as String : null,
      takeAwayDiscount: map['takeAwayDiscount'] != null ? map['takeAwayDiscount'] as String : null,
      cartNetAmount_ExcludingTax: map['cartNetAmount_ExcludingTax'] != null ? map['cartNetAmount_ExcludingTax'] as String : null,
      taxTotalAmount: map['taxTotalAmount'] != null ? map['taxTotalAmount'] as String : null,
      cart_NetAmount: map['cart_NetAmount'] != null ? map['cart_NetAmount'] as String : null,
      totalDiscount: map['totalDiscount'] != null ? map['totalDiscount'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalculateTakeawayAmountFormatted.fromJson(String source) => CalculateTakeawayAmountFormatted.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CalculateTakeawayAmountFormatted(cartGrossAmount: $cartGrossAmount, cartDiscountAmount: $cartDiscountAmount, cartTotalAmount: $cartTotalAmount, takeAwayDiscount: $takeAwayDiscount, cartNetAmount_ExcludingTax: $cartNetAmount_ExcludingTax, taxTotalAmount: $taxTotalAmount, cart_NetAmount: $cart_NetAmount, totalDiscount: $totalDiscount)';
  }

  @override
  bool operator ==(covariant CalculateTakeawayAmountFormatted other) {
    if (identical(this, other)) return true;
  
    return 
      other.cartGrossAmount == cartGrossAmount &&
      other.cartDiscountAmount == cartDiscountAmount &&
      other.cartTotalAmount == cartTotalAmount &&
      other.takeAwayDiscount == takeAwayDiscount &&
      other.cartNetAmount_ExcludingTax == cartNetAmount_ExcludingTax &&
      other.taxTotalAmount == taxTotalAmount &&
      other.cart_NetAmount == cart_NetAmount &&
      other.totalDiscount == totalDiscount;
  }

  @override
  int get hashCode {
    return cartGrossAmount.hashCode ^
      cartDiscountAmount.hashCode ^
      cartTotalAmount.hashCode ^
      takeAwayDiscount.hashCode ^
      cartNetAmount_ExcludingTax.hashCode ^
      taxTotalAmount.hashCode ^
      cart_NetAmount.hashCode ^
      totalDiscount.hashCode;
  }
    }

class CalculateTakeawayAmountInPaisa {
      final int? cartGrossAmount;
      final int? cartDiscountAmount;
      final int? cartTotalAmount;
      final int? takeAwayDiscount;
      final int? cartNetAmount_ExcludingTax;
      final int? taxTotalAmount;
      final int? cart_NetAmount;
      final int? totalDiscount;
  CalculateTakeawayAmountInPaisa({
    this.cartGrossAmount,
    this.cartDiscountAmount,
    this.cartTotalAmount,
    this.takeAwayDiscount,
    this.cartNetAmount_ExcludingTax,
    this.taxTotalAmount,
    this.cart_NetAmount,
    this.totalDiscount,
  });
      

  CalculateTakeawayAmountInPaisa copyWith({
    int? cartGrossAmount,
    int? cartDiscountAmount,
    int? cartTotalAmount,
    int? takeAwayDiscount,
    int? cartNetAmount_ExcludingTax,
    int? taxTotalAmount,
    int? cart_NetAmount,
    int? totalDiscount,
  }) {
    return CalculateTakeawayAmountInPaisa(
      cartGrossAmount: cartGrossAmount ?? this.cartGrossAmount,
      cartDiscountAmount: cartDiscountAmount ?? this.cartDiscountAmount,
      cartTotalAmount: cartTotalAmount ?? this.cartTotalAmount,
      takeAwayDiscount: takeAwayDiscount ?? this.takeAwayDiscount,
      cartNetAmount_ExcludingTax: cartNetAmount_ExcludingTax ?? this.cartNetAmount_ExcludingTax,
      taxTotalAmount: taxTotalAmount ?? this.taxTotalAmount,
      cart_NetAmount: cart_NetAmount ?? this.cart_NetAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartGrossAmount': cartGrossAmount,
      'cartDiscountAmount': cartDiscountAmount,
      'cartTotalAmount': cartTotalAmount,
      'takeAwayDiscount': takeAwayDiscount,
      'cartNetAmount_ExcludingTax': cartNetAmount_ExcludingTax,
      'taxTotalAmount': taxTotalAmount,
      'cart_NetAmount': cart_NetAmount,
      'totalDiscount': totalDiscount,
    };
  }

  factory CalculateTakeawayAmountInPaisa.fromMap(Map<String, dynamic> map) {
    return CalculateTakeawayAmountInPaisa(
      cartGrossAmount: map['cartGrossAmount'] != null ? map['cartGrossAmount'] as int : null,
      cartDiscountAmount: map['cartDiscountAmount'] != null ? map['cartDiscountAmount'] as int : null,
      cartTotalAmount: map['cartTotalAmount'] != null ? map['cartTotalAmount'] as int : null,
      takeAwayDiscount: map['takeAwayDiscount'] != null ? map['takeAwayDiscount'] as int : null,
      cartNetAmount_ExcludingTax: map['cartNetAmount_ExcludingTax'] != null ? map['cartNetAmount_ExcludingTax'] as int : null,
      taxTotalAmount: map['taxTotalAmount'] != null ? map['taxTotalAmount'] as int : null,
      cart_NetAmount: map['cart_NetAmount'] != null ? map['cart_NetAmount'] as int : null,
      totalDiscount: map['totalDiscount'] != null ? map['totalDiscount'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalculateTakeawayAmountInPaisa.fromJson(String source) => CalculateTakeawayAmountInPaisa.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CalculateTakeawayAmountInPaisa(cartGrossAmount: $cartGrossAmount, cartDiscountAmount: $cartDiscountAmount, cartTotalAmount: $cartTotalAmount, takeAwayDiscount: $takeAwayDiscount, cartNetAmount_ExcludingTax: $cartNetAmount_ExcludingTax, taxTotalAmount: $taxTotalAmount, cart_NetAmount: $cart_NetAmount, totalDiscount: $totalDiscount)';
  }

  @override
  bool operator ==(covariant CalculateTakeawayAmountInPaisa other) {
    if (identical(this, other)) return true;
  
    return 
      other.cartGrossAmount == cartGrossAmount &&
      other.cartDiscountAmount == cartDiscountAmount &&
      other.cartTotalAmount == cartTotalAmount &&
      other.takeAwayDiscount == takeAwayDiscount &&
      other.cartNetAmount_ExcludingTax == cartNetAmount_ExcludingTax &&
      other.taxTotalAmount == taxTotalAmount &&
      other.cart_NetAmount == cart_NetAmount &&
      other.totalDiscount == totalDiscount;
  }

  @override
  int get hashCode {
    return cartGrossAmount.hashCode ^
      cartDiscountAmount.hashCode ^
      cartTotalAmount.hashCode ^
      takeAwayDiscount.hashCode ^
      cartNetAmount_ExcludingTax.hashCode ^
      taxTotalAmount.hashCode ^
      cart_NetAmount.hashCode ^
      totalDiscount.hashCode;
  }
    }
