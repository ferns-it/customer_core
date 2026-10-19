// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validated_coupon_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ValidatedCouponDetails implements DiagnosticableTreeMixin {

 String? get shopID; String? get coupenCode; CoupenData? get coupenData;
/// Create a copy of ValidatedCouponDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidatedCouponDetailsCopyWith<ValidatedCouponDetails> get copyWith => _$ValidatedCouponDetailsCopyWithImpl<ValidatedCouponDetails>(this as ValidatedCouponDetails, _$identity);

  /// Serializes this ValidatedCouponDetails to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as ValidatedCouponDetails;
  properties
    ..add(DiagnosticsProperty('type', 'ValidatedCouponDetails'))
    ..add(DiagnosticsProperty('shopID', _this.shopID))..add(DiagnosticsProperty('coupenCode', _this.coupenCode))..add(DiagnosticsProperty('coupenData', _this.coupenData));
}

@override
bool operator ==(Object other) {
  final _this = this as ValidatedCouponDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidatedCouponDetails&&(identical(other.shopID, _this.shopID) || other.shopID == _this.shopID)&&(identical(other.coupenCode, _this.coupenCode) || other.coupenCode == _this.coupenCode)&&(identical(other.coupenData, _this.coupenData) || other.coupenData == _this.coupenData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ValidatedCouponDetails;
  return Object.hash(runtimeType,_this.shopID,_this.coupenCode,_this.coupenData);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as ValidatedCouponDetails;
  return 'ValidatedCouponDetails(shopID: ${_this.shopID}, coupenCode: ${_this.coupenCode}, coupenData: ${_this.coupenData})';
}


}

/// @nodoc
abstract mixin class $ValidatedCouponDetailsCopyWith<$Res>  {
  factory $ValidatedCouponDetailsCopyWith(ValidatedCouponDetails value, $Res Function(ValidatedCouponDetails) _then) = _$ValidatedCouponDetailsCopyWithImpl;
@useResult
$Res call({
 String? shopID, String? coupenCode, CoupenData? coupenData
});


$CoupenDataCopyWith<$Res>? get coupenData;

}
/// @nodoc
class _$ValidatedCouponDetailsCopyWithImpl<$Res>
    implements $ValidatedCouponDetailsCopyWith<$Res> {
  _$ValidatedCouponDetailsCopyWithImpl(this._self, this._then);

  final ValidatedCouponDetails _self;
  final $Res Function(ValidatedCouponDetails) _then;

/// Create a copy of ValidatedCouponDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shopID = freezed,Object? coupenCode = freezed,Object? coupenData = freezed,}) {
  return _then(ValidatedCouponDetails(
shopID: freezed == shopID ? _self.shopID : shopID // ignore: cast_nullable_to_non_nullable
as String?,coupenCode: freezed == coupenCode ? _self.coupenCode : coupenCode // ignore: cast_nullable_to_non_nullable
as String?,coupenData: freezed == coupenData ? _self.coupenData : coupenData // ignore: cast_nullable_to_non_nullable
as CoupenData?,
  ));
}
/// Create a copy of ValidatedCouponDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoupenDataCopyWith<$Res>? get coupenData {
    if (_self.coupenData == null) {
    return null;
  }

  return $CoupenDataCopyWith<$Res>(_self.coupenData!, (value) {
    return _then(_self.copyWith(coupenData: value));
  });
}
}


