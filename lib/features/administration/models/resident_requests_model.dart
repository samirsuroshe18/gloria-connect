// To parse this JSON data, do
//
//     final residentRequestsModel = residentRequestsModelFromJson(jsonString);

import 'dart:convert';

List<ResidentRequestsModel> residentRequestsModelFromJson(String str) => List<ResidentRequestsModel>.from(json.decode(str).map((x) => ResidentRequestsModel.fromJson(x)));

String residentRequestsModelToJson(List<ResidentRequestsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResidentRequestsModel {
  final String? id;
  final User? user;
  final String? profileType;
  final String? societyName;
  final String? societyBlock;
  final String? apartment;
  final String? ownership;
  final String? residentStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? tenantAgreement;
  final String? ownershipDocument;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ResidentRequestsModel({
    this.id,
    this.user,
    this.profileType,
    this.societyName,
    this.societyBlock,
    this.apartment,
    this.ownership,
    this.residentStatus,
    this.startDate,
    this.endDate,
    this.tenantAgreement,
    this.ownershipDocument,
    this.createdAt,
    this.updatedAt,
  });

  factory ResidentRequestsModel.fromJson(Map<String, dynamic> json) => ResidentRequestsModel(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profileType: json["profileType"],
    societyName: json["societyName"],
    societyBlock: json["societyBlock"],
    apartment: json["apartment"],
    ownership: json["ownership"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]).toLocal(),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]).toLocal(),
    tenantAgreement: json["tenantAgreement"],
    ownershipDocument: json["ownershipDocument"],
    residentStatus: json["residentStatus"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).toLocal(),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]).toLocal(),
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
    "startDate": startDate,
    "endDate": endDate,
    "tenantAgreement": tenantAgreement,
    "ownershipDocument": ownershipDocument,
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
