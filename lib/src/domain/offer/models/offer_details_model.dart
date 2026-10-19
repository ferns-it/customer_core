import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'offer_details_model.freezed.dart';
part 'offer_details_model.g.dart';

@freezed
abstract class OfferDetailsModel with _$OfferDetailsModel {
  const factory OfferDetailsModel({
    String? id,
    String? shopID,
    String? coupenCode,
    String? coupenType,
    String? coupenAmount,
    String? expiryDate,
    String? minSpend,
    String? maxSpend,
    String? coupenDetails,
    String? coupenStatus,
  }) = _OfferDetailsModel;

  factory OfferDetailsModel.fromJson(Map<String, Object?> json) =>
      _$OfferDetailsModelFromJson(json);
}