/// Adds pattern-matching-related methods to [ValidatedCouponDetails].
extension ValidatedCouponDetailsPatterns on ValidatedCouponDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ValidatedCouponDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ValidatedCouponDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ValidatedCouponDetails value)  $default,){
final _that = this;
switch (_that) {
case _ValidatedCouponDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ValidatedCouponDetails value)?  $default,){
final _that = this;
switch (_that) {
case _ValidatedCouponDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? shopID,  String? coupenCode,  CoupenData? coupenData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ValidatedCouponDetails() when $default != null:
return $default(_that.shopID,_that.coupenCode,_that.coupenData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? shopID,  String? coupenCode,  CoupenData? coupenData)  $default,) {final _that = this;
switch (_that) {
case _ValidatedCouponDetails():
return $default(_that.shopID,_that.coupenCode,_that.coupenData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? shopID,  String? coupenCode,  CoupenData? coupenData)?  $default,) {final _that = this;
switch (_that) {
case _ValidatedCouponDetails() when $default != null:
return $default(_that.shopID,_that.coupenCode,_that.coupenData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ValidatedCouponDetails with DiagnosticableTreeMixin implements ValidatedCouponDetails {
  const _ValidatedCouponDetails({this.shopID, this.coupenCode, this.coupenData});
  factory _ValidatedCouponDetails.fromJson(Map<String, dynamic> json) => _$ValidatedCouponDetailsFromJson(json);

@override final  String? shopID;
@override final  String? coupenCode;
@override final  CoupenData? coupenData;

/// Create a copy of ValidatedCouponDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValidatedCouponDetailsCopyWith<_ValidatedCouponDetails> get copyWith => __$ValidatedCouponDetailsCopyWithImpl<_ValidatedCouponDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ValidatedCouponDetailsToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'ValidatedCouponDetails'))
    ..add(DiagnosticsProperty('shopID', shopID))..add(DiagnosticsProperty('coupenCode', coupenCode))..add(DiagnosticsProperty('coupenData', coupenData));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ValidatedCouponDetails&&(identical(other.shopID, shopID) || other.shopID == shopID)&&(identical(other.coupenCode, coupenCode) || other.coupenCode == coupenCode)&&(identical(other.coupenData, coupenData) || other.coupenData == coupenData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,shopID,coupenCode,coupenData);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'ValidatedCouponDetails(shopID: $shopID, coupenCode: $coupenCode, coupenData: $coupenData)';
}


}

/// @nodoc
abstract mixin class _$ValidatedCouponDetailsCopyWith<$Res> implements $ValidatedCouponDetailsCopyWith<$Res> {
  factory _$ValidatedCouponDetailsCopyWith(_ValidatedCouponDetails value, $Res Function(_ValidatedCouponDetails) _then) = __$ValidatedCouponDetailsCopyWithImpl;
@override @useResult
$Res call({
 String? shopID, String? coupenCode, CoupenData? coupenData
});


@override $CoupenDataCopyWith<$Res>? get coupenData;

}
/// @nodoc
class __$ValidatedCouponDetailsCopyWithImpl<$Res>
    implements _$ValidatedCouponDetailsCopyWith<$Res> {
  __$ValidatedCouponDetailsCopyWithImpl(this._self, this._then);

  final _ValidatedCouponDetails _self;
  final $Res Function(_ValidatedCouponDetails) _then;

/// Create a copy of ValidatedCouponDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shopID = freezed,Object? coupenCode = freezed,Object? coupenData = freezed,}) {
  return _then(_ValidatedCouponDetails(
shopID: freezed == shopID ? _self.shopID : shopID // ignore: cast_nullable_to_non_nullable
as String?,coupenCode: freezed == coupenCode ? _self.coupenCode : coupenCode // ignore: cast_nullable_to_non_nullable
as String?,coupenData: freezed == coupenData ? _self.coupenData : coupenData // ignore: cast_nullable_to_non_nullable
as CoupenData?,
  ));
}

/// Create a copy of ValidatedCouponDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoupenDataCopyWith<$Res>? get coupenData {
    if (_self.coupenData == null) {
    return null;
  }

  return $CoupenDataCopyWith<$Res>(_self.coupenData!, (value) {
    return _then(_self.copyWith(coupenData: value));
  });
}
}


/// @nodoc
mixin _$CoupenData implements DiagnosticableTreeMixin {

 String? get id; String? get shopID; String? get coupenCode; String? get coupenType; String? get coupenAmount; String? get expiryDate; String? get minSpend; String? get maxSpend; String? get limitPerCoupen; String? get limitPerUser; String? get coupenDetails; String? get coupenStatus; String? get addedTime; String? get lastUpdate;
/// Create a copy of CoupenData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoupenDataCopyWith<CoupenData> get copyWith => _$CoupenDataCopyWithImpl<CoupenData>(this as CoupenData, _$identity);

  /// Serializes this CoupenData to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as CoupenData;
  properties
    ..add(DiagnosticsProperty('type', 'CoupenData'))
    ..add(DiagnosticsProperty('id', _this.id))..add(DiagnosticsProperty('shopID', _this.shopID))..add(DiagnosticsProperty('coupenCode', _this.coupenCode))..add(DiagnosticsProperty('coupenType', _this.coupenType))..add(DiagnosticsProperty('coupenAmount', _this.coupenAmount))..add(DiagnosticsProperty('expiryDate', _this.expiryDate))..add(DiagnosticsProperty('minSpend', _this.minSpend))..add(DiagnosticsProperty('maxSpend', _this.maxSpend))..add(DiagnosticsProperty('limitPerCoupen', _this.limitPerCoupen))..add(DiagnosticsProperty('limitPerUser', _this.limitPerUser))..add(DiagnosticsProperty('coupenDetails', _this.coupenDetails))..add(DiagnosticsProperty('coupenStatus', _this.coupenStatus))..add(DiagnosticsProperty('addedTime', _this.addedTime))..add(DiagnosticsProperty('lastUpdate', _this.lastUpdate));
}

@override
bool operator ==(Object other) {
  final _this = this as CoupenData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoupenData&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.shopID, _this.shopID) || other.shopID == _this.shopID)&&(identical(other.coupenCode, _this.coupenCode) || other.coupenCode == _this.coupenCode)&&(identical(other.coupenType, _this.coupenType) || other.coupenType == _this.coupenType)&&(identical(other.coupenAmount, _this.coupenAmount) || other.coupenAmount == _this.coupenAmount)&&(identical(other.expiryDate, _this.expiryDate) || other.expiryDate == _this.expiryDate)&&(identical(other.minSpend, _this.minSpend) || other.minSpend == _this.minSpend)&&(identical(other.maxSpend, _this.maxSpend) || other.maxSpend == _this.maxSpend)&&(identical(other.limitPerCoupen, _this.limitPerCoupen) || other.limitPerCoupen == _this.limitPerCoupen)&&(identical(other.limitPerUser, _this.limitPerUser) || other.limitPerUser == _this.limitPerUser)&&(identical(other.coupenDetails, _this.coupenDetails) || other.coupenDetails == _this.coupenDetails)&&(identical(other.coupenStatus, _this.coupenStatus) || other.coupenStatus == _this.coupenStatus)&&(identical(other.addedTime, _this.addedTime) || other.addedTime == _this.addedTime)&&(identical(other.lastUpdate, _this.lastUpdate) || other.lastUpdate == _this.lastUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CoupenData;
  return Object.hash(runtimeType,_this.id,_this.shopID,_this.coupenCode,_this.coupenType,_this.coupenAmount,_this.expiryDate,_this.minSpend,_this.maxSpend,_this.limitPerCoupen,_this.limitPerUser,_this.coupenDetails,_this.coupenStatus,_this.addedTime,_this.lastUpdate);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as CoupenData;
  return 'CoupenData(id: ${_this.id}, shopID: ${_this.shopID}, coupenCode: ${_this.coupenCode}, coupenType: ${_this.coupenType}, coupenAmount: ${_this.coupenAmount}, expiryDate: ${_this.expiryDate}, minSpend: ${_this.minSpend}, maxSpend: ${_this.maxSpend}, limitPerCoupen: ${_this.limitPerCoupen}, limitPerUser: ${_this.limitPerUser}, coupenDetails: ${_this.coupenDetails}, coupenStatus: ${_this.coupenStatus}, addedTime: ${_this.addedTime}, lastUpdate: ${_this.lastUpdate})';
}


}

