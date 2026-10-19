// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfferDetailsModel implements DiagnosticableTreeMixin {

 String? get id; String? get shopID; String? get coupenCode; String? get coupenType; String? get coupenAmount; String? get expiryDate; String? get minSpend; String? get maxSpend; String? get coupenDetails; String? get coupenStatus;
/// Create a copy of OfferDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferDetailsModelCopyWith<OfferDetailsModel> get copyWith => _$OfferDetailsModelCopyWithImpl<OfferDetailsModel>(this as OfferDetailsModel, _$identity);

  /// Serializes this OfferDetailsModel to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as OfferDetailsModel;
  properties
    ..add(DiagnosticsProperty('type', 'OfferDetailsModel'))
    ..add(DiagnosticsProperty('id', _this.id))..add(DiagnosticsProperty('shopID', _this.shopID))..add(DiagnosticsProperty('coupenCode', _this.coupenCode))..add(DiagnosticsProperty('coupenType', _this.coupenType))..add(DiagnosticsProperty('coupenAmount', _this.coupenAmount))..add(DiagnosticsProperty('expiryDate', _this.expiryDate))..add(DiagnosticsProperty('minSpend', _this.minSpend))..add(DiagnosticsProperty('maxSpend', _this.maxSpend))..add(DiagnosticsProperty('coupenDetails', _this.coupenDetails))..add(DiagnosticsProperty('coupenStatus', _this.coupenStatus));
}

@override
bool operator ==(Object other) {
  final _this = this as OfferDetailsModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferDetailsModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.shopID, _this.shopID) || other.shopID == _this.shopID)&&(identical(other.coupenCode, _this.coupenCode) || other.coupenCode == _this.coupenCode)&&(identical(other.coupenType, _this.coupenType) || other.coupenType == _this.coupenType)&&(identical(other.coupenAmount, _this.coupenAmount) || other.coupenAmount == _this.coupenAmount)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.minSpend, _this.minSpend) || other.minSpend == _this.minSpend)&&(identical(other.maxSpend, _this.maxSpend) || other.maxSpend == _this.maxSpend)&&(identical(other.coupenDetails, _this.coupenDetails) || other.coupenDetails == _this.coupenDetails)&&(identical(other.coupenStatus, _this.coupenStatus) || other.coupenStatus == _this.coupenStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OfferDetailsModel;
  return Object.hash(runtimeType,_this.id,_this.shopID,_this.coupenCode,_this.coupenType,_this.coupenAmount,_this.expiryDate,_this.minSpend,_this.maxSpend,_this.coupenDetails,_this.coupenStatus);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as OfferDetailsModel;
  return 'OfferDetailsModel(id: ${_this.id}, shopID: ${_this.shopID}, coupenCode: ${_this.coupenCode}, coupenType: ${_this.coupenType}, coupenAmount: ${_this.coupenAmount}, expiryDate: ${_this.expiryDate}, minSpend: ${_this.minSpend}, maxSpend: ${_this.maxSpend}, coupenDetails: ${_this.coupenDetails}, coupenStatus: ${_this.coupenStatus})';
}


}

