// To parse this JSON data, do
//
//     final complaintModel = complaintModelFromJson(jsonString);

import 'dart:convert';

List<ComplaintModel> complaintModelFromJson(String str) => List<ComplaintModel>.from(json.decode(str).map((x) => ComplaintModel.fromJson(x)));

String complaintModelToJson(List<ComplaintModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComplaintModel {
  final String? id;
  final By? raisedBy;
  final String? area;
  final String? category;
  final String? subCategory;
  final String? status;
  final String? description;
  final String? complaintId;
  final String? imageUrl;
  final DateTime? date;
  final int? review;
  final List<Response>? responses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ComplaintModel({
    this.id,
    this.raisedBy,
    this.area,
    this.category,
    this.subCategory,
    this.status,
    this.description,
    this.complaintId,
    this.imageUrl,
    this.date,
    this.review,
    this.responses,
    this.createdAt,
    this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) => ComplaintModel(
    id: json["_id"],
    raisedBy: json["raisedBy"] == null ? null : By.fromJson(json["raisedBy"]),
    area: json["area"],
    category: json["category"],
    subCategory: json["subCategory"],
    status: json["status"],
    description: json["description"],
    complaintId: json["complaintId"],
    imageUrl: json["imageUrl"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    review: json["review"],
    responses: json["responses"] == null ? [] : List<Response>.from(json["responses"]!.map((x) => Response.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "raisedBy": raisedBy?.toJson(),
    "area": area,
    "category": category,
    "subCategory": subCategory,
    "status": status,
    "description": description,
    "complaintId": complaintId,
    "imageUrl": imageUrl,
    "date": date?.toIso8601String(),
    "review": review,
    "responses": responses == null ? [] : List<dynamic>.from(responses!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class By {
  final String? id;
  final String? userName;
  final String? email;
  final String? profile;
  final String? role;
  final String? phoneNo;

  By({
    this.id,
    this.userName,
    this.email,
    this.profile,
    this.role,
    this.phoneNo,
  });

  factory By.fromJson(Map<String, dynamic> json) => By(
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

class Response {
  final By? responseBy;
  final String? message;
  final String? id;
  final DateTime? date;

  Response({
    this.responseBy,
    this.message,
    this.id,
    this.date,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    responseBy: json["responseBy"] == null ? null : By.fromJson(json["responseBy"]),
    message: json["message"],
    id: json["_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "responseBy": responseBy?.toJson(),
    "message": message,
    "_id": id,
    "date": date?.toIso8601String(),
  };
}