/// @nodoc
abstract mixin class $CoupenDataCopyWith<$Res>  {
  factory $CoupenDataCopyWith(CoupenData value, $Res Function(CoupenData) _then) = _$CoupenDataCopyWithImpl;
@useResult
$Res call({
 String? id, String? shopID, String? coupenCode, String? coupenType, String? coupenAmount, String? expiryDate, String? minSpend, String? maxSpend, String? limitPerCoupen, String? limitPerUser, String? coupenDetails, String? coupenStatus, String? addedTime, String? lastUpdate
});




}
/// @nodoc
class _$CoupenDataCopyWithImpl<$Res>
    implements $CoupenDataCopyWith<$Res> {
  _$CoupenDataCopyWithImpl(this._self, this._then);

  final CoupenData _self;
  final $Res Function(CoupenData) _then;

/// Create a copy of CoupenData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? shopID = freezed,Object? coupenCode = freezed,Object? coupenType = freezed,Object? coupenAmount = freezed,Object? expiryDate = freezed,Object? minSpend = freezed,Object? maxSpend = freezed,Object? limitPerCoupen = freezed,Object? limitPerUser = freezed,Object? coupenDetails = freezed,Object? coupenStatus = freezed,Object? addedTime = freezed,Object? lastUpdate = freezed,}) {
  return _then(CoupenData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,shopID: freezed == shopID ? _self.shopID : shopID // ignore: cast_nullable_to_non_nullable
as String?,coupenCode: freezed == coupenCode ? _self.coupenCode : coupenCode // ignore: cast_nullable_to_non_nullable
as String?,coupenType: freezed == coupenType ? _self.coupenType : coupenType // ignore: cast_nullable_to_non_nullable
as String?,coupenAmount: freezed == coupenAmount ? _self.coupenAmount : coupenAmount // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,minSpend: freezed == minSpend ? _self.minSpend : minSpend // ignore: cast_nullable_to_non_nullable
as String?,maxSpend: freezed == maxSpend ? _self.maxSpend : maxSpend // ignore: cast_nullable_to_non_nullable
as String?,limitPerCoupen: freezed == limitPerCoupen ? _self.limitPerCoupen : limitPerCoupen // ignore: cast_nullable_to_non_nullable
as String?,limitPerUser: freezed == limitPerUser ? _self.limitPerUser : limitPerUser // ignore: cast_nullable_to_non_nullable
as String?,coupenDetails: freezed == coupenDetails ? _self.coupenDetails : coupenDetails // ignore: cast_nullable_to_non_nullable
as String?,coupenStatus: freezed == coupenStatus ? _self.coupenStatus : coupenStatus // ignore: cast_nullable_to_non_nullable
as String?,addedTime: freezed == addedTime ? _self.addedTime : addedTime // ignore: cast_nullable_to_non_nullable
as String?,lastUpdate: freezed == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoupenData].
extension CoupenDataPatterns on CoupenData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoupenData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoupenData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoupenData value)  $default,){
final _that = this;
switch (_that) {
case _CoupenData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoupenData value)?  $default,){
final _that = this;
switch (_that) {
case _CoupenData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? shopID,  String? coupenCode,  String? coupenType,  String? coupenAmount,  String? expiryDate,  String? minSpend,  String? maxSpend,  String? limitPerCoupen,  String? limitPerUser,  String? coupenDetails,  String? coupenStatus,  String? addedTime,  String? lastUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoupenData() when $default != null:
return $default(_that.id,_that.shopID,_that.coupenCode,_that.coupenType,_that.coupenAmount,_that.expiryDate,_that.minSpend,_that.maxSpend,_that.limitPerCoupen,_that.limitPerUser,_that.coupenDetails,_that.coupenStatus,_that.addedTime,_that.lastUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? shopID,  String? coupenCode,  String? coupenType,  String? coupenAmount,  String? expiryDate,  String? minSpend,  String? maxSpend,  String? limitPerCoupen,  String? limitPerUser,  String? coupenDetails,  String? coupenStatus,  String? addedTime,  String? lastUpdate)  $default,) {final _that = this;
switch (_that) {
case _CoupenData():
return $default(_that.id,_that.shopID,_that.coupenCode,_that.coupenType,_that.coupenAmount,_that.expiryDate,_that.minSpend,_that.maxSpend,_that.limitPerCoupen,_that.limitPerUser,_that.coupenDetails,_that.coupenStatus,_that.addedTime,_that.lastUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? shopID,  String? coupenCode,  String? coupenType,  String? coupenAmount,  String? expiryDate,  String? minSpend,  String? maxSpend,  String? limitPerCoupen,  String? limitPerUser,  String? coupenDetails,  String? coupenStatus,  String? addedTime,  String? lastUpdate)?  $default,) {final _that = this;
switch (_that) {
case _CoupenData() when $default != null:
return $default(_that.id,_that.shopID,_that.coupenCode,_that.coupenType,_that.coupenAmount,_that.expiryDate,_that.minSpend,_that.maxSpend,_that.limitPerCoupen,_that.limitPerUser,_that.coupenDetails,_that.coupenStatus,_that.addedTime,_that.lastUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoupenData with DiagnosticableTreeMixin implements CoupenData {
  const _CoupenData({this.id, this.shopID, this.coupenCode, this.coupenType, this.coupenAmount, this.expiryDate, this.minSpend, this.maxSpend, this.limitPerCoupen, this.limitPerUser, this.coupenDetails, this.coupenStatus, this.addedTime, this.lastUpdate});
  factory _CoupenData.fromJson(Map<String, dynamic> json) => _$CoupenDataFromJson(json);

@override final  String? id;
@override final  String? shopID;
@override final  String? coupenCode;
@override final  String? coupenType;
@override final  String? coupenAmount;
@override final  String? expiryDate;
@override final  String? minSpend;
@override final  String? maxSpend;
@override final  String? limitPerCoupen;
@override final  String? limitPerUser;
@override final  String? coupenDetails;
@override final  String? coupenStatus;
@override final  String? addedTime;
@override final  String? lastUpdate;

/// Create a copy of CoupenData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoupenDataCopyWith<_CoupenData> get copyWith => __$CoupenDataCopyWithImpl<_CoupenData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoupenDataToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'CoupenData'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('shopID', shopID))..add(DiagnosticsProperty('coupenCode', coupenCode))..add(DiagnosticsProperty('coupenType', coupenType))..add(DiagnosticsProperty('coupenAmount', coupenAmount))..add(DiagnosticsProperty('expiryDate', expiryDate))..add(DiagnosticsProperty('minSpend', minSpend))..add(DiagnosticsProperty('maxSpend', maxSpend))..add(DiagnosticsProperty('limitPerCoupen', limitPerCoupen))..add(DiagnosticsProperty('limitPerUser', limitPerUser))..add(DiagnosticsProperty('coupenDetails', coupenDetails))..add(DiagnosticsProperty('coupenStatus', coupenStatus))..add(DiagnosticsProperty('addedTime', addedTime))..add(DiagnosticsProperty('lastUpdate', lastUpdate));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoupenData&&(identical(other.id, id) || other.id == id)&&(identical(other.shopID, shopID) || other.shopID == shopID)&&(identical(other.coupenCode, coupenCode) || other.coupenCode == coupenCode)&&(identical(other.coupenType, coupenType) || other.coupenType == coupenType)&&(identical(other.coupenAmount, coupenAmount) || other.coupenAmount == coupenAmount)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.minSpend, minSpend) || other.minSpend == minSpend)&&(identical(other.maxSpend, maxSpend) || other.maxSpend == maxSpend)&&(identical(other.limitPerCoupen, limitPerCoupen) || other.limitPerCoupen == limitPerCoupen)&&(identical(other.limitPerUser, limitPerUser) || other.limitPerUser == limitPerUser)&&(identical(other.coupenDetails, coupenDetails) || other.coupenDetails == coupenDetails)&&(identical(other.coupenStatus, coupenStatus) || other.coupenStatus == coupenStatus)&&(identical(other.addedTime, addedTime) || other.addedTime == addedTime)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,shopID,coupenCode,coupenType,coupenAmount,expiryDate,minSpend,maxSpend,limitPerCoupen,limitPerUser,coupenDetails,coupenStatus,addedTime,lastUpdate);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'CoupenData(id: $id, shopID: $shopID, coupenCode: $coupenCode, coupenType: $coupenType, coupenAmount: $coupenAmount, expiryDate: $expiryDate, minSpend: $minSpend, maxSpend: $maxSpend, limitPerCoupen: $limitPerCoupen, limitPerUser: $limitPerUser, coupenDetails: $coupenDetails, coupenStatus: $coupenStatus, addedTime: $addedTime, lastUpdate: $lastUpdate)';
}


}

/// @nodoc
abstract mixin class _$CoupenDataCopyWith<$Res> implements $CoupenDataCopyWith<$Res> {
  factory _$CoupenDataCopyWith(_CoupenData value, $Res Function(_CoupenData) _then) = __$CoupenDataCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? shopID, String? coupenCode, String? coupenType, String? coupenAmount, String? expiryDate, String? minSpend, String? maxSpend, String? limitPerCoupen, String? limitPerUser, String? coupenDetails, String? coupenStatus, String? addedTime, String? lastUpdate
});




}
/// @nodoc
class __$CoupenDataCopyWithImpl<$Res>
    implements _$CoupenDataCopyWith<$Res> {
  __$CoupenDataCopyWithImpl(this._self, this._then);

  final _CoupenData _self;
  final $Res Function(_CoupenData) _then;

/// Create a copy of CoupenData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? shopID = freezed,Object? coupenCode = freezed,Object? coupenType = freezed,Object? coupenAmount = freezed,Object? expiryDate = freezed,Object? minSpend = freezed,Object? maxSpend = freezed,Object? limitPerCoupen = freezed,Object? limitPerUser = freezed,Object? coupenDetails = freezed,Object? coupenStatus = freezed,Object? addedTime = freezed,Object? lastUpdate = freezed,}) {
  return _then(_CoupenData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,shopID: freezed == shopID ? _self.shopID : shopID // ignore: cast_nullable_to_non_nullable
as String?,coupenCode: freezed == coupenCode ? _self.coupenCode : coupenCode // ignore: cast_nullable_to_non_nullable
as String?,coupenType: freezed == coupenType ? _self.coupenType : coupenType // ignore: cast_nullable_to_non_nullable
as String?,coupenAmount: freezed == coupenAmount ? _self.coupenAmount : coupenAmount // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,minSpend: freezed == minSpend ? _self.minSpend : minSpend // ignore: cast_nullable_to_non_nullable
as String?,maxSpend: freezed == maxSpend ? _self.maxSpend : maxSpend // ignore: cast_nullable_to_non_nullable
as String?,limitPerCoupen: freezed == limitPerCoupen ? _self.limitPerCoupen : limitPerCoupen // ignore: cast_nullable_to_non_nullable
as String?,limitPerUser: freezed == limitPerUser ? _self.limitPerUser : limitPerUser // ignore: cast_nullable_to_non_nullable
as String?,coupenDetails: freezed == coupenDetails ? _self.coupenDetails : coupenDetails // ignore: cast_nullable_to_non_nullable
as String?,coupenStatus: freezed == coupenStatus ? _self.coupenStatus : coupenStatus // ignore: cast_nullable_to_non_nullable
as String?,addedTime: freezed == addedTime ? _self.addedTime : addedTime // ignore: cast_nullable_to_non_nullable
as String?,lastUpdate: freezed == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
