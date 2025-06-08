import 'dart:convert';

GatePassModelResident gatePassModelFromJson(String str) => GatePassModelResident.fromJson(json.decode(str));

String gatePassModelToJson(GatePassModelResident data) => json.encode(data.toJson());

class GatePassModelResident {
  final List<GatePassBanner>? gatePassBanner;
  final Pagination? pagination;

  GatePassModelResident({
    this.gatePassBanner,
    this.pagination,
  });

  factory GatePassModelResident.fromJson(Map<String, dynamic> json) => GatePassModelResident(
    gatePassBanner: json["gatePassBanner"] == null ? [] : List<GatePassBanner>.from(json["gatePassBanner"]!.map((x) => GatePassBanner.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "gatePassBanner": gatePassBanner == null ? [] : List<dynamic>.from(gatePassBanner!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class GatePassBanner {
  final GuardStatus? guardStatus;
  final String? id;
  final ApprovedBy? approvedBy;
  final String? name;
  final String? mobNumber;
  final String? profileImg;
  final String? serviceName;
  final String? serviceLogo;
  final String? entryType;
  final String? societyName;
  final String? societyBlock;
  final String? apartment;
  final GatepassAptDetails? gatepassAptDetails;
  final String? addressProof;
  final String? address;
  final String? gender;
  final String? checkInCode;
  final DateTime? checkInCodeStartDate;
  final DateTime? checkInCodeExpiryDate;
  final DateTime? checkInCodeStart;
  final DateTime? checkInCodeExpiry;
  final bool? isPreApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  GatePassBanner({
    this.guardStatus,
    this.id,
    this.approvedBy,
    this.name,
    this.mobNumber,
    this.profileImg,
    this.serviceName,
    this.serviceLogo,
    this.entryType,
    this.societyName,
    this.societyBlock,
    this.apartment,
    this.gatepassAptDetails,
    this.addressProof,
    this.address,
    this.gender,
    this.checkInCode,
    this.checkInCodeStartDate,
    this.checkInCodeExpiryDate,
    this.checkInCodeStart,
    this.checkInCodeExpiry,
    this.isPreApproved,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GatePassBanner.fromJson(Map<String, dynamic> json) => GatePassBanner(
    guardStatus: json["guardStatus"] == null ? null : GuardStatus.fromJson(json["guardStatus"]),
    id: json["_id"],
    approvedBy: json["approvedBy"] == null ? null : ApprovedBy.fromJson(json["approvedBy"]),
    name: json["name"],
    mobNumber: json["mobNumber"],
    profileImg: json["profileImg"],
    serviceName: json["serviceName"],
    serviceLogo: json["serviceLogo"],
    entryType: json["entryType"],
    societyName: json["societyName"],
    societyBlock: json["societyBlock"],
    apartment: json["apartment"],
    gatepassAptDetails: json["gatepassAptDetails"] == null ? null : GatepassAptDetails.fromJson(json["gatepassAptDetails"]),
    addressProof: json["addressProof"],
    address: json["address"],
    gender: json["gender"],
    checkInCode: json["checkInCode"],
    checkInCodeStartDate: json["checkInCodeStartDate"] == null ? null : DateTime.parse(json["checkInCodeStartDate"]),
    checkInCodeExpiryDate: json["checkInCodeExpiryDate"] == null ? null : DateTime.parse(json["checkInCodeExpiryDate"]),
    checkInCodeStart: json["checkInCodeStart"] == null ? null : DateTime.parse(json["checkInCodeStart"]),
    checkInCodeExpiry: json["checkInCodeExpiry"] == null ? null : DateTime.parse(json["checkInCodeExpiry"]),
    isPreApproved: json["isPreApproved"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "guardStatus": guardStatus?.toJson(),
    "_id": id,
    "approvedBy": approvedBy?.toJson(),
    "name": name,
    "mobNumber": mobNumber,
    "profileImg": profileImg,
    "serviceName": serviceName,
    "serviceLogo": serviceLogo,
    "entryType": entryType,
    "societyName": societyName,
    "societyBlock": societyBlock,
    "apartment": apartment,
    "gatepassAptDetails": gatepassAptDetails?.toJson(),
    "addressProof": addressProof,
    "address": address,
    "gender": gender,
    "checkInCode": checkInCode,
    "checkInCodeStartDate": checkInCodeStartDate?.toIso8601String(),
    "checkInCodeExpiryDate": checkInCodeExpiryDate?.toIso8601String(),
    "checkInCodeStart": checkInCodeStart?.toIso8601String(),
    "checkInCodeExpiry": checkInCodeExpiry?.toIso8601String(),
    "isPreApproved": isPreApproved,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class ApprovedBy {
  final String? id;
  final String? userName;
  final String? email;
  final String? role;
  final String? profile;
  final String? phoneNo;
  final String? fcmToken;

  ApprovedBy({
    this.id,
    this.userName,
    this.email,
    this.role,
    this.profile,
    this.phoneNo,
    this.fcmToken,
  });

  factory ApprovedBy.fromJson(Map<String, dynamic> json) => ApprovedBy(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
    role: json["role"],
    profile: json["profile"],
    phoneNo: json["phoneNo"],
    fcmToken: json["FCMToken"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "email": email,
    "role": role,
    "profile": profile,
    "phoneNo": phoneNo,
    "FCMToken": fcmToken,
  };
}

class GatepassAptDetails {
  final String? societyName;
  final String? societyGates;
  final List<SocietyApartment>? societyApartments;
  final String? id;

  GatepassAptDetails({
    this.societyName,
    this.societyGates,
    this.societyApartments,
    this.id,
  });

  factory GatepassAptDetails.fromJson(Map<String, dynamic> json) => GatepassAptDetails(
    societyName: json["societyName"],
    societyGates: json["societyGates"],
    societyApartments: json["societyApartments"] == null ? [] : List<SocietyApartment>.from(json["societyApartments"]!.map((x) => SocietyApartment.fromJson(x))),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "societyName": societyName,
    "societyGates": societyGates,
    "societyApartments": societyApartments == null ? [] : List<dynamic>.from(societyApartments!.map((x) => x.toJson())),
    "_id": id,
  };
}

class SocietyApartment {
  final EntryStatus? entryStatus;
  final String? societyBlock;
  final String? apartment;
  final List<ApprovedBy>? members;
  final String? id;

  SocietyApartment({
    this.entryStatus,
    this.societyBlock,
    this.apartment,
    this.members,
    this.id,
  });

  factory SocietyApartment.fromJson(Map<String, dynamic> json) => SocietyApartment(
    entryStatus: json["entryStatus"] == null ? null : EntryStatus.fromJson(json["entryStatus"]),
    societyBlock: json["societyBlock"],
    apartment: json["apartment"],
    members: json["members"] == null ? [] : List<ApprovedBy>.from(json["members"]!.map((x) => ApprovedBy.fromJson(x))),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "entryStatus": entryStatus?.toJson(),
    "societyBlock": societyBlock,
    "apartment": apartment,
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
    "_id": id,
  };
}

class EntryStatus {
  final String? status;
  final ApprovedBy? approvedBy;
  final ApprovedBy? rejectedBy;

  EntryStatus({
    this.status,
    this.approvedBy,
    this.rejectedBy,
  });

  factory EntryStatus.fromJson(Map<String, dynamic> json) => EntryStatus(
    status: json["status"],
    approvedBy: json["approvedBy"] == null ? null : ApprovedBy.fromJson(json["approvedBy"]),
    rejectedBy: json["rejectedBy"] == null ? null : ApprovedBy.fromJson(json["rejectedBy"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "approvedBy": approvedBy?.toJson(),
    "rejectedBy": rejectedBy?.toJson(),
  };
}

class GuardStatus {
  final ApprovedBy? guard;
  final String? status;

  GuardStatus({
    this.guard,
    this.status,
  });

  factory GuardStatus.fromJson(Map<String, dynamic> json) => GuardStatus(
    guard: json["guard"] == null ? null : ApprovedBy.fromJson(json["guard"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "guard": guard?.toJson(),
    "status": status,
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
