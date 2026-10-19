import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter/foundation.dart';

part 'validated_coupon_details.g.dart';
part 'validated_coupon_details.freezed.dart';

@freezed
abstract class ValidatedCouponDetails with _$ValidatedCouponDetails {
  const factory ValidatedCouponDetails({
    String? shopID,
    String? coupenCode,
    CoupenData? coupenData,


  }) = _ValidatedCouponDetails;

  factory ValidatedCouponDetails.fromJson(Map<String, Object?> json) =>
      _$ValidatedCouponDetailsFromJson(json);
}

@freezed
abstract class CoupenData with _$CoupenData {
  const factory CoupenData({
    String? id,
    String? shopID,
    String? coupenCode,
    String? coupenType,
    String? coupenAmount,
    String? expiryDate,
    String? minSpend,
    String? maxSpend,
    String? limitPerCoupen,
    String? limitPerUser,
    String? coupenDetails,
    String? coupenStatus,
    String? addedTime,
    String? lastUpdate,
  }) = _CoupenData;

  factory CoupenData.fromJson(Map<String, Object?> json) =>
      _$CoupenDataFromJson(json);


}


// {
//     "shopID": 1,
//     "coupenCode": "PAK100",
//     "coupenData": {
//       "id": "10",
//       "shopID": "1",
//       "coupenCode": "PAK100",
//       "coupenType": "percentage",
//       "coupenAmount": "100.00",
//       "expiryDate": "2024-12-20",
//       "minSpend": "200.00",
//       "maxSpend": "0.00",
//       "limitPerCoupen": "0",
//       "limitPerUser": "0",
//       "coupenDetails": "${AppConfig.instance.country.symbol}100 off for new users",
//       "coupenStatus": "Active",
//       "addedTime": "2024-11-20 09:27:09",
//       "lastUpdate": "2024-11-20 09:27:09"
// }