// To parse this JSON data, do
//
//     final guardRequestsModel = guardRequestsModelFromJson(jsonString);

import 'dart:convert';

List<GuardRequestsModel> guardRequestsModelFromJson(String str) => List<GuardRequestsModel>.from(json.decode(str).map((x) => GuardRequestsModel.fromJson(x)));

String guardRequestsModelToJson(List<GuardRequestsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GuardRequestsModel {
  final String? id;
  final User? user;
  final String? profileType;
  final String? societyName;
  final String? gateAssign;
  final String? guardStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GuardRequestsModel({
    this.id,
    this.user,
    this.profileType,
    this.societyName,
    this.gateAssign,
    this.guardStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory GuardRequestsModel.fromJson(Map<String, dynamic> json) => GuardRequestsModel(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profileType: json["profileType"],
    societyName: json["societyName"],
    gateAssign: json["gateAssign"],
    guardStatus: json["guardStatus"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).toLocal(),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "profileType": profileType,
    "societyName": societyName,
    "gateAssign": gateAssign,
    "guardStatus": guardStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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
