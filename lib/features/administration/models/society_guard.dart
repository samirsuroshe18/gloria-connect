// To parse this JSON data, do
//
//     final societyGuard = societyGuardFromJson(jsonString);

import 'dart:convert';

List<SocietyGuard> societyGuardFromJson(String str) => List<SocietyGuard>.from(json.decode(str).map((x) => SocietyGuard.fromJson(x)));

String societyGuardToJson(List<SocietyGuard> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SocietyGuard {
  final String? id;
  final User? user;
  final String? profileType;
  final String? societyName;
  final String? residentStatus;

  SocietyGuard({
    this.id,
    this.user,
    this.profileType,
    this.societyName,
    this.residentStatus,
  });

  factory SocietyGuard.fromJson(Map<String, dynamic> json) => SocietyGuard(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profileType: json["profileType"],
    societyName: json["societyName"],
    residentStatus: json["residentStatus"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "profileType": profileType,
    "societyName": societyName,
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
