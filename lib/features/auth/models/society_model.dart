// To parse this JSON data, do
//
//     final society = societyFromJson(jsonString);

import 'dart:convert';

List<Society> societyFromJson(String str) => List<Society>.from(json.decode(str).map((x) => Society.fromJson(x)));

String societyToJson(List<Society> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Society {
  final String? id;
  final String? societyName;
  final List<String>? societyBlocks;
  final List<SocietyApartment>? societyApartments;
  final List<String>? societyGates;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Society({
    this.id,
    this.societyName,
    this.societyBlocks,
    this.societyApartments,
    this.societyGates,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Society.fromJson(Map<String, dynamic> json) => Society(
    id: json["_id"],
    societyName: json["societyName"],
    societyBlocks: json["societyBlocks"] == null ? [] : List<String>.from(json["societyBlocks"]!.map((x) => x)),
    societyApartments: json["societyApartments"] == null ? [] : List<SocietyApartment>.from(json["societyApartments"]!.map((x) => SocietyApartment.fromJson(x))),
    societyGates: json["societyGates"] == null ? [] : List<String>.from(json["societyGates"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "societyName": societyName,
    "societyBlocks": societyBlocks == null ? [] : List<dynamic>.from(societyBlocks!.map((x) => x)),
    "societyApartments": societyApartments == null ? [] : List<dynamic>.from(societyApartments!.map((x) => x.toJson())),
    "societyGates": societyGates == null ? [] : List<dynamic>.from(societyGates!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class SocietyApartment {
  final String? societyBlock;
  final String? apartmentName;
  final String? id;

  SocietyApartment({
    this.societyBlock,
    this.apartmentName,
    this.id,
  });

  factory SocietyApartment.fromJson(Map<String, dynamic> json) => SocietyApartment(
    societyBlock: json["societyBlock"],
    apartmentName: json["apartmentName"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "societyBlock": societyBlock,
    "apartmentName": apartmentName,
    "_id": id,
  };
}