/// @nodoc
abstract mixin class $OfferDetailsModelCopyWith<$Res>  {
  factory $OfferDetailsModelCopyWith(OfferDetailsModel value, $Res Function(OfferDetailsModel) _then) = _$OfferDetailsModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? shopID, String? coupenCode, String? coupenType, String? coupenAmount, String? expiryDate, String? minSpend, String? maxSpend, String? coupenDetails, String? coupenStatus
});




}
/// @nodoc
class _$OfferDetailsModelCopyWithImpl<$Res>
    implements $OfferDetailsModelCopyWith<$Res> {
  _$OfferDetailsModelCopyWithImpl(this._self, this._then);

  final OfferDetailsModel _self;
  final $Res Function(OfferDetailsModel) _then;

/// Create a copy of OfferDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? shopID = freezed,Object? coupenCode = freezed,Object? coupenType = freezed,Object? coupenAmount = freezed,Object? expiryDate = freezed,Object? minSpend = freezed,Object? maxSpend = freezed,Object? coupenDetails = freezed,Object? coupenStatus = freezed,}) {
  return _then(OfferDetailsModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,shopID: freezed == shopID ? _self.shopID : shopID // ignore: cast_nullable_to_non_nullable
as String?,coupenCode: freezed == coupenCode ? _self.coupenCode : coupenCode // ignore: cast_nullable_to_non_nullable
as String?,coupenType: freezed == coupenType ? _self.coupenType : coupenType // ignore: cast_nullable_to_non_nullable
as String?,coupenAmount: freezed == coupenAmount ? _self.coupenAmount : coupenAmount // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,minSpend: freezed == minSpend ? _self.minSpend : minSpend // ignore: cast_nullable_to_non_nullable
as String?,maxSpend: freezed == maxSpend ? _self.maxSpend : maxSpend // ignore: cast_nullable_to_non_nullable
as String?,coupenDetails: freezed == coupenDetails ? _self.coupenDetails : coupenDetails // ignore: cast_nullable_to_non_nullable
as String?,coupenStatus: freezed == coupenStatus ? _self.coupenStatus : coupenStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferDetailsModel].
extension OfferDetailsModelPatterns on OfferDetailsModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferDetailsModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _OfferDetailsModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _OfferDetailsModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? shopID,  String? coupenCode,  String? coupenType,  String? coupenAmount,  String? expiryDate,  String? minSpend,  String? maxSpend,  String? coupenDetails,  String? coupenStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferDetailsModel() when $default != null:
return $default(_that.id,_that.shopID,_that.coupenCode,_that.coupenType,_that.coupenAmount,_that.expiryDate,_that.minSpend,_that.maxSpend,_that.coupenDetails,_that.coupenStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? shopID,  String? coupenCode,  String? coupenType,  String? coupenAmount,  String? expiryDate,  String? minSpend,  String? maxSpend,  String? coupenDetails,  String? coupenStatus)  $default,) {final _that = this;
switch (_that) {
case _OfferDetailsModel():
return $default(_that.id,_that.shopID,_that.coupenCode,_that.coupenType,_that.coupenAmount,_that.expiryDate,_that.minSpend,_that.maxSpend,_that.coupenDetails,_that.coupenStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? shopID,  String? coupenCode,  String? coupenType,  String? coupenAmount,  String? expiryDate,  String? minSpend,  String? maxSpend,  String? coupenDetails,  String? coupenStatus)?  $default,) {final _that = this;
switch (_that) {
case _OfferDetailsModel() when $default != null:
return $default(_that.id,_that.shopID,_that.coupenCode,_that.coupenType,_that.coupenAmount,_that.expiryDate,_that.minSpend,_that.maxSpend,_that.coupenDetails,_that.coupenStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferDetailsModel with DiagnosticableTreeMixin implements OfferDetailsModel {
  const _OfferDetailsModel({this.id, this.shopID, this.coupenCode, this.coupenType, this.coupenAmount, this.expiryDate, this.minSpend, this.maxSpend, this.coupenDetails, this.coupenStatus});
  factory _OfferDetailsModel.fromJson(Map<String, dynamic> json) => _$OfferDetailsModelFromJson(json);

@override final  String? id;
@override final  String? shopID;
@override final  String? coupenCode;
@override final  String? coupenType;
@override final  String? coupenAmount;
@override final  String? expiryDate;
@override final  String? minSpend;
@override final  String? maxSpend;
@override final  String? coupenDetails;
@override final  String? coupenStatus;

/// Create a copy of OfferDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferDetailsModelCopyWith<_OfferDetailsModel> get copyWith => __$OfferDetailsModelCopyWithImpl<_OfferDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferDetailsModelToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'OfferDetailsModel'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('shopID', shopID))..add(DiagnosticsProperty('coupenCode', coupenCode))..add(DiagnosticsProperty('coupenType', coupenType))..add(DiagnosticsProperty('coupenAmount', coupenAmount))..add(DiagnosticsProperty('expiryDate', expiryDate))..add(DiagnosticsProperty('minSpend', minSpend))..add(DiagnosticsProperty('maxSpend', maxSpend))..add(DiagnosticsProperty('coupenDetails', coupenDetails))..add(DiagnosticsProperty('coupenStatus', coupenStatus));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferDetailsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.shopID, shopID) || other.shopID == shopID)&&(identical(other.coupenCode, coupenCode) || other.coupenCode == coupenCode)&&(identical(other.coupenType, coupenType) || other.coupenType == coupenType)&&(identical(other.coupenAmount, coupenAmount) || other.coupenAmount == coupenAmount)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.minSpend, minSpend) || other.minSpend == minSpend)&&(identical(other.maxSpend, maxSpend) || other.maxSpend == maxSpend)&&(identical(other.coupenDetails, coupenDetails) || other.coupenDetails == coupenDetails)&&(identical(other.coupenStatus, coupenStatus) || other.coupenStatus == coupenStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,shopID,coupenCode,coupenType,coupenAmount,expiryDate,minSpend,maxSpend,coupenDetails,coupenStatus);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'OfferDetailsModel(id: $id, shopID: $shopID, coupenCode: $coupenCode, coupenType: $coupenType, coupenAmount: $coupenAmount, expiryDate: $expiryDate, minSpend: $minSpend, maxSpend: $maxSpend, coupenDetails: $coupenDetails, coupenStatus: $coupenStatus)';
}


}

/// @nodoc
abstract mixin class _$OfferDetailsModelCopyWith<$Res> implements $OfferDetailsModelCopyWith<$Res> {
  factory _$OfferDetailsModelCopyWith(_OfferDetailsModel value, $Res Function(_OfferDetailsModel) _then) = __$OfferDetailsModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? shopID, String? coupenCode, String? coupenType, String? coupenAmount, String? expiryDate, String? minSpend, String? maxSpend, String? coupenDetails, String? coupenStatus
});




}
/// @nodoc
class __$OfferDetailsModelCopyWithImpl<$Res>
    implements _$OfferDetailsModelCopyWith<$Res> {
  __$OfferDetailsModelCopyWithImpl(this._self, this._then);

  final _OfferDetailsModel _self;
  final $Res Function(_OfferDetailsModel) _then;

/// Create a copy of OfferDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? shopID = freezed,Object? coupenCode = freezed,Object? coupenType = freezed,Object? coupenAmount = freezed,Object? expiryDate = freezed,Object? minSpend = freezed,Object? maxSpend = freezed,Object? coupenDetails = freezed,Object? coupenStatus = freezed,}) {
  return _then(_OfferDetailsModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,shopID: freezed == shopID ? _self.shopID : shopID // ignore: cast_nullable_to_non_nullable
as String?,coupenCode: freezed == coupenCode ? _self.coupenCode : coupenCode // ignore: cast_nullable_to_non_nullable
as String?,coupenType: freezed == coupenType ? _self.coupenType : coupenType // ignore: cast_nullable_to_non_nullable
as String?,coupenAmount: freezed == coupenAmount ? _self.coupenAmount : coupenAmount // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,minSpend: freezed == minSpend ? _self.minSpend : minSpend // ignore: cast_nullable_to_non_nullable
as String?,maxSpend: freezed == maxSpend ? _self.maxSpend : maxSpend // ignore: cast_nullable_to_non_nullable
as String?,coupenDetails: freezed == coupenDetails ? _self.coupenDetails : coupenDetails // ignore: cast_nullable_to_non_nullable
as String?,coupenStatus: freezed == coupenStatus ? _self.coupenStatus : coupenStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
