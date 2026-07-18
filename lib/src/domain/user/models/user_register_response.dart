// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'user.dart';

class UserRegisterResponse {
  final String message;
  final String activationCode;
  final String token;
  final int? expireAt;
  final User user;
  UserRegisterResponse({
    required this.message,
    required this.activationCode,
    required this.token,
    this.expireAt,
    required this.user,
  });

  UserRegisterResponse copyWith({
    String? message,
    String? activationCode,
    String? token,
    int? expireAt,
    User? user,
  }) {
    return UserRegisterResponse(
      message: message ?? this.message,
      activationCode: activationCode ?? this.activationCode,
      token: token ?? this.token,
      expireAt: expireAt ?? this.expireAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'activationCode': activationCode,
      'token': token,
      'expireAt': expireAt,
      'user': user.toMap(),
    };
  }

  factory UserRegisterResponse.fromMap(Map<String, dynamic> map) {
    return UserRegisterResponse(
      message: map['message']?.toString() ?? '',
      activationCode: map['activationCode']?.toString() ?? '',
      token: map['token']?.toString() ?? '',
      expireAt: map['expireAt'] == null
          ? null
          : (map['expireAt'] is int
              ? map['expireAt'] as int
              : int.tryParse(map['expireAt'].toString())),
      user: map['user'] is Map
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : User(
              userID: null,
              shopID: null,
              userFirstName: null,
              userLastName: null,
              userAddress: null,
              userPostCode: null,
              userMobile: null,
              userEmail: null,
              userPassword: null,
              userStatus: null,
              addedTime: null,
              userActivationCode: null,
              isMobileVerified:null,
              isEmailVerified:null
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRegisterResponse.fromJson(String source) =>
      UserRegisterResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserLoginResponse(message: $message, activationCode: $activationCode, token: $token, expireAt: $expireAt, user: $user)';
  }

  @override
  bool operator ==(covariant UserRegisterResponse other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.activationCode == activationCode &&
        other.token == token &&
        other.expireAt == expireAt &&
        other.user == user;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        activationCode.hashCode ^
        token.hashCode ^
        expireAt.hashCode ^
        user.hashCode;
  }
}