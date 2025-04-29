// To parse this JSON data, do
//
//     final guardInfoModel = guardInfoModelFromJson(jsonString);

import 'dart:convert';

GuardInfoModel guardInfoModelFromJson(String str) => GuardInfoModel.fromJson(json.decode(str));

String guardInfoModelToJson(GuardInfoModel data) => json.encode(data.toJson());

class GuardInfoModel {
  final String? id;
  final User? user;
  final String? societyName;
  final String? gateAssign;
  final String? checkInCode;

  GuardInfoModel({
    this.id,
    this.user,
    this.societyName,
    this.gateAssign,
    this.checkInCode,
  });

  factory GuardInfoModel.fromJson(Map<String, dynamic> json) => GuardInfoModel(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    societyName: json["societyName"],
    gateAssign: json["gateAssign"],
    checkInCode: json["checkInCode"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "societyName": societyName,
    "gateAssign": gateAssign,
    "checkInCode": checkInCode,
  };
}

class User {
  final String? id;
  final String? userName;
  final String? profile;

  User({
    this.id,
    this.userName,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    userName: json["userName"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "profile": profile,
  };
}
