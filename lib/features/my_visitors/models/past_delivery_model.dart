// To parse this JSON data, do
//
//     final pastDeliveryModel = pastDeliveryModelFromJson(jsonString);

import 'dart:convert';

PastDeliveryModel pastDeliveryModelFromJson(String str) => PastDeliveryModel.fromJson(json.decode(str));

String pastDeliveryModelToJson(PastDeliveryModel data) => json.encode(data.toJson());

class PastDeliveryModel {
  final List<Entry>? entries;
  final Pagination? pagination;

  PastDeliveryModel({
    this.entries,
    this.pagination,
  });

  factory PastDeliveryModel.fromJson(Map<String, dynamic> json) => PastDeliveryModel(
    entries: json["entries"] == null ? [] : List<Entry>.from(json["entries"]!.map((x) => Entry.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "entries": entries == null ? [] : List<dynamic>.from(entries!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Entry {
  final String? id;
  final String? name;
  final String? mobNumber;
  final String? profileImg;
  final String? companyName;
  final String? companyLogo;
  final String? serviceName;
  final String? serviceLogo;
  final String? accompanyingGuest;
  final VehicleDetails? vehicleDetails;
  final String? entryType;
  final GuardStatus? guardStatus;
  final DateTime? entryTime;
  final DateTime? exitTime;
  final int? notificationId;
  final bool? hasExited;
  final SocietyDetails? societyDetails;
  final AllowedByClass? approvedBy;
  final AllowedByClass? allowedBy;
  final String? profileType;
  final String? societyName;
  final String? blockName;
  final String? apartment;
  final String? gateName;
  final GatepassAptDetails? gatepassAptDetails;
  final String? source;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Entry({
    this.id,
    this.name,
    this.mobNumber,
    this.profileImg,
    this.companyName,
    this.companyLogo,
    this.serviceName,
    this.serviceLogo,
    this.accompanyingGuest,
    this.vehicleDetails,
    this.entryType,
    this.guardStatus,
    this.entryTime,
    this.exitTime,
    this.notificationId,
    this.hasExited,
    this.societyDetails,
    this.approvedBy,
    this.allowedBy,
    this.profileType,
    this.societyName,
    this.blockName,
    this.apartment,
    this.gateName,
    this.gatepassAptDetails,
    this.source,
    this.createdAt,
    this.updatedAt,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    id: json["_id"],
    name: json["name"],
    mobNumber: json["mobNumber"],
    profileImg: json["profileImg"],
    companyName: json["companyName"],
    companyLogo: json["companyLogo"],
    serviceName: json["serviceName"],
    serviceLogo: json["serviceLogo"],
    accompanyingGuest: json["accompanyingGuest"],
    vehicleDetails: json["vehicleDetails"] == null
        ? null
        : VehicleDetails.fromJson(json["vehicleDetails"]),
    entryType: json["entryType"],
    guardStatus: json["guardStatus"] == null
        ? null
        : GuardStatus.fromJson(json["guardStatus"]),
    entryTime: json["entryTime"] == null
        ? null
        : DateTime.parse(json["entryTime"]).toLocal(),
    exitTime: json["exitTime"] == null
        ? null
        : DateTime.parse(json["exitTime"]).toLocal(),
    notificationId: json["notificationId"],
    hasExited: json["hasExited"],
    societyDetails: json["societyDetails"] == null
        ? null
        : SocietyDetails.fromJson(json["societyDetails"]),
    approvedBy: json["approvedBy"] == null
        ? null
        : AllowedByClass.fromJson(json["approvedBy"]),
    allowedBy: json["allowedBy"] == null
        ? null
        : AllowedByClass.fromJson(json["allowedBy"]),
    profileType: json["profileType"],
    societyName: json["societyName"],
    blockName: json["blockName"],
    apartment: json["apartment"],
    gateName: json["gateName"],
    gatepassAptDetails: json["gatepassAptDetails"] == null ? null : GatepassAptDetails.fromJson(json["gatepassAptDetails"]),
    source: json["source"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "mobNumber": mobNumber,
    "profileImg": profileImg,
    "companyName": companyName,
    "companyLogo": companyLogo,
    "serviceName": serviceName,
    "serviceLogo": serviceLogo,
    "accompanyingGuest": accompanyingGuest,
    "vehicleDetails": vehicleDetails?.toJson(),
    "entryType": entryType,
    "guardStatus": guardStatus?.toJson(),
    "entryTime": entryTime?.toIso8601String(),
    "exitTime": exitTime?.toIso8601String(),
    "notificationId": notificationId,
    "hasExited": hasExited,
    "societyDetails": societyDetails?.toJson(),
    "approvedBy": approvedBy?.toJson(),
    "allowedBy": allowedBy?.toJson(),
    "profileType": profileType,
    "societyName": societyName,
    "blockName": blockName,
    "apartment": apartment,
    "gateName": gateName,
    "gatepassAptDetails": gatepassAptDetails?.toJson(),
    "source": source,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class GatepassAptDetails {
  final String? societyName;
  final List<GatepassAptDetailsSocietyApartment>? societyApartments;
  final String? id;

  GatepassAptDetails({
    this.societyName,
    this.societyApartments,
    this.id,
  });

  factory GatepassAptDetails.fromJson(Map<String, dynamic> json) => GatepassAptDetails(
    societyName: json["societyName"],
    societyApartments: json["societyApartments"] == null ? [] : List<GatepassAptDetailsSocietyApartment>.from(json["societyApartments"]!.map((x) => GatepassAptDetailsSocietyApartment.fromJson(x))),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "societyName": societyName,
    "societyApartments": societyApartments == null ? [] : List<dynamic>.from(societyApartments!.map((x) => x.toJson())),
    "_id": id,
  };
}

class GatepassAptDetailsSocietyApartment {
  final String? societyBlock;
  final String? apartment;
  final String? id;

  GatepassAptDetailsSocietyApartment({
    this.societyBlock,
    this.apartment,
    this.id,
  });

  factory GatepassAptDetailsSocietyApartment.fromJson(Map<String, dynamic> json) => GatepassAptDetailsSocietyApartment(
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

class AllowedByClass {
  final String? status;
  final User? user;

  AllowedByClass({
    this.status,
    this.user,
  });

  factory AllowedByClass.fromJson(Map<String, dynamic> json) => AllowedByClass(
    status: json["status"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user?.toJson(),
  };
}

class User {
  final String? id;
  final String? userName;
  final String? email;
  final String? role;
  final String? phoneNo;
  final String? profile;

  User({
    this.id,
    this.userName,
    this.email,
    this.role,
    this.phoneNo,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
    role: json["role"],
    phoneNo: json["phoneNo"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "email": email,
    "role": role,
    "phoneNo": phoneNo,
    "profile": profile,
  };
}

class GuardStatus {
  final User? guard;
  final String? status;

  GuardStatus({
    this.guard,
    this.status,
  });

  factory GuardStatus.fromJson(Map<String, dynamic> json) => GuardStatus(
    guard: json["guard"] == null ? null : User.fromJson(json["guard"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "guard": guard?.toJson(),
    "status": status,
  };
}

class SocietyDetails {
  final String? societyName;
  final String? societyGates;
  final List<SocietyApartment>? societyApartments;

  SocietyDetails({
    this.societyName,
    this.societyGates,
    this.societyApartments,
  });

  factory SocietyDetails.fromJson(Map<String, dynamic> json) => SocietyDetails(
    societyName: json["societyName"],
    societyGates: json["societyGates"],
    societyApartments: json["societyApartments"] == null
        ? []
        : List<SocietyApartment>.from(json["societyApartments"]!
        .map((x) => SocietyApartment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "societyName": societyName,
    "societyGates": societyGates,
    "societyApartments": societyApartments == null
        ? []
        : List<dynamic>.from(societyApartments!.map((x) => x.toJson())),
  };
}

class SocietyApartment {
  final String? societyBlock;
  final String? apartment;
  final EntryStatus? entryStatus;
  final List<Member>? members;
  final String? id;

  SocietyApartment({
    this.societyBlock,
    this.apartment,
    this.entryStatus,
    this.members,
    this.id,
  });

  factory SocietyApartment.fromJson(Map<String, dynamic> json) =>
      SocietyApartment(
        societyBlock: json["societyBlock"],
        apartment: json["apartment"],
        entryStatus: json["entryStatus"] == null
            ? null
            : EntryStatus.fromJson(json["entryStatus"]),
        members: json["members"] == null
            ? []
            : List<Member>.from(
            json["members"]!.map((x) => Member.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
    "societyBlock": societyBlock,
    "apartment": apartment,
    "entryStatus": entryStatus?.toJson(),
    "members": members == null
        ? []
        : List<dynamic>.from(members!.map((x) => x.toJson())),
    "_id": id,
  };
}

class EntryStatus {
  final String? status;
  final RejectedByClass? approvedBy;
  final RejectedByClass? rejectedBy;

  EntryStatus({
    this.status,
    this.approvedBy,
    this.rejectedBy,
  });

  factory EntryStatus.fromJson(Map<String, dynamic> json) => EntryStatus(
    status: json["status"],
    approvedBy: json["approvedBy"] == null
        ? null
        : RejectedByClass.fromJson(json["approvedBy"]),
    rejectedBy: json["rejectedBy"] == null
        ? null
        : RejectedByClass.fromJson(json["rejectedBy"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "approvedBy": approvedBy?.toJson(),
    "rejectedBy": rejectedBy?.toJson(),
  };
}

class RejectedByClass {
  final String? id;
  final String? userName;
  final String? email;

  RejectedByClass({
    this.id,
    this.userName,
    this.email,
  });

  factory RejectedByClass.fromJson(Map<String, dynamic> json) =>
      RejectedByClass(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "email": email,
  };
}

class Member {
  final String? email;
  final String? userName;
  final String? phoneNo;
  final String? profile;

  Member({
    this.email,
    this.userName,
    this.phoneNo,
    this.profile,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    email: json["email"],
    userName: json["userName"],
    phoneNo: json["phoneNo"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "userName": userName,
    "phoneNo": phoneNo,
    "profile": profile,
  };
}

class VehicleDetails {
  final String? vehicleType;
  final String? vehicleNumber;
  final String? id;

  VehicleDetails({
    this.vehicleType,
    this.vehicleNumber,
    this.id,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) => VehicleDetails(
    vehicleType: json["vehicleType"],
    vehicleNumber: json["vehicleNumber"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleType": vehicleType,
    "vehicleNumber": vehicleNumber,
    "_id": id,
  };
}

class Pagination {
  final int? totalEntries;
  final int? entriesPerPage;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;

  Pagination({
    this.totalEntries,
    this.entriesPerPage,
    this.currentPage,
    this.totalPages,
    this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalEntries: json["totalEntries"],
    entriesPerPage: json["entriesPerPage"],
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    hasMore: json["hasMore"],
  );

  Map<String, dynamic> toJson() => {
    "totalEntries": totalEntries,
    "entriesPerPage": entriesPerPage,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "hasMore": hasMore,
  };
}
