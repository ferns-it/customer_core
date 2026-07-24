// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BasicProfileDataModel {
  final String? userFirstName;
  final String? userLastName;
  final String? userMobile;
  BasicProfileDataModel({
    this.userFirstName,
    this.userLastName,
    this.userMobile,
  });

  BasicProfileDataModel copyWith({
    String? userFirstName,
    String? userLastName,
    String? userMobile,
  }) {
    return BasicProfileDataModel(
      userFirstName: userFirstName ?? this.userFirstName,
      userLastName: userLastName ?? this.userLastName,
      userMobile: userMobile ?? this.userMobile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'userMobile': userMobile,
    };
  }

  factory BasicProfileDataModel.fromMap(Map<String, dynamic> map) {
    return BasicProfileDataModel(
      userFirstName: map['userFirstName'] != null ? map['userFirstName'] as String : null,
      userLastName: map['userLastName'] != null ? map['userLastName'] as String : null,
      userMobile: map['userMobile'] != null ? map['userMobile'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BasicProfileDataModel.fromJson(String source) => BasicProfileDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BasicProfileDataModel(userFirstName: $userFirstName, userLastName: $userLastName, userMobile: $userMobile)';

  @override
  bool operator ==(covariant BasicProfileDataModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.userFirstName == userFirstName &&
      other.userLastName == userLastName &&
      other.userMobile == userMobile;
  }

  @override
  int get hashCode => userFirstName.hashCode ^ userLastName.hashCode ^ userMobile.hashCode;
}
