// To parse this JSON data, do
//
//     final guardLogModel = guardLogModelFromJson(jsonString);

import 'dart:convert';

GuardLogModel guardLogModelFromJson(String str) => GuardLogModel.fromJson(json.decode(str));

String guardLogModelToJson(GuardLogModel data) => json.encode(data.toJson());

class GuardLogModel {
  final List<GuardLogEntry>? guardLogEntries;
  final Pagination? pagination;

  GuardLogModel({
    this.guardLogEntries,
    this.pagination,
  });

  factory GuardLogModel.fromJson(Map<String, dynamic> json) => GuardLogModel(
    guardLogEntries: json["guard_log_entries"] == null ? [] : List<GuardLogEntry>.from(json["guard_log_entries"]!.map((x) => GuardLogEntry.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "guard_log_entries": guardLogEntries == null ? [] : List<dynamic>.from(guardLogEntries!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class GuardLogEntry {
  final String? id;
  final GuardId? guardId;
  final String? gate;
  final String? checkinReason;
  final DateTime? date;
  final DateTime? checkinTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? shift;
  final int? v;
  final String? checkoutReason;
  final DateTime? checkoutTime;

  GuardLogEntry({
    this.id,
    this.guardId,
    this.gate,
    this.checkinReason,
    this.date,
    this.checkinTime,
    this.createdAt,
    this.updatedAt,
    this.shift,
    this.v,
    this.checkoutReason,
    this.checkoutTime,
  });

  factory GuardLogEntry.fromJson(Map<String, dynamic> json) => GuardLogEntry(
    id: json["_id"],
    guardId: json["guardId"] == null ? null : GuardId.fromJson(json["guardId"]),
    gate: json["gate"],
    checkinReason: json["checkinReason"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    checkinTime: json["checkinTime"] == null ? null : DateTime.parse(json["checkinTime"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    shift: json["shift"],
    v: json["__v"],
    checkoutReason: json["checkoutReason"],
    checkoutTime: json["checkoutTime"] == null ? null : DateTime.parse(json["checkoutTime"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "guardId": guardId?.toJson(),
    "gate": gate,
    "checkinReason": checkinReason,
    "date": date?.toIso8601String(),
    "checkinTime": checkinTime?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "shift": shift,
    "__v": v,
    "checkoutReason": checkoutReason,
    "checkoutTime": checkoutTime?.toIso8601String(),
  };
}

class GuardId {
  final String? id;
  final String? userName;
  final String? profile;

  GuardId({
    this.id,
    this.userName,
    this.profile,
  });

  factory GuardId.fromJson(Map<String, dynamic> json) => GuardId(
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
