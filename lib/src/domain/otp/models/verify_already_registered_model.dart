// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VerifyAlreadyRegisteredModel {
  final bool? status;
  final String? key;
  final String? foodpageStatus;
  final String? message;
  VerifyAlreadyRegisteredModel({
    this.status,
    this.key,
    this.foodpageStatus,
    this.message,
  });

  VerifyAlreadyRegisteredModel copyWith({
    bool? status,
    String? key,
    String? foodpageStatus,
    String? message,
  }) {
    return VerifyAlreadyRegisteredModel(
      status: status ?? this.status,
      key: key ?? this.key,
      foodpageStatus: foodpageStatus ?? this.foodpageStatus,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'key': key,
      'foodpageStatus': foodpageStatus,
      'message': message,
    };
  }

  factory VerifyAlreadyRegisteredModel.fromMap(Map<String, dynamic> map) {
    return VerifyAlreadyRegisteredModel(
      status: map['status'] != null ? map['status'] as bool : null,
      key: map['key'] != null ? map['key'] as String : null,
      foodpageStatus: map['foodpageStatus'] != null
          ? map['foodpageStatus'] as String
          : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyAlreadyRegisteredModel.fromJson(String source) =>
      VerifyAlreadyRegisteredModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VerifyAlreadyRegisteredModel(status: $status, key: $key, foodpageStatus: $foodpageStatus, message: $message)';
  }

  @override
  bool operator ==(covariant VerifyAlreadyRegisteredModel other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.key == key &&
        other.foodpageStatus == foodpageStatus &&
        other.message == message;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        key.hashCode ^
        foodpageStatus.hashCode ^
        message.hashCode;
  }

  bool get isPartialUser => key == "Partial_User";
  bool get shouldShowLinkDialog =>
      key == "Partial_User" &&
      foodpageStatus ==
          "Email Available But Mobile Number Already Verified And Registered with Another User";
}
