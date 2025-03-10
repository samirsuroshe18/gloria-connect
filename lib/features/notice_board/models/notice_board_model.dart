// To parse this JSON data, do
//
//     final noticeBoardModel = noticeBoardModelFromJson(jsonString);

import 'dart:convert';

List<NoticeBoardModel> noticeBoardModelFromJson(String str) => List<NoticeBoardModel>.from(json.decode(str).map((x) => NoticeBoardModel.fromJson(x)));

String noticeBoardModelToJson(List<NoticeBoardModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoticeBoardModel {
    final String? id;
    final String? society;
    final String? title;
    final String? description;
    final String? category;
    final String? image;
    final List<DBy>? readBy;
    final DBy? publishedBy;
    final bool? isDeleted;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;
    final String? updatedBy;

    NoticeBoardModel({
        this.id,
        this.society,
        this.title,
        this.description,
        this.category,
        this.image,
        this.readBy,
        this.publishedBy,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.v,
        this.updatedBy,
    });

    factory NoticeBoardModel.fromJson(Map<String, dynamic> json) => NoticeBoardModel(
        id: json["_id"],
        society: json["society"],
        title: json["title"],
        description: json["description"],
        category: json["category"],
        image: json["image"],
        readBy: json["readBy"] == null
        ? []
        : (json["readBy"] is List)
            ? List<DBy>.from(json["readBy"].map((x) => DBy.fromJson(x)))
            : [], // Fallback in case of incorrect type
    publishedBy: json["publishedBy"] is Map<String, dynamic>
        ? DBy.fromJson(json["publishedBy"])
        : null, // Fallback if it's a String,
        // publishedBy: json["publishedBy"] == null ? null : DBy.fromJson(json["publishedBy"]),
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        updatedBy: json["updatedBy"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "society": society,
        "title": title,
        "description": description,
        "category": category,
        "image": image,
        "readBy": readBy == null ? [] : List<dynamic>.from(readBy!.map((x) => x.toJson())),
        "publishedBy": publishedBy?.toJson(),
        "isDeleted": isDeleted,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "updatedBy": updatedBy,
    };
}

class DBy {
    final String? id;
    final String? userName;
    final String? email;

    DBy({
        this.id,
        this.userName,
        this.email,
    });

    factory DBy.fromJson(Map<String, dynamic> json) => DBy(
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
