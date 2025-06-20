// To parse this JSON data, do
//
//     final technicianModel = technicianModelFromJson(jsonString);

import 'dart:convert';

TechnicianModel technicianModelFromJson(String str) => TechnicianModel.fromJson(json.decode(str));

String technicianModelToJson(TechnicianModel data) => json.encode(data.toJson());

class TechnicianModel {
  final List<Technician>? technicians;
  final Pagination? pagination;

  TechnicianModel({
    this.technicians,
    this.pagination,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) => TechnicianModel(
    technicians: json["technicians"] == null ? [] : List<Technician>.from(json["technicians"]!.map((x) => Technician.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "technicians": technicians == null ? [] : List<dynamic>.from(technicians!.map((x) => x.toJson())),
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

class Technician {
  final String? id;
  final String? userName;
  final String? profile;
  final String? email;
  final String? phoneNo;
  final String? role;
  final String? technicianPassword;

  Technician({
    this.id,
    this.userName,
    this.profile,
    this.email,
    this.phoneNo,
    this.role,
    this.technicianPassword,
  });

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
    id: json["_id"],
    userName: json["userName"],
    profile: json["profile"],
    email: json["email"],
    phoneNo: json["phoneNo"],
    role: json["role"],
    technicianPassword: json["technicianPassword"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "profile": profile,
    "email": email,
    "phoneNo": phoneNo,
    "role": role,
    "technicianPassword": technicianPassword,
  };
}