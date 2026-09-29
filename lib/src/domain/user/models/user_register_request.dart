import 'dart:convert';

class UserRegisterRequest {
  final String shopID;
  final String userFirstName;
  final String userLastName;
  final String userPostCode;
  final String userMobile;
  final String userEmail;
  final String userPassword;
  final String countryCode;
  final UserAddress userAddress;
  final String? userMobileToken;
  final String? isEmailVerified;
  final String? mobileVerifiedLater;

  UserRegisterRequest({
    required this.shopID,
    required this.userFirstName,
    required this.userLastName,
    required this.userPostCode,
    required this.userMobile,
    required this.userEmail,
    required this.userPassword,
    required this.countryCode,
    required this.userAddress,
    required this.userMobileToken,
    required this.isEmailVerified,
    required this.mobileVerifiedLater,
  });

  UserRegisterRequest copyWith({
    String? shopID,
    String? userFirstName,
    String? userLastName,
    String? userPostCode,
    String? userMobile,
    String? userEmail,
    String? userPassword,
    String? countryCode,
    UserAddress? userAddress,
    String? userMobileToken,
    String? isEmailVerified,
    String? mobileVerifiedLater,
  }) {
    return UserRegisterRequest(
      shopID: shopID ?? this.shopID,
      userFirstName: userFirstName ?? this.userFirstName,
      userLastName: userLastName ?? this.userLastName,
      userPostCode: userPostCode ?? this.userPostCode,
      userMobile: userMobile ?? this.userMobile,
      userEmail: userEmail ?? this.userEmail,
      userPassword: userPassword ?? this.userPassword,
      countryCode: countryCode ?? this.countryCode,
      userAddress: userAddress ?? this.userAddress,
      userMobileToken: userMobileToken ?? this.userMobileToken,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      mobileVerifiedLater: mobileVerifiedLater ?? this.mobileVerifiedLater,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shopID': shopID,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'userPostCode': userPostCode,
      'userMobile': userMobile,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'countryCode': countryCode,
      'userAddress': userAddress.toMap(),
      'userMobileToken': userMobileToken,
      'isEmailVerified': isEmailVerified,
      'mobileVerifiedLater': mobileVerifiedLater,
    };
  }

  factory UserRegisterRequest.fromMap(Map<String, dynamic> map) {
    return UserRegisterRequest(
      shopID: map['shopID'] as String,
      userFirstName: map['userFirstName'] as String,
      userLastName: map['userLastName'] as String,
      userPostCode: map['userPostCode'] as String,
      userMobile: map['userMobile'] as String,
      userEmail: map['userEmail'] as String,
      userPassword: map['userPassword'] as String,
      countryCode: map['countryCode'] as String,
      userAddress:
          UserAddress.fromMap(map['userAddress'] as Map<String, dynamic>),
      userMobileToken: map['userMobileToken'] as String?,
      isEmailVerified: map['isEmailVerified'] as String?,
      mobileVerifiedLater: map['mobileVerifiedLater'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRegisterRequest.fromJson(String source) =>
      UserRegisterRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserRegisterRequest(shopID: $shopID, userFirstName: $userFirstName, userLastName: $userLastName, userPostCode: $userPostCode, userMobile: $userMobile, userEmail: $userEmail, userPassword: $userPassword, userAddress: $userAddress,userMobileToken: $userMobileToken,isEmailVerified:$isEmailVerified,mobileVerifiedLater:$mobileVerifiedLater)';
  }

  @override
  bool operator ==(covariant UserRegisterRequest other) {
    if (identical(this, other)) return true;

    return other.shopID == shopID &&
        other.userFirstName == userFirstName &&
        other.userLastName == userLastName &&
        other.userPostCode == userPostCode &&
        other.userMobile == userMobile &&
        other.userEmail == userEmail &&
        other.userPassword == userPassword &&
        other.userAddress == userAddress &&
        other.userMobileToken == userMobileToken &&
        other.isEmailVerified == isEmailVerified &&
        other.mobileVerifiedLater == mobileVerifiedLater;
  }

  @override
  int get hashCode {
    return shopID.hashCode ^
        userFirstName.hashCode ^
        userLastName.hashCode ^
        userPostCode.hashCode ^
        userMobile.hashCode ^
        userEmail.hashCode ^
        userPassword.hashCode ^
        userAddress.hashCode ^
        userMobileToken.hashCode ^
        isEmailVerified.hashCode ^
        mobileVerifiedLater.hashCode;
  }
}

class UserAddress {
  final String line1;
  final String line2;
  final String town;
  final String postalcode;
  final String county;
  final String landmark;

  UserAddress({
    required this.line1,
    required this.line2,
    required this.town,
    required this.postalcode,
    required this.county,
    required this.landmark,
  });

  UserAddress copyWith({
    String? line1,
    String? line2,
    String? town,
    String? postalcode,
    String? county,
    String? landmark,
  }) {
    return UserAddress(
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      town: town ?? this.town,
      postalcode: postalcode ?? this.postalcode,
      county: county ?? this.county,
      landmark: landmark ?? this.landmark,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'line1': line1,
      'line2': line2,
      'town': town,
      'postalcode': postalcode,
      'county': county,
      'landmark': landmark,
    };
  }

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    return UserAddress(
      line1: map['line1'] as String,
      line2: map['line2'] as String,
      town: map['town'] as String,
      postalcode: map['postalcode'] as String,
      county: map['county'] as String,
      landmark: map['landmark'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAddress.empty() => UserAddress(
      line1: "", line2: "", town: "", postalcode: "", county: "", landmark: "");

  factory UserAddress.fromJson(String source) =>
      UserAddress.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserAddress(line1: $line1, line2: $line2, town: $town, postalcode: $postalcode, county: $county, landmark: $landmark)';
  }

  @override
  bool operator ==(covariant UserAddress other) {
    if (identical(this, other)) return true;

    return other.line1 == line1 &&
        other.line2 == line2 &&
        other.town == town &&
        other.postalcode == postalcode &&
        other.county == county &&
        other.landmark == landmark;
  }

  @override
  int get hashCode {
    return line1.hashCode ^
        line2.hashCode ^
        town.hashCode ^
        postalcode.hashCode ^
        county.hashCode ^
        landmark.hashCode;
  }
}
