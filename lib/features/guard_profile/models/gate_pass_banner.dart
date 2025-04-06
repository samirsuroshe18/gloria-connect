// To parse this JSON data, do
//
//     final gatePassBanner = gatePassBannerFromJson(jsonString);

import 'dart:convert';

GatePassBanner gatePassBannerFromJson(String str) => GatePassBanner.fromJson(json.decode(str));

String gatePassBannerToJson(GatePassBanner data) => json.encode(data.toJson());

class GatePassBanner {
  final String? id;
  final ApprovedBy? approvedBy;
  final String? name;
  final String? mobNumber;
  final String? profileImg;
  final String? serviceName;
  final String? serviceLogo;
  final String? societyName;
  final String? entryType;
  final GatepassAptDetails? gatepassAptDetails;
  final String? addressProof;
  final String? address;
  final String? gender;
  final String? checkInCode;
  final DateTime? checkInCodeStartDate;
  final DateTime? checkInCodeExpiryDate;
  final DateTime? checkInCodeStart;
  final DateTime? checkInCodeExpiry;

  GatePassBanner({
    this.id,
    this.approvedBy,
    this.name,
    this.mobNumber,
    this.profileImg,
    this.serviceName,
    this.serviceLogo,
    this.societyName,
    this.entryType,
    this.gatepassAptDetails,
    this.addressProof,
    this.address,
    this.gender,
    this.checkInCode,
    this.checkInCodeStartDate,
    this.checkInCodeExpiryDate,
    this.checkInCodeStart,
    this.checkInCodeExpiry,
  });

  factory GatePassBanner.fromJson(Map<String, dynamic> json) => GatePassBanner(
    id: json["_id"],
    approvedBy: json["approvedBy"] == null ? null : ApprovedBy.fromJson(json["approvedBy"]),
    name: json["name"],
    mobNumber: json["mobNumber"],
    profileImg: json["profileImg"],
    serviceName: json["serviceName"],
    serviceLogo: json["serviceLogo"],
    societyName: json["societyName"],
    entryType: json["entryType"],
    gatepassAptDetails: json["gatepassAptDetails"] == null ? null : GatepassAptDetails.fromJson(json["gatepassAptDetails"]),
    addressProof: json["addressProof"],
    address: json["address"],
    gender: json["gender"],
    checkInCode: json["checkInCode"],
    checkInCodeStartDate: json["checkInCodeStartDate"] == null ? null : DateTime.parse(json["checkInCodeStartDate"]).toLocal(),
    checkInCodeExpiryDate: json["checkInCodeExpiryDate"] == null ? null : DateTime.parse(json["checkInCodeExpiryDate"]).toLocal(),
    checkInCodeStart: json["checkInCodeStart"] == null ? null : DateTime.parse(json["checkInCodeStart"]).toLocal(),
    checkInCodeExpiry: json["checkInCodeExpiry"] == null ? null : DateTime.parse(json["checkInCodeExpiry"]).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "approvedBy": approvedBy?.toJson(),
    "name": name,
    "mobNumber": mobNumber,
    "profileImg": profileImg,
    "serviceName": serviceName,
    "serviceLogo": serviceLogo,
    "societyName": societyName,
    "entryType": entryType,
    "gatepassAptDetails": gatepassAptDetails?.toJson(),
    "addressProof": addressProof,
    "address": address,
    "gender": gender,
    "checkInCode": checkInCode,
    "checkInCodeStartDate": checkInCodeStartDate?.toIso8601String(),
    "checkInCodeExpiryDate": checkInCodeExpiryDate?.toIso8601String(),
    "checkInCodeStart": checkInCodeStart?.toIso8601String(),
    "checkInCodeExpiry": checkInCodeExpiry?.toIso8601String(),
  };
}

class ApprovedBy {
  final String? id;
  final String? userName;
  final String? email;
  final String? profile;
  final String? role;
  final String? phoneNo;

  ApprovedBy({
    this.id,
    this.userName,
    this.email,
    this.profile,
    this.role,
    this.phoneNo,
  });

  factory ApprovedBy.fromJson(Map<String, dynamic> json) => ApprovedBy(
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

class GatepassAptDetails {
  final String? societyName;
  final List<SocietyApartment>? societyApartments;
  final String? id;

  GatepassAptDetails({
    this.societyName,
    this.societyApartments,
    this.id,
  });

  factory GatepassAptDetails.fromJson(Map<String, dynamic> json) => GatepassAptDetails(
    societyName: json["societyName"],
    societyApartments: json["societyApartments"] == null ? [] : List<SocietyApartment>.from(json["societyApartments"]!.map((x) => SocietyApartment.fromJson(x))),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "societyName": societyName,
    "societyApartments": societyApartments == null ? [] : List<dynamic>.from(societyApartments!.map((x) => x.toJson())),
    "_id": id,
  };
}

class SocietyApartment {
  final String? societyBlock;
  final String? apartment;
  final String? id;

  SocietyApartment({
    this.societyBlock,
    this.apartment,
    this.id,
  });

  factory SocietyApartment.fromJson(Map<String, dynamic> json) => SocietyApartment(
    societyBlock: json["societyBlock"],
    apartment: json["apartment"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "societyBlock": societyBlock,
    "apartment": apartment,
    "_id": id,
  };
}
