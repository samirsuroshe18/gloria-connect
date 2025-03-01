import 'dart:convert';

GetUserModel getUserModelFromJson(String str) => GetUserModel.fromJson(json.decode(str));

String getUserModelToJson(GetUserModel data) => json.encode(data.toJson());

class GetUserModel {
  final String? id;
  final String? profile;
  final String? userName;
  final String? email;
  final String? phoneNo;
  final String? role;
  final String? userType;
  final bool? isUserTypeVerified;
  final String? profileType;
  final String? societyName;
  final String? societyBlock;
  final String? apartment;
  final String? gateAssign;
  final String? checkInCode;
  final String? residentStatus;
  final String? guardStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GetUserModel({
    this.id,
    this.userName,
    this.email,
    this.profile,
    this.role,
    this.userType,
    this.isUserTypeVerified,
    this.createdAt,
    this.updatedAt,
    this.phoneNo,
    this.checkInCode,
    this.societyName,
    this.gateAssign,
    this.societyBlock,
    this.apartment,
    this.profileType,
    this.residentStatus,
    this.guardStatus,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
    id: json["_id"],
    profile: json["profile"],
    userName: json["userName"],
    email: json["email"],
    phoneNo: json["phoneNo"],
    role: json["role"],
    userType: json['userType'],
    isUserTypeVerified: json['isUserTypeVerified'],
    profileType: json["profileType"],
    societyName: json["societyName"],
    societyBlock: json["societyBlock"],
    apartment: json["apartment"],
    gateAssign: json["gateAssign"],
    checkInCode: json["checkInCode"],
    residentStatus: json["residentStatus"],
    guardStatus: json["guardStatus"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).toLocal(),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "profile": profile,
    "userName": userName,
    "email": email,
    "phoneNo": phoneNo,
    "role": role,
    "userType": userType,
    "isUserTypeVerified": isUserTypeVerified,
    "profileType": profileType,
    "societyName": societyName,
    "societyBlock": societyBlock,
    "apartment": apartment,
    "gateAssign": gateAssign,
    "checkInCode": checkInCode,
    "residentStatus": residentStatus,
    "guardStatus": guardStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
