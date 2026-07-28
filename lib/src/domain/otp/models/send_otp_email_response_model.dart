// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:core';

class SendOtpEmailResponseModel {
  final bool? status;
  final String? message;
  final String? otpToken;
  final int? expiresIn;
  final String? purpose;
  final String? otpType;
  final bool? emailSent;
  final String? otp;
  SendOtpEmailResponseModel({
    this.status,
    this.message,
    this.otpToken,
    this.expiresIn,
    this.purpose,
    this.otpType,
    this.emailSent,
    this.otp,
  });

  SendOtpEmailResponseModel copyWith({
    bool? status,
    String? message,
    String? otpToken,
    int? expiresIn,
    String? purpose,
    String? otpType,
    bool? emailSent,
    String? otp,
  }) {
    return SendOtpEmailResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      otpToken: otpToken ?? this.otpToken,
      expiresIn: expiresIn ?? this.expiresIn,
      purpose: purpose ?? this.purpose,
      otpType: otpType ?? this.otpType,
      emailSent: emailSent ?? this.emailSent,
      otp: otp ?? this.otp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'otpToken': otpToken,
      'expiresIn': expiresIn,
      'purpose': purpose,
      'otpType': otpType,
      'emailSent': emailSent,
      'otp': otp,
    };
  }

  factory SendOtpEmailResponseModel.fromMap(Map<String, dynamic> map) {
    return SendOtpEmailResponseModel(
      status: map['status'] != null ? map['status'] as bool : null,
      message: map['message'] != null ? map['message'] as String : null,
      otpToken: map['otpToken'] != null ? map['otpToken'] as String : null,
      expiresIn: map['expiresIn'] != null ? map['expiresIn'] as int : null,
      purpose: map['purpose'] != null ? map['purpose'] as String : null,
      otpType: map['otpType'] != null ? map['otpType'] as String : null,
      emailSent: map['emailSent'] != null ? map['emailSent'] as bool : null,
      otp: map['otp'] != null ? map['otp'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendOtpEmailResponseModel.fromJson(String source) =>
      SendOtpEmailResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SendOtpEmailResponseModel(status: $status, message: $message, otpToken: $otpToken, expiresIn: $expiresIn, purpose: $purpose, otpType: $otpType, emailSent: $emailSent, otp: $otp)';
  }

  @override
  bool operator ==(covariant SendOtpEmailResponseModel other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.message == message &&
        other.otpToken == otpToken &&
        other.expiresIn == expiresIn &&
        other.purpose == purpose &&
        other.otpType == otpType &&
        other.emailSent == emailSent &&
        other.otp == otp;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        otpToken.hashCode ^
        expiresIn.hashCode ^
        purpose.hashCode ^
        otpType.hashCode ^
        emailSent.hashCode ^
        otp.hashCode;
  }
}