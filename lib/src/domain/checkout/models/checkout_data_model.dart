// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CheckOutDataModel {
  final String? shopID;
  final String? discount;
  final String? amount;
  final String? deliveryType;
  final String? deliveryCharge;
  final String? couponCode;
  final String? couponType;
  final String? couponValue;
  final String? couponAmount;
  final String? paymentStatus;
  final String? paymentGatway;
  final String? transactionID;
  final String? approxDeliveryTime;
  final String? deliveryNotes;
  final String? deliveryLocation;
  final String? deliveryDate;
  final String? deliverySlot;
  final String? takeawayTime;
  final String? source;
  final String? isSingleVendor;
  final String? projectID;
  final String? postCode;

  final CheckOutCustomerDataModel? customer;
  CheckOutDataModel({
    this.shopID,
    this.discount,
    this.amount,
    this.deliveryType,
    this.deliveryCharge,
    this.couponCode,
    this.couponType,
    this.couponValue,
    this.couponAmount,
    this.paymentStatus,
    this.paymentGatway,
    this.transactionID,
    this.approxDeliveryTime,
    this.deliveryNotes,
    this.deliveryLocation,
    this.deliveryDate,
    this.deliverySlot,
    this.takeawayTime,
    this.source,
    this.customer,
    this.isSingleVendor,
    this.projectID,
    this.postCode,
  });

  CheckOutDataModel copyWith(
      {String? shopID,
      String? discount,
      String? amount,
      String? deliveryType,
      String? deliveryCharge,
      String? couponCode,
      String? couponType,
      String? couponValue,
      String? couponAmount,
      String? paymentStatus,
      String? paymentGatway,
      String? transactionID,
      String? approxDeliveryTime,
      String? deliveryNotes,
      String? deliveryLocation,
      String? deliveryDate,
      String? deliverySlot,
      String? takeawayTime,
      String? source,
      String? postCode,
      CheckOutCustomerDataModel? customer,
      String? isSingleVendor,
      String? projectID}) {
    return CheckOutDataModel(
        shopID: shopID ?? this.shopID,
        discount: discount ?? this.discount,
        amount: amount ?? this.amount,
        deliveryType: deliveryType ?? this.deliveryType,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        couponCode: couponCode ?? this.couponCode,
        couponType: couponType ?? this.couponType,
        couponValue: couponValue ?? this.couponValue,
        couponAmount: couponAmount ?? this.couponAmount,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentGatway: paymentGatway ?? this.paymentGatway,
        transactionID: transactionID ?? this.transactionID,
        approxDeliveryTime: approxDeliveryTime ?? this.approxDeliveryTime,
        deliveryNotes: deliveryNotes ?? this.deliveryNotes,
        deliveryLocation: deliveryLocation ?? this.deliveryLocation,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        deliverySlot: deliverySlot ?? this.deliverySlot,
        takeawayTime: takeawayTime ?? this.takeawayTime,
        source: source ?? this.source,
        postCode: postCode ?? this.postCode,
        customer: customer ?? this.customer,
        isSingleVendor: isSingleVendor ?? this.isSingleVendor,
        projectID: projectID ?? this.projectID);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shopID': shopID,
      'discount': discount,
      'amount': amount,
      'deliveryType': deliveryType,
      'deliveryCharge': deliveryCharge,
      'couponCode': couponCode,
      'couponType': couponType,
      'couponValue': couponValue,
      'couponAmount': couponAmount,
      'paymentStatus': paymentStatus,
      'paymentGatway': paymentGatway,
      'transactionID': transactionID,
      'approxDeliveryTime': approxDeliveryTime,
      'deliveryNotes': deliveryNotes,
      'deliveryLocation': deliveryLocation,
      'deliveryDate': deliveryDate,
      'deliverySlot': deliverySlot,
      'takeawayTime': takeawayTime,
      'source': source,
      'postCode': postCode,
      'customer': customer?.toMap(),
      'isSingleVendor': isSingleVendor,
      'projectID': projectID
    };
  }

  factory CheckOutDataModel.fromMap(Map<String, dynamic> map) {
    return CheckOutDataModel(
        shopID: map['shopID'] != null ? map['shopID'] as String : null,
        discount: map['discount'] != null ? map['discount'] as String : null,
        amount: map['amount'] != null ? map['amount'] as String : null,
        deliveryType:
            map['deliveryType'] != null ? map['deliveryType'] as String : null,
        deliveryCharge: map['deliveryCharge'] != null
            ? map['deliveryCharge'] as String
            : null,
        couponCode:
            map['couponCode'] != null ? map['couponCode'] as String : null,
        couponType:
            map['couponType'] != null ? map['couponType'] as String : null,
        couponValue:
            map['couponValue'] != null ? map['couponValue'] as String : null,
        couponAmount:
            map['couponAmount'] != null ? map['couponAmount'] as String : null,
        paymentStatus: map['paymentStatus'] != null
            ? map['paymentStatus'] as String
            : null,
        paymentGatway: map['paymentGatway'] != null
            ? map['paymentGatway'] as String
            : null,
        transactionID: map['transactionID'] != null
            ? map['transactionID'] as String
            : null,
        approxDeliveryTime: map['approxDeliveryTime'] != null
            ? map['approxDeliveryTime'] as String
            : null,
        deliveryNotes: map['deliveryNotes'] != null
            ? map['deliveryNotes'] as String
            : null,
        deliveryLocation: map['deliveryLocation'] != null
            ? map['deliveryLocation'] as String
            : null,
        deliveryDate:
            map['deliveryDate'] != null ? map['deliveryDate'] as String : null,
        deliverySlot:
            map['deliverySlot'] != null ? map['deliverySlot'] as String : null,
        takeawayTime:
            map['takeawayTime'] != null ? map['takeawayTime'] as String : null,
        source: map['source'] != null ? map['source'] as String : null,
        postCode: map['postCode'] != null ? map['postCode'] as String : null,
        customer: map['customer'] != null
            ? CheckOutCustomerDataModel.fromMap(
                map['customer'] as Map<String, dynamic>)
            : null,
        isSingleVendor: map['isSingleVendor'] != null
            ? map['isSingleVendor'] as String
            : null,
        projectID:
            map['projectID'] != null ? map['projectID'] as String : null);
  }

  String toJson() => json.encode(toMap());

  factory CheckOutDataModel.fromJson(String source) =>
      CheckOutDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CheckOutDataModel(shopID: $shopID, discount: $discount, amount: $amount, deliveryType: $deliveryType, deliveryCharge: $deliveryCharge, couponCode: $couponCode, couponType: $couponType, couponValue: $couponValue, couponAmount: $couponAmount, paymentStatus: $paymentStatus, paymentGatway: $paymentGatway, transactionID: $transactionID, approxDeliveryTime: $approxDeliveryTime, deliveryNotes: $deliveryNotes, deliveryLocation: $deliveryLocation,deliveryDate : $deliveryDate,deliverySlot: $deliverySlot  takeawayTime: $takeawayTime, source: $source,postCode:$postCode, customer: $customer, isSingleVendor: $isSingleVendor, projectID: $projectID)';
  }

  @override
  bool operator ==(covariant CheckOutDataModel other) {
    if (identical(this, other)) return true;

    return other.shopID == shopID &&
        other.discount == discount &&
        other.amount == amount &&
        other.deliveryType == deliveryType &&
        other.deliveryCharge == deliveryCharge &&
        other.couponCode == couponCode &&
        other.couponType == couponType &&
        other.couponValue == couponValue &&
        other.couponAmount == couponAmount &&
        other.paymentStatus == paymentStatus &&
        other.paymentGatway == paymentGatway &&
        other.transactionID == transactionID &&
        other.approxDeliveryTime == approxDeliveryTime &&
        other.deliveryNotes == deliveryNotes &&
        other.deliveryLocation == deliveryLocation &&
        other.deliveryDate == deliveryDate &&
        other.deliverySlot == deliverySlot &&
        other.takeawayTime == takeawayTime &&
        other.source == source &&
        other.postCode == postCode &&
        other.customer == customer &&
        other.isSingleVendor == isSingleVendor &&
        other.projectID == projectID;
  }

  @override
  int get hashCode {
    return shopID.hashCode ^
        discount.hashCode ^
        amount.hashCode ^
        deliveryType.hashCode ^
        deliveryCharge.hashCode ^
        couponCode.hashCode ^
        couponType.hashCode ^
        couponValue.hashCode ^
        couponAmount.hashCode ^
        paymentStatus.hashCode ^
        paymentGatway.hashCode ^
        transactionID.hashCode ^
        approxDeliveryTime.hashCode ^
        deliveryNotes.hashCode ^
        deliveryLocation.hashCode ^
        deliveryDate.hashCode ^
        deliverySlot.hashCode ^
        takeawayTime.hashCode ^
        source.hashCode ^
        postCode.hashCode ^
        customer.hashCode ^
        isSingleVendor.hashCode ^
        projectID.hashCode;
  }
}

