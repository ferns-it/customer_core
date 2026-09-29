// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SendOtpResponse {
 final bool? status;
 final String? message;
 final String? otpToken;
 final int? expiresIn;
 final String? purpose;
 final bool? smsSent;
  SendOtpResponse({
    this.status,
    this.message,
    this.otpToken,
    this.expiresIn,
    this.purpose,
    this.smsSent,
  });

  SendOtpResponse copyWith({
    bool? status,
    String? message,
    String? otpToken,
    int? expiresIn,
    String? purpose,
    bool? smsSent,
  }) {
    return SendOtpResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      otpToken: otpToken ?? this.otpToken,
      expiresIn: expiresIn ?? this.expiresIn,
      purpose: purpose ?? this.purpose,
      smsSent: smsSent ?? this.smsSent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'otpToken': otpToken,
      'expiresIn': expiresIn,
      'purpose': purpose,
      'smsSent': smsSent,
    };
  }

  factory SendOtpResponse.fromMap(Map<String, dynamic> map) {
    return SendOtpResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      message: map['message'] != null ? map['message'] as String : null,
      otpToken: map['otpToken'] != null ? map['otpToken'] as String : null,
      expiresIn: map['expiresIn'] != null ? map['expiresIn'] as int : null,
      purpose: map['purpose'] != null ? map['purpose'] as String : null,
      smsSent: map['smsSent'] != null ? map['smsSent'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendOtpResponse.fromJson(String source) => SendOtpResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SendOtpResponse(status: $status, message: $message, otpToken: $otpToken, expiresIn: $expiresIn, purpose: $purpose, smsSent: $smsSent)';
  }

  @override
  bool operator ==(covariant SendOtpResponse other) {
    if (identical(this, other)) return true;
  
    return 
      other.status == status &&
      other.message == message &&
      other.otpToken == otpToken &&
      other.expiresIn == expiresIn &&
      other.purpose == purpose &&
      other.smsSent == smsSent;
  }

  @override
  int get hashCode {
    return status.hashCode ^
      message.hashCode ^
      otpToken.hashCode ^
      expiresIn.hashCode ^
      purpose.hashCode ^
      smsSent.hashCode;
  }
}
