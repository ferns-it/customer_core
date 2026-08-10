// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class StoreSettingsDataModel {
  final String? id;
  final String? name;
  final String? email;
  final bool? available;
  final String? shopStatus;
  final String? mobile;
  final String? image;
  final StoreDeliverySettingsInfo? deliveryInfo;
  final String? themeTitle;
  final String? themeBanner;
  final String? themeLogo;
  final String? primaryColor;
  final String? SecondaryColor;
  final String? buttonColor;
  final String? buttonHoverColor;
  final String? linkColor;
  final String? linkHoverColor;
  final String? headerColor;
  final String? footerColor;
  final StoreTableReservationSettings? tableReservationSettings;
  final String? hash;
  final String? smsVerification;
  final String? emailVerification;
  final List<SmsAvailableCountriesData> smsAvailableCountries;

  StoreSettingsDataModel({
    this.id,
    this.name,
    this.email,
    this.available,
    this.shopStatus,
    this.mobile,
    this.image,
    this.deliveryInfo,
    this.themeTitle,
    this.themeBanner,
    this.themeLogo,
    this.primaryColor,
    this.SecondaryColor,
    this.buttonColor,
    this.buttonHoverColor,
    this.linkColor,
    this.linkHoverColor,
    this.headerColor,
    this.footerColor,
    this.tableReservationSettings,
    this.hash,
    this.smsVerification,
    this.emailVerification,
    required this.smsAvailableCountries,
  });

  StoreSettingsDataModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? available,
    String? shopStatus,
    String? mobile,
    String? image,
    StoreDeliverySettingsInfo? deliveryInfo,
    String? themeTitle,
    String? themeBanner,
    String? themeLogo,
    String? primaryColor,
    String? SecondaryColor,
    String? buttonColor,
    String? buttonHoverColor,
    String? linkColor,
    String? linkHoverColor,
    String? headerColor,
    String? footerColor,
    StoreTableReservationSettings? tableReservationSettings,
    String? hash,
    String? smsVerification,
    String? emailVerification,
    List<SmsAvailableCountriesData>? smsAvailableCountries,
  }) {
    return StoreSettingsDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      available: available ?? this.available,
      shopStatus: shopStatus ?? this.shopStatus,
      mobile: mobile ?? this.mobile,
      image: image ?? this.image,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      themeTitle: themeTitle ?? this.themeTitle,
      themeBanner: themeBanner ?? this.themeBanner,
      themeLogo: themeLogo ?? this.themeLogo,
      primaryColor: primaryColor ?? this.primaryColor,
      SecondaryColor: SecondaryColor ?? this.SecondaryColor,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonHoverColor: buttonHoverColor ?? this.buttonHoverColor,
      linkColor: linkColor ?? this.linkColor,
      linkHoverColor: linkHoverColor ?? this.linkHoverColor,
      headerColor: headerColor ?? this.headerColor,
      footerColor: footerColor ?? this.footerColor,
      tableReservationSettings:
          tableReservationSettings ?? this.tableReservationSettings,
      hash: hash ?? this.hash,
      smsVerification: smsVerification ?? this.smsVerification,
      emailVerification: emailVerification ?? this.emailVerification,
      smsAvailableCountries:
          smsAvailableCountries ?? this.smsAvailableCountries,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'available': available,
      'shopStatus': shopStatus,
      'mobile': mobile,
      'image': image,
      'deliveryInfo': deliveryInfo?.toMap(),
      'themeTitle': themeTitle,
      'themeBanner': themeBanner,
      'themeLogo': themeLogo,
      'primaryColor': primaryColor,
      'SecondaryColor': SecondaryColor,
      'buttonColor': buttonColor,
      'buttonHoverColor': buttonHoverColor,
      'linkColor': linkColor,
      'linkHoverColor': linkHoverColor,
      'headerColor': headerColor,
      'footerColor': footerColor,
      'tableReservationSettings': tableReservationSettings?.toMap(),
      'hash': hash,
      'smsVerification': smsVerification,
      'emailVerification': emailVerification,
      'smsAvailableCountries':
          smsAvailableCountries.map((x) => x.toMap()).toList(),
    };
  }

  factory StoreSettingsDataModel.fromMap(Map<String, dynamic> map) {
    return StoreSettingsDataModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      available: map['available'] != null ? map['available'] as bool : null,
      shopStatus:
          map['shopStatus'] != null ? map['shopStatus'] as String : null,
      mobile: map['mobile'] != null ? map['mobile'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      deliveryInfo: map['deliveryInfo'] != null
          ? StoreDeliverySettingsInfo.fromMap(
              map['deliveryInfo'] as Map<String, dynamic>)
          : null,
      themeTitle:
          map['themeTitle'] != null ? map['themeTitle'] as String : null,
      themeBanner:
          map['themeBanner'] != null ? map['themeBanner'] as String : null,
      themeLogo: map['themeLogo'] != null ? map['themeLogo'] as String : null,
      primaryColor:
          map['primaryColor'] != null ? map['primaryColor'] as String : null,
      SecondaryColor: map['SecondaryColor'] != null
          ? map['SecondaryColor'] as String
          : null,
      buttonColor:
          map['buttonColor'] != null ? map['buttonColor'] as String : null,
      buttonHoverColor: map['buttonHoverColor'] != null
          ? map['buttonHoverColor'] as String
          : null,
      linkColor: map['linkColor'] != null ? map['linkColor'] as String : null,
      linkHoverColor: map['linkHoverColor'] != null
          ? map['linkHoverColor'] as String
          : null,
      headerColor:
          map['headerColor'] != null ? map['headerColor'] as String : null,
      footerColor:
          map['footerColor'] != null ? map['footerColor'] as String : null,
      tableReservationSettings: map['tableReservationSettings'] != null
          ? StoreTableReservationSettings.fromMap(
              map['tableReservationSettings'] as Map<String, dynamic>)
          : null,
      hash: map['hash'] != null ? map['hash'] as String : null,
      smsVerification: map['smsVerification'] != null
          ? map['smsVerification'] as String
          : null,
      emailVerification: map['emailVerification'] != null
          ? map['emailVerification'] as String
          : null,
      smsAvailableCountries: List<SmsAvailableCountriesData>.from(
        (map['smsAvailableCountries'] as List<dynamic>)
            .map<SmsAvailableCountriesData>(
          (x) => SmsAvailableCountriesData.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreSettingsDataModel.fromJson(String source) =>
      StoreSettingsDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreSettingsDataModel(id: $id, name: $name, email: $email, available: $available, shopStatus: $shopStatus, mobile: $mobile, image: $image, deliveryInfo: $deliveryInfo, themeTitle: $themeTitle, themeBanner: $themeBanner, themeLogo: $themeLogo, primaryColor: $primaryColor, SecondaryColor: $SecondaryColor, buttonColor: $buttonColor, buttonHoverColor: $buttonHoverColor, linkColor: $linkColor, linkHoverColor: $linkHoverColor, headerColor: $headerColor, footerColor: $footerColor, tableReservationSettings: $tableReservationSettings, hash: $hash,smsAvailableCountries: $smsAvailableCountries)';
  }

  @override
  bool operator ==(covariant StoreSettingsDataModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.available == available &&
        other.shopStatus == shopStatus &&
        other.mobile == mobile &&
        other.image == image &&
        other.deliveryInfo == deliveryInfo &&
        other.themeTitle == themeTitle &&
        other.themeBanner == themeBanner &&
        other.themeLogo == themeLogo &&
        other.primaryColor == primaryColor &&
        other.SecondaryColor == SecondaryColor &&
        other.buttonColor == buttonColor &&
        other.buttonHoverColor == buttonHoverColor &&
        other.linkColor == linkColor &&
        other.linkHoverColor == linkHoverColor &&
        other.headerColor == headerColor &&
        other.footerColor == footerColor &&
        other.tableReservationSettings == tableReservationSettings &&
        other.hash == hash &&
        other.smsVerification == smsVerification &&
        other.emailVerification == emailVerification &&
        listEquals(other.smsAvailableCountries, smsAvailableCountries);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        available.hashCode ^
        shopStatus.hashCode ^
        mobile.hashCode ^
        image.hashCode ^
        deliveryInfo.hashCode ^
        themeTitle.hashCode ^
        themeBanner.hashCode ^
        themeLogo.hashCode ^
        primaryColor.hashCode ^
        SecondaryColor.hashCode ^
        buttonColor.hashCode ^
        buttonHoverColor.hashCode ^
        linkColor.hashCode ^
        linkHoverColor.hashCode ^
        headerColor.hashCode ^
        footerColor.hashCode ^
        tableReservationSettings.hashCode ^
        hash.hashCode ^
        smsVerification.hashCode ^
        emailVerification.hashCode ^
        smsAvailableCountries.hashCode;
  }
}

class StoreFixedDeliveryLocationSettings {
  final String? distance;
  final String? postcode;
  final String? amount;

  StoreFixedDeliveryLocationSettings({
    this.distance,
    this.postcode,
    this.amount,
  });

  StoreFixedDeliveryLocationSettings copyWith({
    String? distance,
    String? postcode,
    String? amount,
  }) {
    return StoreFixedDeliveryLocationSettings(
      distance: distance ?? this.distance,
      postcode: postcode ?? this.postcode,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'distance': distance,
      'postcode': postcode,
      'amount': amount,
    };
  }

  factory StoreFixedDeliveryLocationSettings.fromMap(Map<String, dynamic> map) {
    return StoreFixedDeliveryLocationSettings(
      distance: map['distance'] != null ? map['distance'] as String : null,
      postcode: map['postcode'] != null ? map['postcode'] as String : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreFixedDeliveryLocationSettings.fromJson(String source) =>
      StoreFixedDeliveryLocationSettings.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StoreFixedDeliveryLocationSettings(distance: $distance, postcode: $postcode, amount: $amount)';

  @override
  bool operator ==(covariant StoreFixedDeliveryLocationSettings other) {
    if (identical(this, other)) return true;

    return other.distance == distance &&
        other.postcode == postcode &&
        other.amount == amount;
  }

  @override
  int get hashCode => distance.hashCode ^ postcode.hashCode ^ amount.hashCode;
}

class StoreDeliverySettingsInfo {
  final String? id;
  final String? shopId;
  final String? shopPostcode;
  final String? currencyType;
  final String? takeAway;
  final String? homeDelivery;
  final String? shopOpen_temp_off;
  final String? takeAway_temp_off;
  final String? homeDelivery_temp_off;
  final String? discountTakeAway;
  final String? minAmtForTakAwayDiscnt;
  final String? deliveryMinAmount;
  final String? deliveryMinAmountType;
  final String? discountHomeDelivery;
  final String? minAmtForHomDelvryDiscnt;
  final String? distanceType;
  final String? freeDelivery;
  final String? freeDeliveryRadius;
  final String? freeDeliveryMinOrder;
  final String? deliveryChargeType;
  final String? minDeliveryCharge;
  final String? ratePerMile;
  final String? maxDeliveryRadius;
  final String? preOrder;
  final String? preOrderBefore;
  final String? minWaitingTime;
  final String? onlinePaymentMinAmount;
  final String? dispatchMessage;
  final String? fixedDeliveryCharge;
  final String? updated_at;
  final String? update_source;
  final String? update_device;
  final String? update_device_id;
  final String? update_details;
  final List<StoreFixedDeliveryLocationSettings>? FixedDeliveryLocationList;

  StoreDeliverySettingsInfo({
    this.id,
    this.shopId,
    this.shopPostcode,
    this.currencyType,
    this.takeAway,
    this.homeDelivery,
    this.shopOpen_temp_off,
    this.takeAway_temp_off,
    this.homeDelivery_temp_off,
    this.discountTakeAway,
    this.minAmtForTakAwayDiscnt,
    this.deliveryMinAmount,
    this.deliveryMinAmountType,
    this.discountHomeDelivery,
    this.minAmtForHomDelvryDiscnt,
    this.distanceType,
    this.freeDelivery,
    this.freeDeliveryRadius,
    this.freeDeliveryMinOrder,
    this.deliveryChargeType,
    this.minDeliveryCharge,
    this.ratePerMile,
    this.maxDeliveryRadius,
    this.preOrder,
    this.preOrderBefore,
    this.minWaitingTime,
    this.onlinePaymentMinAmount,
    this.dispatchMessage,
    this.fixedDeliveryCharge,
    this.updated_at,
    this.update_source,
    this.update_device,
    this.update_device_id,
    this.update_details,
    this.FixedDeliveryLocationList,
  });

  StoreDeliverySettingsInfo copyWith({
    String? id,
    String? shopId,
    String? shopPostcode,
    String? currencyType,
    String? takeAway,
    String? homeDelivery,
    String? shopOpen_temp_off,
    String? takeAway_temp_off,
    String? homeDelivery_temp_off,
    String? discountTakeAway,
    String? minAmtForTakAwayDiscnt,
    String? deliveryMinAmount,
    String? deliveryMinAmountType,
    String? discountHomeDelivery,
    String? minAmtForHomDelvryDiscnt,
    String? distanceType,
    String? freeDelivery,
    String? freeDeliveryRadius,
    String? freeDeliveryMinOrder,
    String? deliveryChargeType,
    String? minDeliveryCharge,
    String? ratePerMile,
    String? maxDeliveryRadius,
    String? preOrder,
    String? preOrderBefore,
    String? minWaitingTime,
    String? onlinePaymentMinAmount,
    String? dispatchMessage,
    String? fixedDeliveryCharge,
    String? updated_at,
    String? update_source,
    String? update_device,
    String? update_device_id,
    String? update_details,
    List<StoreFixedDeliveryLocationSettings>? FixedDeliveryLocationList,
  }) {
    return StoreDeliverySettingsInfo(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      shopPostcode: shopPostcode ?? this.shopPostcode,
      currencyType: currencyType ?? this.currencyType,
      takeAway: takeAway ?? this.takeAway,
      homeDelivery: homeDelivery ?? this.homeDelivery,
      shopOpen_temp_off: shopOpen_temp_off ?? this.shopOpen_temp_off,
      takeAway_temp_off: takeAway_temp_off ?? this.takeAway_temp_off,
      homeDelivery_temp_off:
          homeDelivery_temp_off ?? this.homeDelivery_temp_off,
      discountTakeAway: discountTakeAway ?? this.discountTakeAway,
      minAmtForTakAwayDiscnt:
          minAmtForTakAwayDiscnt ?? this.minAmtForTakAwayDiscnt,
      deliveryMinAmount: deliveryMinAmount ?? this.deliveryMinAmount,
      deliveryMinAmountType:
          deliveryMinAmountType ?? this.deliveryMinAmountType,
      discountHomeDelivery: discountHomeDelivery ?? this.discountHomeDelivery,
      minAmtForHomDelvryDiscnt:
          minAmtForHomDelvryDiscnt ?? this.minAmtForHomDelvryDiscnt,
      distanceType: distanceType ?? this.distanceType,
      freeDelivery: freeDelivery ?? this.freeDelivery,
      freeDeliveryRadius: freeDeliveryRadius ?? this.freeDeliveryRadius,
      freeDeliveryMinOrder: freeDeliveryMinOrder ?? this.freeDeliveryMinOrder,
      deliveryChargeType: deliveryChargeType ?? this.deliveryChargeType,
      minDeliveryCharge: minDeliveryCharge ?? this.minDeliveryCharge,
      ratePerMile: ratePerMile ?? this.ratePerMile,
      maxDeliveryRadius: maxDeliveryRadius ?? this.maxDeliveryRadius,
      preOrder: preOrder ?? this.preOrder,
      preOrderBefore: preOrderBefore ?? this.preOrderBefore,
      minWaitingTime: minWaitingTime ?? this.minWaitingTime,
      onlinePaymentMinAmount:
          onlinePaymentMinAmount ?? this.onlinePaymentMinAmount,
      dispatchMessage: dispatchMessage ?? this.dispatchMessage,
      fixedDeliveryCharge: fixedDeliveryCharge ?? this.fixedDeliveryCharge,
      updated_at: updated_at ?? this.updated_at,
      update_source: update_source ?? this.update_source,
      update_device: update_device ?? this.update_device,
      update_device_id: update_device_id ?? this.update_device_id,
      update_details: update_details ?? this.update_details,
      FixedDeliveryLocationList:
          FixedDeliveryLocationList ?? this.FixedDeliveryLocationList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'shopId': shopId,
      'shopPostcode': shopPostcode,
      'currencyType': currencyType,
      'takeAway': takeAway,
      'homeDelivery': homeDelivery,
      'shopOpen_temp_off': shopOpen_temp_off,
      'takeAway_temp_off': takeAway_temp_off,
      'homeDelivery_temp_off': homeDelivery_temp_off,
      'discountTakeAway': discountTakeAway,
      'minAmtForTakAwayDiscnt': minAmtForTakAwayDiscnt,
      'deliveryMinAmount': deliveryMinAmount,
      'deliveryMinAmountType': deliveryMinAmountType,
      'discountHomeDelivery': discountHomeDelivery,
      'minAmtForHomDelvryDiscnt': minAmtForHomDelvryDiscnt,
      'distanceType': distanceType,
      'freeDelivery': freeDelivery,
      'freeDeliveryRadius': freeDeliveryRadius,
      'freeDeliveryMinOrder': freeDeliveryMinOrder,
      'deliveryChargeType': deliveryChargeType,
      'minDeliveryCharge': minDeliveryCharge,
      'ratePerMile': ratePerMile,
      'maxDeliveryRadius': maxDeliveryRadius,
      'preOrder': preOrder,
      'preOrderBefore': preOrderBefore,
      'minWaitingTime': minWaitingTime,
      'onlinePaymentMinAmount': onlinePaymentMinAmount,
      'dispatchMessage': dispatchMessage,
      'fixedDeliveryCharge': fixedDeliveryCharge,
      'updated_at': updated_at,
      'update_source': update_source,
      'update_device': update_device,
      'update_device_id': update_device_id,
      'update_details': update_details,
      'FixedDeliveryLocationList':
          FixedDeliveryLocationList?.map((x) => x.toMap()).toList(),
    };
  }

  factory StoreDeliverySettingsInfo.fromMap(Map<String, dynamic> map) {
    return StoreDeliverySettingsInfo(
      id: map['id'] != null ? map['id'] as String : null,
      shopId: map['shopId'] != null ? map['shopId'] as String : null,
      shopPostcode:
          map['shopPostcode'] != null ? map['shopPostcode'] as String : null,
      currencyType:
          map['currencyType'] != null ? map['currencyType'] as String : null,
      takeAway: map['takeAway'] != null ? map['takeAway'].toString() : null,
      homeDelivery:
          map['homeDelivery'] != null ? map['homeDelivery'].toString() : null,
      shopOpen_temp_off: map['shopOpen_temp_off'] != null
          ? map['shopOpen_temp_off'] as String
          : null,
      takeAway_temp_off: map['takeAway_temp_off'] != null
          ? map['takeAway_temp_off'] as String
          : null,
      homeDelivery_temp_off: map['homeDelivery_temp_off'] != null
          ? map['homeDelivery_temp_off'] as String
          : null,
      discountTakeAway: map['discountTakeAway'] != null
          ? map['discountTakeAway'] as String
          : null,
      minAmtForTakAwayDiscnt: map['minAmtForTakAwayDiscnt'] != null
          ? map['minAmtForTakAwayDiscnt'] as String
          : null,
      deliveryMinAmount: map['deliveryMinAmount'] != null
          ? map['deliveryMinAmount'] as String
          : null,
      deliveryMinAmountType: map['deliveryMinAmountType'] != null
          ? map['deliveryMinAmountType'] as String
          : null,
      discountHomeDelivery: map['discountHomeDelivery'] != null
          ? map['discountHomeDelivery'] as String
          : null,
      minAmtForHomDelvryDiscnt: map['minAmtForHomDelvryDiscnt'] != null
          ? map['minAmtForHomDelvryDiscnt'] as String
          : null,
      distanceType:
          map['distanceType'] != null ? map['distanceType'] as String : null,
      freeDelivery:
          map['freeDelivery'] != null ? map['freeDelivery'] as String : null,
      freeDeliveryRadius: map['freeDeliveryRadius'] != null
          ? map['freeDeliveryRadius'] as String
          : null,
      freeDeliveryMinOrder: map['freeDeliveryMinOrder'] != null
          ? map['freeDeliveryMinOrder'] as String
          : null,
      deliveryChargeType: map['deliveryChargeType'] != null
          ? map['deliveryChargeType'] as String
          : null,
      minDeliveryCharge: map['minDeliveryCharge'] != null
          ? map['minDeliveryCharge'] as String
          : null,
      ratePerMile:
          map['ratePerMile'] != null ? map['ratePerMile'] as String : null,
      maxDeliveryRadius: map['maxDeliveryRadius'] != null
          ? map['maxDeliveryRadius'] as String
          : null,
      preOrder: map['preOrder'] != null ? map['preOrder'] as String : null,
      preOrderBefore: map['preOrderBefore'] != null
          ? map['preOrderBefore'] as String
          : null,
      minWaitingTime: map['minWaitingTime'] != null
          ? map['minWaitingTime'] as String
          : null,
      onlinePaymentMinAmount: map['onlinePaymentMinAmount'] != null
          ? map['onlinePaymentMinAmount'] as String
          : null,
      dispatchMessage: map['dispatchMessage'] != null
          ? map['dispatchMessage'] as String
          : null,
      fixedDeliveryCharge: map['fixedDeliveryCharge'] != null
          ? map['fixedDeliveryCharge'] as String
          : null,
      updated_at:
          map['updated_at'] != null ? map['updated_at'] as String : null,
      update_source:
          map['update_source'] != null ? map['update_source'] as String : null,
      update_device:
          map['update_device'] != null ? map['update_device'] as String : null,
      update_device_id: map['update_device_id'] != null
          ? map['update_device_id'] as String
          : null,
      update_details: map['update_details'] != null
          ? map['update_details'] as String
          : null,
      FixedDeliveryLocationList: map['FixedDeliveryLocationList'] != null
          ? List<StoreFixedDeliveryLocationSettings>.from(
              (map['FixedDeliveryLocationList'] as List<dynamic>)
                  .map<StoreFixedDeliveryLocationSettings?>(
                (x) => StoreFixedDeliveryLocationSettings.fromMap(
                    x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreDeliverySettingsInfo.fromJson(String source) =>
      StoreDeliverySettingsInfo.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreDeliverySettingsInfo(id: $id, shopId: $shopId, shopPostcode: $shopPostcode, currencyType: $currencyType, takeAway: $takeAway, homeDelivery: $homeDelivery, shopOpen_temp_off: $shopOpen_temp_off, takeAway_temp_off: $takeAway_temp_off, homeDelivery_temp_off: $homeDelivery_temp_off, discountTakeAway: $discountTakeAway, minAmtForTakAwayDiscnt: $minAmtForTakAwayDiscnt, deliveryMinAmount: $deliveryMinAmount, deliveryMinAmountType: $deliveryMinAmountType, discountHomeDelivery: $discountHomeDelivery, minAmtForHomDelvryDiscnt: $minAmtForHomDelvryDiscnt, distanceType: $distanceType, freeDelivery: $freeDelivery, freeDeliveryRadius: $freeDeliveryRadius, freeDeliveryMinOrder: $freeDeliveryMinOrder, deliveryChargeType: $deliveryChargeType, minDeliveryCharge: $minDeliveryCharge, ratePerMile: $ratePerMile, maxDeliveryRadius: $maxDeliveryRadius, preOrder: $preOrder, preOrderBefore: $preOrderBefore, minWaitingTime: $minWaitingTime, onlinePaymentMinAmount: $onlinePaymentMinAmount, dispatchMessage: $dispatchMessage, fixedDeliveryCharge: $fixedDeliveryCharge, updated_at: $updated_at, update_source: $update_source, update_device: $update_device, update_device_id: $update_device_id, update_details: $update_details, FixedDeliveryLocationList: $FixedDeliveryLocationList)';
  }

  @override
  bool operator ==(covariant StoreDeliverySettingsInfo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.shopId == shopId &&
        other.shopPostcode == shopPostcode &&
        other.currencyType == currencyType &&
        other.takeAway == takeAway &&
        other.homeDelivery == homeDelivery &&
        other.shopOpen_temp_off == shopOpen_temp_off &&
        other.takeAway_temp_off == takeAway_temp_off &&
        other.homeDelivery_temp_off == homeDelivery_temp_off &&
        other.discountTakeAway == discountTakeAway &&
        other.minAmtForTakAwayDiscnt == minAmtForTakAwayDiscnt &&
        other.deliveryMinAmount == deliveryMinAmount &&
        other.deliveryMinAmountType == deliveryMinAmountType &&
        other.discountHomeDelivery == discountHomeDelivery &&
        other.minAmtForHomDelvryDiscnt == minAmtForHomDelvryDiscnt &&
        other.distanceType == distanceType &&
        other.freeDelivery == freeDelivery &&
        other.freeDeliveryRadius == freeDeliveryRadius &&
        other.freeDeliveryMinOrder == freeDeliveryMinOrder &&
        other.deliveryChargeType == deliveryChargeType &&
        other.minDeliveryCharge == minDeliveryCharge &&
        other.ratePerMile == ratePerMile &&
        other.maxDeliveryRadius == maxDeliveryRadius &&
        other.preOrder == preOrder &&
        other.preOrderBefore == preOrderBefore &&
        other.minWaitingTime == minWaitingTime &&
        other.onlinePaymentMinAmount == onlinePaymentMinAmount &&
        other.dispatchMessage == dispatchMessage &&
        other.fixedDeliveryCharge == fixedDeliveryCharge &&
        other.updated_at == updated_at &&
        other.update_source == update_source &&
        other.update_device == update_device &&
        other.update_device_id == update_device_id &&
        other.update_details == update_details &&
        listEquals(other.FixedDeliveryLocationList, FixedDeliveryLocationList);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        shopId.hashCode ^
        shopPostcode.hashCode ^
        currencyType.hashCode ^
        takeAway.hashCode ^
        homeDelivery.hashCode ^
        shopOpen_temp_off.hashCode ^
        takeAway_temp_off.hashCode ^
        homeDelivery_temp_off.hashCode ^
        discountTakeAway.hashCode ^
        minAmtForTakAwayDiscnt.hashCode ^
        deliveryMinAmount.hashCode ^
        deliveryMinAmountType.hashCode ^
        discountHomeDelivery.hashCode ^
        minAmtForHomDelvryDiscnt.hashCode ^
        distanceType.hashCode ^
        freeDelivery.hashCode ^
        freeDeliveryRadius.hashCode ^
        freeDeliveryMinOrder.hashCode ^
        deliveryChargeType.hashCode ^
        minDeliveryCharge.hashCode ^
        ratePerMile.hashCode ^
        maxDeliveryRadius.hashCode ^
        preOrder.hashCode ^
        preOrderBefore.hashCode ^
        minWaitingTime.hashCode ^
        onlinePaymentMinAmount.hashCode ^
        dispatchMessage.hashCode ^
        fixedDeliveryCharge.hashCode ^
        updated_at.hashCode ^
        update_source.hashCode ^
        update_device.hashCode ^
        update_device_id.hashCode ^
        update_details.hashCode ^
        FixedDeliveryLocationList.hashCode;
  }
}

class StoreTableReservationSettings {
  final String? haveAdvance;
  final String? advanceAmount;
  final String? advanceType;

  StoreTableReservationSettings({
    this.haveAdvance,
    this.advanceAmount,
    this.advanceType,
  });

  StoreTableReservationSettings copyWith({
    String? haveAdvance,
    String? advanceAmount,
    String? advanceType,
  }) {
    return StoreTableReservationSettings(
      haveAdvance: haveAdvance ?? this.haveAdvance,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      advanceType: advanceType ?? this.advanceType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'haveAdvance': haveAdvance,
      'advanceAmount': advanceAmount,
      'advanceType': advanceType,
    };
  }

  factory StoreTableReservationSettings.fromMap(Map<String, dynamic> map) {
    return StoreTableReservationSettings(
      haveAdvance:
          map['haveAdvance'] != null ? map['haveAdvance'] as String : null,
      advanceAmount:
          map['advanceAmount'] != null ? map['advanceAmount'] as String : null,
      advanceType:
          map['advanceType'] != null ? map['advanceType'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreTableReservationSettings.fromJson(String source) =>
      StoreTableReservationSettings.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StoreTableReservationSettings(haveAdvance: $haveAdvance, advanceAmount: $advanceAmount, advanceType: $advanceType)';

  @override
  bool operator ==(covariant StoreTableReservationSettings other) {
    if (identical(this, other)) return true;

    return other.haveAdvance == haveAdvance &&
        other.advanceAmount == advanceAmount &&
        other.advanceType == advanceType;
  }

  @override
  int get hashCode =>
      haveAdvance.hashCode ^ advanceAmount.hashCode ^ advanceType.hashCode;
}

class SmsAvailableCountriesData {
  final String? iso;
  final String? name;
  final String? code;
  SmsAvailableCountriesData({
    this.iso,
    this.name,
    this.code,
  });

  SmsAvailableCountriesData copyWith({
    String? iso,
    String? name,
    String? code,
  }) {
    return SmsAvailableCountriesData(
      iso: iso ?? this.iso,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'iso': iso,
      'name': name,
      'code': code,
    };
  }

  factory SmsAvailableCountriesData.fromMap(Map<String, dynamic> map) {
    return SmsAvailableCountriesData(
      iso: map['iso'] != null ? map['iso'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      code: map['code'] != null ? map['code'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SmsAvailableCountriesData.fromJson(String source) =>
      SmsAvailableCountriesData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SmsAvailableCountriesData(iso: $iso, name: $name, code: $code)';

  @override
  bool operator ==(covariant SmsAvailableCountriesData other) {
    if (identical(this, other)) return true;

    return other.iso == iso && other.name == name && other.code == code;
  }

  @override
  int get hashCode => iso.hashCode ^ name.hashCode ^ code.hashCode;
}

extension CountryFlag on SmsAvailableCountriesData {
  String get flagEmoji {
    final countryCode = iso?.toUpperCase() ?? "";

    if (countryCode.length != 2) return "";

    return countryCode.codeUnits
        .map((e) => String.fromCharCode(e + 127397))
        .join();
  }
}
