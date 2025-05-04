// To parse this JSON data, do
//
//     final societyMemberModel = societyMemberModelFromJson(jsonString);

import 'dart:convert';

SocietyMemberModel societyMemberModelFromJson(String str) => SocietyMemberModel.fromJson(json.decode(str));

String societyMemberModelToJson(SocietyMemberModel data) => json.encode(data.toJson());

class SocietyMemberModel {
  final List<SocietyMember>? societyMembers;
  final Pagination? pagination;

  SocietyMemberModel({
    this.societyMembers,
    this.pagination,
  });

  factory SocietyMemberModel.fromJson(Map<String, dynamic> json) => SocietyMemberModel(
    societyMembers: json["societyMembers"] == null ? [] : List<SocietyMember>.from(json["societyMembers"]!.map((x) => SocietyMember.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "societyMembers": societyMembers == null ? [] : List<dynamic>.from(societyMembers!.map((x) => x.toJson())),
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

class SocietyMember {
  final String? id;
  final User? user;
  final String? profileType;
  final String? societyName;
  final String? societyBlock;
  final String? apartment;
  final String? ownership;
  final String? residentStatus;

  SocietyMember({
    this.id,
    this.user,
    this.profileType,
    this.societyName,
    this.societyBlock,
    this.apartment,
    this.ownership,
    this.residentStatus,
  });

  factory SocietyMember.fromJson(Map<String, dynamic> json) => SocietyMember(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profileType: json["profileType"],
    societyName: json["societyName"],
    societyBlock: json["societyBlock"],
    apartment: json["apartment"],
    ownership: json["ownership"],
    residentStatus: json["residentStatus"],
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
