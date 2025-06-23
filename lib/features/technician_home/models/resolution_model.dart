// To parse this JSON data, do
//
//     final resolutionModel = resolutionModelFromJson(jsonString);

import 'dart:convert';

ResolutionModel resolutionModelFromJson(String str) => ResolutionModel.fromJson(json.decode(str));

String resolutionModelToJson(ResolutionModel data) => json.encode(data.toJson());

class ResolutionModel {
  final int? statusCode;
  final Data? data;
  final String? message;
  final bool? success;

  ResolutionModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory ResolutionModel.fromJson(Map<String, dynamic> json) => ResolutionModel(
    statusCode: json["statusCode"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "data": data?.toJson(),
    "message": message,
    "success": success,
  };
}

class Data {
  final List<ResolutionElement>? resolutions;
  final Pagination? pagination;

  Data({
    this.resolutions,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    resolutions: json["resolutions"] == null ? [] : List<ResolutionElement>.from(json["resolutions"]!.map((x) => ResolutionElement.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "resolutions": resolutions == null ? [] : List<dynamic>.from(resolutions!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
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

class ResolutionElement {
  final String? id;
  final AssignedBy? raisedBy;
  final String? societyName;
  final String? area;
  final String? category;
  final String? subCategory;
  final String? status;
  final String? description;
  final String? complaintId;
  final String? imageUrl;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? assignStatus;
  final DateTime? assignedAt;
  final AssignedBy? assignedBy;
  final AssignedBy? technicianId;
  final ResolutionResolution? resolution;

  ResolutionElement({
    this.id,
    this.raisedBy,
    this.societyName,
    this.area,
    this.category,
    this.subCategory,
    this.status,
    this.description,
    this.complaintId,
    this.imageUrl,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.assignStatus,
    this.assignedAt,
    this.assignedBy,
    this.technicianId,
    this.resolution,
  });

  factory ResolutionElement.fromJson(Map<String, dynamic> json) => ResolutionElement(
    id: json["_id"],
    raisedBy: json["raisedBy"] == null ? null : AssignedBy.fromJson(json["raisedBy"]),
    societyName: json["societyName"],
    area: json["area"],
    category: json["category"],
    subCategory: json["subCategory"],
    status: json["status"],
    description: json["description"],
    complaintId: json["complaintId"],
    imageUrl: json["imageUrl"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    assignStatus: json["assignStatus"],
    assignedAt: json["assignedAt"] == null ? null : DateTime.parse(json["assignedAt"]),
    assignedBy: json["assignedBy"] == null ? null : AssignedBy.fromJson(json["assignedBy"]),
    technicianId: json["technicianId"] == null ? null : AssignedBy.fromJson(json["technicianId"]),
    resolution: json["resolution"] == null ? null : ResolutionResolution.fromJson(json["resolution"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "raisedBy": raisedBy?.toJson(),
    "societyName": societyName,
    "area": area,
    "category": category,
    "subCategory": subCategory,
    "status": status,
    "description": description,
    "complaintId": complaintId,
    "imageUrl": imageUrl,
    "date": date?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "assignStatus": assignStatus,
    "assignedAt": assignedAt?.toIso8601String(),
    "assignedBy": assignedBy?.toJson(),
    "technicianId": technicianId?.toJson(),
    "resolution": resolution?.toJson(),
  };
}

class AssignedBy {
  final String? id;
  final String? userName;
  final String? email;
  final String? profile;
  final String? role;
  final String? phoneNo;

  AssignedBy({
    this.id,
    this.userName,
    this.email,
    this.profile,
    this.role,
    this.phoneNo,
  });

  factory AssignedBy.fromJson(Map<String, dynamic> json) => AssignedBy(
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

class ResolutionResolution {
  final String? id;
  final String? complaintId;
  final String? resolutionAttachment;
  final String? resolutionNote;
  final AssignedBy? resolvedBy;
  final DateTime? resolutionSubmittedAt;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ResolutionResolution({
    this.id,
    this.complaintId,
    this.resolutionAttachment,
    this.resolutionNote,
    this.resolvedBy,
    this.resolutionSubmittedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ResolutionResolution.fromJson(Map<String, dynamic> json) => ResolutionResolution(
    id: json["_id"],
    complaintId: json["complaintId"],
    resolutionAttachment: json["resolutionAttachment"],
    resolutionNote: json["resolutionNote"],
    resolvedBy: json["resolvedBy"] == null ? null : AssignedBy.fromJson(json["resolvedBy"]),
    resolutionSubmittedAt: json["resolutionSubmittedAt"] == null ? null : DateTime.parse(json["resolutionSubmittedAt"]),
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "complaintId": complaintId,
    "resolutionAttachment": resolutionAttachment,
    "resolutionNote": resolutionNote,
    "resolvedBy": resolvedBy?.toJson(),
    "resolutionSubmittedAt": resolutionSubmittedAt?.toIso8601String(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
