// To parse this JSON data, do
//
//     final adminComplaintModel = adminComplaintModelFromJson(jsonString);

// import 'dart:convert';
//
// AdminComplaintModel adminComplaintModelFromJson(String str) => AdminComplaintModel.fromJson(json.decode(str));
//
// String adminComplaintModelToJson(AdminComplaintModel data) => json.encode(data.toJson());
//
// class AdminComplaintModel {
//   final List<Complaint>? complaints;
//   final User? user;
//
//   AdminComplaintModel({
//     this.complaints,
//     this.user,
//   });
//
//   factory AdminComplaintModel.fromJson(Map<String, dynamic> json) => AdminComplaintModel(
//     complaints: json["complaints"] == null ? [] : List<Complaint>.from(json["complaints"]!.map((x) => Complaint.fromJson(x))),
//     user: json["user"] == null ? null : User.fromJson(json["user"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "complaints": complaints == null ? [] : List<dynamic>.from(complaints!.map((x) => x.toJson())),
//     "user": user?.toJson(),
//   };
// }
//
// class Complaint {
//   final String? id;
//   final By? raisedBy;
//   final String? area;
//   final String? category;
//   final String? subCategory;
//   final String? status;
//   final String? description;
//   final String? complaintId;
//   final String? imageUrl;
//   final DateTime? date;
//   final int? review;
//   final List<Response>? responses;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   Complaint({
//     this.id,
//     this.raisedBy,
//     this.area,
//     this.category,
//     this.subCategory,
//     this.status,
//     this.description,
//     this.complaintId,
//     this.imageUrl,
//     this.date,
//     this.review,
//     this.responses,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
//     id: json["_id"],
//     raisedBy: json["raisedBy"] == null ? null : By.fromJson(json["raisedBy"]),
//     area: json["area"],
//     category: json["category"],
//     subCategory: json["subCategory"],
//     status: json["status"],
//     description: json["description"],
//     complaintId: json["complaintId"],
//     imageUrl: json["imageUrl"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     review: json["review"],
//     responses: json["responses"] == null ? [] : List<Response>.from(json["responses"]!.map((x) => Response.fromJson(x))),
//     createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "raisedBy": raisedBy?.toJson(),
//     "area": area,
//     "category": category,
//     "subCategory": subCategory,
//     "status": status,
//     "description": description,
//     "complaintId": complaintId,
//     "imageUrl": imageUrl,
//     "date": date?.toIso8601String(),
//     "review": review,
//     "responses": responses == null ? [] : List<dynamic>.from(responses!.map((x) => x.toJson())),
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//   };
// }
//
// class By {
//   final String? id;
//   final String? userName;
//   final String? email;
//   final String? profile;
//   final String? role;
//   final String? phoneNo;
//
//   By({
//     this.id,
//     this.userName,
//     this.email,
//     this.profile,
//     this.role,
//     this.phoneNo,
//   });
//
//   factory By.fromJson(Map<String, dynamic> json) => By(
//     id: json["_id"],
//     userName: json["userName"],
//     email: json["email"],
//     profile: json["profile"],
//     role: json["role"],
//     phoneNo: json["phoneNo"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "userName": userName,
//     "email": email,
//     "profile": profile,
//     "role": role,
//     "phoneNo": phoneNo,
//   };
// }
//
// class Response {
//   final By? responseBy;
//   final String? message;
//   final String? id;
//   final DateTime? date;
//
//   Response({
//     this.responseBy,
//     this.message,
//     this.id,
//     this.date,
//   });
//
//   factory Response.fromJson(Map<String, dynamic> json) => Response(
//     responseBy: json["responseBy"] == null ? null : By.fromJson(json["responseBy"]),
//     message: json["message"],
//     id: json["_id"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "responseBy": responseBy?.toJson(),
//     "message": message,
//     "_id": id,
//     "date": date?.toIso8601String(),
//   };
// }
//
// class User {
//   final String? id;
//   final String? userName;
//   final String? email;
//   final String? profile;
//   final String? role;
//   final bool? isUserTypeVerified;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String? phoneNo;
//   final String? userType;
//
//   User({
//     this.id,
//     this.userName,
//     this.email,
//     this.profile,
//     this.role,
//     this.isUserTypeVerified,
//     this.createdAt,
//     this.updatedAt,
//     this.phoneNo,
//     this.userType,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["_id"],
//     userName: json["userName"],
//     email: json["email"],
//     profile: json["profile"],
//     role: json["role"],
//     isUserTypeVerified: json["isUserTypeVerified"],
//     createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//     phoneNo: json["phoneNo"],
//     userType: json["userType"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "userName": userName,
//     "email": email,
//     "profile": profile,
//     "role": role,
//     "isUserTypeVerified": isUserTypeVerified,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "phoneNo": phoneNo,
//     "userType": userType,
//   };
// }


// To parse this JSON data, do
//
//     final adminComplaintModel = adminComplaintModelFromJson(jsonString);

