// To parse this JSON data, do
//
//     final societyMember = societyMemberFromJson(jsonString);

import 'dart:convert';

List<SocietyMember> societyMemberFromJson(String str) => List<SocietyMember>.from(json.decode(str).map((x) => SocietyMember.fromJson(x)));

String societyMemberToJson(List<SocietyMember> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SocietyMember {
  final String? id;
  final User? user;
  final String? profileType;
  final String? societyName;
  final String? societyBlock;
  final String? apartment;
  final String? ownership;
  final String? residentStatus;

  SocietyMember({
    this.id,
    this.user,
    this.profileType,
    this.societyName,
    this.societyBlock,
    this.apartment,
    this.ownership,
    this.residentStatus,
  });

  factory SocietyMember.fromJson(Map<String, dynamic> json) => SocietyMember(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profileType: json["profileType"],
    societyName: json["societyName"],
    societyBlock: json["societyBlock"],
    apartment: json["apartment"],
    ownership: json["ownership"],
    residentStatus: json["residentStatus"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "profileType": profileType,
    "societyName": societyName,
    "societyBlock": societyBlock,
    "apartment": apartment,
    "ownership": ownership,
    "residentStatus": residentStatus,
  };
}

class User {
  final String? id;
  final String? userName;
  final String? email;
  final String? profile;
  final String? role;
  final String? phoneNo;

  User({
    this.id,
    this.userName,
    this.email,
    this.profile,
    this.role,
    this.phoneNo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
    profile: json["profile"],
    role: json["role"],
    phoneNo: json["phoneNo"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "email": email,
    "profile": profile,
    "role": role,
    "phoneNo": phoneNo,
  };
}
