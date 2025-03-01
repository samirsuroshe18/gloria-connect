// To parse this JSON data, do
//
//     final preApprovedBanner = preApprovedBannerFromJson(jsonString);

import 'dart:convert';

PreApprovedBanner preApprovedBannerFromJson(String str) => PreApprovedBanner.fromJson(json.decode(str));

String preApprovedBannerToJson(PreApprovedBanner data) => json.encode(data.toJson());

class PreApprovedBanner {
  final String? id;
  final ApprovedBy? approvedBy;
  final String? name;
  final String? mobNumber;
  final String? profileImg;
  final String? companyName;
  final String? companyLogo;
  final String? serviceName;
  final String? serviceLogo;
  final String? vehicleNo;
  final String? profileType;
  final String? entryType;
  final String? societyName;
  final String? blockName;
  final String? apartment;
  final String? checkInCode;
  final DateTime? checkInCodeStartDate;
  final DateTime? checkInCodeExpiryDate;
  final DateTime? checkInCodeStart;
  final DateTime? checkInCodeExpiry;
  final bool? isPreApproved;

  PreApprovedBanner({
    this.id,
    this.approvedBy,
    this.name,
    this.mobNumber,
    this.profileImg,
    this.companyName,
    this.companyLogo,
    this.serviceName,
    this.serviceLogo,
    this.vehicleNo,
    this.profileType,
    this.entryType,
    this.societyName,
    this.blockName,
    this.apartment,
    this.checkInCode,
    this.checkInCodeStartDate,
    this.checkInCodeExpiryDate,
    this.checkInCodeStart,
    this.checkInCodeExpiry,
    this.isPreApproved,
  });

  factory PreApprovedBanner.fromJson(Map<String, dynamic> json) => PreApprovedBanner(
    id: json["_id"],
    approvedBy: json["approvedBy"] == null ? null : ApprovedBy.fromJson(json["approvedBy"]),
    name: json["name"],
    mobNumber: json["mobNumber"],
    profileImg: json["profileImg"],
    companyName: json["companyName"],
    companyLogo: json["companyLogo"],
    serviceName: json["serviceName"],
    serviceLogo: json["serviceLogo"],
    vehicleNo: json["vehicleNo"],
    profileType: json["profileType"],
    entryType: json["entryType"],
    societyName: json["societyName"],
    blockName: json["blockName"],
    apartment: json["apartment"],
    checkInCode: json["checkInCode"],
    checkInCodeStartDate: json["checkInCodeStartDate"] == null ? null : DateTime.parse(json["checkInCodeStartDate"]),
    checkInCodeExpiryDate: json["checkInCodeExpiryDate"] == null ? null : DateTime.parse(json["checkInCodeExpiryDate"]),
    checkInCodeStart: json["checkInCodeStart"] == null ? null : DateTime.parse(json["checkInCodeStart"]),
    checkInCodeExpiry: json["checkInCodeExpiry"] == null ? null : DateTime.parse(json["checkInCodeExpiry"]),
    isPreApproved: json["isPreApproved"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "approvedBy": approvedBy?.toJson(),
    "name": name,
    "mobNumber": mobNumber,
    "profileImg": profileImg,
    "companyName": companyName,
    "companyLogo": companyLogo,
    "serviceName": serviceName,
    "serviceLogo": serviceLogo,
    "vehicleNo": vehicleNo,
    "profileType": profileType,
    "entryType": entryType,
    "societyName": societyName,
    "blockName": blockName,
    "apartment": apartment,
    "checkInCode": checkInCode,
    "checkInCodeStartDate": checkInCodeStartDate?.toIso8601String(),
    "checkInCodeExpiryDate": checkInCodeExpiryDate?.toIso8601String(),
    "checkInCodeStart": checkInCodeStart?.toIso8601String(),
    "checkInCodeExpiry": checkInCodeExpiry?.toIso8601String(),
    "isPreApproved": isPreApproved,
  };
}

class ApprovedBy {
  final String? id;
  final String? userName;
  final String? profile;
  final String? email;
  final String? role;
  final String? phoneNo;

  ApprovedBy({
    this.id,
    this.userName,
    this.profile,
    this.email,
    this.role,
    this.phoneNo,
  });

  factory ApprovedBy.fromJson(Map<String, dynamic> json) => ApprovedBy(
    id: json["_id"],
    userName: json["userName"],
    profile: json["profile"],
    email: json["email"],
    role: json["role"],
    phoneNo: json["phoneNo"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "profile": profile,
    "email": email,
    "role": role,
    "phoneNo": phoneNo,
  };
}