// import 'dart:convert';
//
// AdminComplaintModel adminComplaintModelFromJson(String str) => AdminComplaintModel.fromJson(json.decode(str));
//
// String adminComplaintModelToJson(AdminComplaintModel data) => json.encode(data.toJson());
//
// class AdminComplaintModel {
//   final List<Complaint>? complaints;
//   final User? user;
//   final Pagination? pagination;
//
//   AdminComplaintModel({
//     this.complaints,
//     this.user,
//     this.pagination,
//   });
//
//   factory AdminComplaintModel.fromJson(Map<String, dynamic> json) => AdminComplaintModel(
//     complaints: json["complaints"] == null ? [] : List<Complaint>.from(json["complaints"]!.map((x) => Complaint.fromJson(x))),
//     user: json["user"] == null ? null : User.fromJson(json["user"]),
//     pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "complaints": complaints == null ? [] : List<dynamic>.from(complaints!.map((x) => x.toJson())),
//     "user": user?.toJson(),
//     "pagination": pagination?.toJson(),
//   };
// }
//
// class Complaint {
//   final String? id;
//   final By? raisedBy;
//   final String? area;
//   final String? category;
//   final String? subCategory;
//   final String? status;
//   final String? description;
//   final String? complaintId;
//   final String? imageUrl;
//   final DateTime? date;
//   final int? review;
//   final List<Response>? responses;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   Complaint({
//     this.id,
//     this.raisedBy,
//     this.area,
//     this.category,
//     this.subCategory,
//     this.status,
//     this.description,
//     this.complaintId,
//     this.imageUrl,
//     this.date,
//     this.review,
//     this.responses,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
//     id: json["_id"],
//     raisedBy: json["raisedBy"] == null ? null : By.fromJson(json["raisedBy"]),
//     area: json["area"],
//     category: json["category"],
//     subCategory: json["subCategory"],
//     status: json["status"],
//     description: json["description"],
//     complaintId: json["complaintId"],
//     imageUrl: json["imageUrl"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     review: json["review"],
//     responses: json["responses"] == null ? [] : List<Response>.from(json["responses"]!.map((x) => Response.fromJson(x))),
//     createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "raisedBy": raisedBy?.toJson(),
//     "area": area,
//     "category": category,
//     "subCategory": subCategory,
//     "status": status,
//     "description": description,
//     "complaintId": complaintId,
//     "imageUrl": imageUrl,
//     "date": date?.toIso8601String(),
//     "review": review,
//     "responses": responses == null ? [] : List<dynamic>.from(responses!.map((x) => x.toJson())),
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//   };
// }
//
// class By {
//   final String? id;
//   final String? userName;
//   final String? email;
//   final String? profile;
//   final String? role;
//   final String? phoneNo;
//
//   By({
//     this.id,
//     this.userName,
//     this.email,
//     this.profile,
//     this.role,
//     this.phoneNo,
//   });
//
//   factory By.fromJson(Map<String, dynamic> json) => By(
//     id: json["_id"],
//     userName: json["userName"],
//     email: json["email"],
//     profile: json["profile"],
//     role: json["role"],
//     phoneNo: json["phoneNo"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "userName": userName,
//     "email": email,
//     "profile": profile,
//     "role": role,
//     "phoneNo": phoneNo,
//   };
// }
//
// class Response {
//   final By? responseBy;
//   final String? message;
//   final String? id;
//   final DateTime? date;
//
//   Response({
//     this.responseBy,
//     this.message,
//     this.id,
//     this.date,
//   });
//
//   factory Response.fromJson(Map<String, dynamic> json) => Response(
//     responseBy: json["responseBy"] == null ? null : By.fromJson(json["responseBy"]),
//     message: json["message"],
//     id: json["_id"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "responseBy": responseBy?.toJson(),
//     "message": message,
//     "_id": id,
//     "date": date?.toIso8601String(),
//   };
// }
//
// class Pagination {
//   final int? totalEntries;
//   final int? entriesPerPage;
//   final int? currentPage;
//   final int? totalPages;
//   final bool? hasMore;
//
//   Pagination({
//     this.totalEntries,
//     this.entriesPerPage,
//     this.currentPage,
//     this.totalPages,
//     this.hasMore,
//   });
//
//   factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
//     totalEntries: json["totalEntries"],
//     entriesPerPage: json["entriesPerPage"],
//     currentPage: json["currentPage"],
//     totalPages: json["totalPages"],
//     hasMore: json["hasMore"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "totalEntries": totalEntries,
//     "entriesPerPage": entriesPerPage,
//     "currentPage": currentPage,
//     "totalPages": totalPages,
//     "hasMore": hasMore,
//   };
// }
//
// class User {
//   final String? id;
//   final String? userName;
//   final String? email;
//   final String? profile;
//   final String? role;
//   final bool? isUserTypeVerified;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String? phoneNo;
//   final String? userType;
//
//   User({
//     this.id,
//     this.userName,
//     this.email,
//     this.profile,
//     this.role,
//     this.isUserTypeVerified,
//     this.createdAt,
//     this.updatedAt,
//     this.phoneNo,
//     this.userType,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["_id"],
//     userName: json["userName"],
//     email: json["email"],
//     profile: json["profile"],
//     role: json["role"],
//     isUserTypeVerified: json["isUserTypeVerified"],
//     createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//     phoneNo: json["phoneNo"],
//     userType: json["userType"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "userName": userName,
//     "email": email,
//     "profile": profile,
//     "role": role,
//     "isUserTypeVerified": isUserTypeVerified,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "phoneNo": phoneNo,
//     "userType": userType,
//   };
// }