class CheckOutCustomerDataModel {
  final String? customerName;
  final String? line1;
  final String? line2;
  final String? town;
  final String? postcode;
  final String? county;
  final String? landmark;
  final String? email;
  final String? phone;
  CheckOutCustomerDataModel({
    this.customerName,
    this.line1,
    this.line2,
    this.town,
    this.postcode,
    this.county,
    this.landmark,
    this.email,
    this.phone,
  });

  CheckOutCustomerDataModel copyWith({
    String? customerName,
    String? line1,
    String? line2,
    String? town,
    String? postcode,
    String? county,
    String? landmark,
    String? email,
    String? phone,
  }) {
    return CheckOutCustomerDataModel(
      customerName: customerName ?? this.customerName,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      town: town ?? this.town,
      postcode: postcode ?? this.postcode,
      county: county ?? this.county,
      landmark: landmark ?? this.landmark,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerName': customerName,
      'line1': line1,
      'line2': line2,
      'town': town,
      'postcode': postcode,
      'county': county,
      'landmark': landmark,
      'email': email,
      'phone': phone,
    };
  }

  factory CheckOutCustomerDataModel.fromMap(Map<String, dynamic> map) {
    return CheckOutCustomerDataModel(
      customerName:
          map['customerName'] != null ? map['customerName'] as String : null,
      line1: map['line1'] != null ? map['line1'] as String : null,
      line2: map['line2'] != null ? map['line2'] as String : null,
      town: map['town'] != null ? map['town'] as String : null,
      postcode: map['postcode'] != null ? map['postcode'] as String : null,
      county: map['county'] != null ? map['county'] as String : null,
      landmark: map['landmark'] != null ? map['landmark'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckOutCustomerDataModel.fromJson(String source) =>
      CheckOutCustomerDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CheckOutCustomerDataModel(customerName: $customerName, line1: $line1, line2: $line2, town: $town, postcode: $postcode, county: $county, landmark: $landmark, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(covariant CheckOutCustomerDataModel other) {
    if (identical(this, other)) return true;

    return other.customerName == customerName &&
        other.line1 == line1 &&
        other.line2 == line2 &&
        other.town == town &&
        other.postcode == postcode &&
        other.county == county &&
        other.landmark == landmark &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return customerName.hashCode ^
        line1.hashCode ^
        line2.hashCode ^
        town.hashCode ^
        postcode.hashCode ^
        county.hashCode ^
        landmark.hashCode ^
        email.hashCode ^
        phone.hashCode;
  }
}
