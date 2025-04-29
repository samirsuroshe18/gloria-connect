// To parse this JSON data, do
//
//     final noticeBoardModel = noticeBoardModelFromJson(jsonString);

// import 'dart:convert';
//
// List<NoticeBoardModel> noticeBoardModelFromJson(String str) => List<NoticeBoardModel>.from(json.decode(str).map((x) => NoticeBoardModel.fromJson(x)));
//
// String noticeBoardModelToJson(List<NoticeBoardModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class NoticeBoardModel {
//     final String? id;
//     final String? society;
//     final String? title;
//     final String? description;
//     final String? category;
//     final String? image;
//     final List<DBy>? readBy;
//     final DBy? publishedBy;
//     final bool? isDeleted;
//     final DateTime? createdAt;
//     final DateTime? updatedAt;
//     final int? v;
//     final String? updatedBy;
//
//     NoticeBoardModel({
//         this.id,
//         this.society,
//         this.title,
//         this.description,
//         this.category,
//         this.image,
//         this.readBy,
//         this.publishedBy,
//         this.isDeleted,
//         this.createdAt,
//         this.updatedAt,
//         this.v,
//         this.updatedBy,
//     });
//
//     factory NoticeBoardModel.fromJson(Map<String, dynamic> json) => NoticeBoardModel(
//         id: json["_id"],
//         society: json["society"],
//         title: json["title"],
//         description: json["description"],
//         category: json["category"],
//         image: json["image"],
//         readBy: json["readBy"] == null
//         ? []
//         : (json["readBy"] is List)
//             ? List<DBy>.from(json["readBy"].map((x) => DBy.fromJson(x)))
//             : [], // Fallback in case of incorrect type
//     publishedBy: json["publishedBy"] is Map<String, dynamic>
//         ? DBy.fromJson(json["publishedBy"])
//         : null, // Fallback if it's a String,
//         // publishedBy: json["publishedBy"] == null ? null : DBy.fromJson(json["publishedBy"]),
//         isDeleted: json["isDeleted"],
//         createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         updatedBy: json["updatedBy"],
//     );
//
//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "society": society,
//         "title": title,
//         "description": description,
//         "category": category,
//         "image": image,
//         "readBy": readBy == null ? [] : List<dynamic>.from(readBy!.map((x) => x.toJson())),
//         "publishedBy": publishedBy?.toJson(),
//         "isDeleted": isDeleted,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//         "updatedBy": updatedBy,
//     };
// }
//
// class DBy {
//     final String? id;
//     final String? userName;
//     final String? email;
//
//     DBy({
//         this.id,
//         this.userName,
//         this.email,
//     });
//
//     factory DBy.fromJson(Map<String, dynamic> json) => DBy(
//         id: json["_id"],
//         userName: json["userName"],
//         email: json["email"],
//     );
//
//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userName": userName,
//         "email": email,
//     };
// }


// To parse this JSON data, do
//
//     final noticeBoardModel = noticeBoardModelFromJson(jsonString);

import 'dart:convert';

NoticeBoardModel noticeBoardModelFromJson(String str) => NoticeBoardModel.fromJson(json.decode(str));

String noticeBoardModelToJson(NoticeBoardModel data) => json.encode(data.toJson());

class NoticeBoardModel {
    final List<Notice>? notices;
    final Pagination? pagination;

    NoticeBoardModel({
        this.notices,
        this.pagination,
    });

    factory NoticeBoardModel.fromJson(Map<String, dynamic> json) => NoticeBoardModel(
        notices: json["notices"] == null ? [] : List<Notice>.from(json["notices"]!.map((x) => Notice.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "notices": notices == null ? [] : List<dynamic>.from(notices!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class Notice {
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

    Notice({
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

    factory Notice.fromJson(Map<String, dynamic> json) => Notice(
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

class PublishedBy {
    final String? id;
    final String? userName;
    final String? email;

    PublishedBy({
        this.id,
        this.userName,
        this.email,
    });

    factory PublishedBy.fromJson(Map<String, dynamic> json) => PublishedBy(
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

