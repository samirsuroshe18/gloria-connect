class Address {
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? id;

  Address({
    this.streetAddress,
    this.city,
    this.state,
    this.postalCode,
    this.id,
  });

  factory Address.fromJson(Map<String, dynamic>? map) {
    return Address(
      streetAddress: map?['streetAddress'] ?? "",
      city: map?['city'] ?? "",
      state: map?['state'] ?? "",
      postalCode: map?['postalCode'] ?? "",
      id: map?['_id'] ?? "",
    );
  }
}

class Apartment {
  final String? societyName;
  final String? societyBlock;
  final String? apartment;
  final String? role;
  final String? id;

  Apartment({
    required this.societyName,
    required this.societyBlock,
    required this.apartment,
    required this.role,
    required this.id,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      societyName: json['societyName'] ?? "",
      societyBlock: json['societyBlock'] ?? "",
      apartment: json['apartment'] ?? "",
      role: json['role'] ?? "",
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'societyName': societyName,
      'societyBlock': societyBlock,
      'apartment': apartment,
      'role': role,
      '_id': id,
    };
  }
}

class Gate {
  final String? id;
  final String? societyName;
  final String? gateAssign;

  Gate({
    required this.id,
    required this.societyName,
    required this.gateAssign,
  });

  factory Gate.fromJson(Map<String, dynamic> json) {
    return Gate(
      id: json['_id'] ?? "",
      societyName: json['societyName'] ?? "",
      gateAssign: json['gateAssign'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'societyName': societyName,
      'gateAssign': gateAssign,
    };
  }
}

class UserModel {
  final String? id;
  final String? userName;
  final String? email;
  final String? phoneNo;
  final String? profile;
  final Address? address;
  final List<Apartment>? apartments;
  final List<Gate>? gate;
  final int? age;
  final String? gender;
  final String? role;
  final String? profileType;
  final String? createdAt;
  final String? updatedAt;
  final String? accessToken;
  final String? refreshToken;
  final int? statusCode;
  final String? message;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.phoneNo,
    this.profile,
    this.address,
    this.apartments,
    this.gate,
    this.age,
    this.gender,
    this.role,
    this.profileType,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.refreshToken,
    this.statusCode,
    this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['data']['loggedInUser']['_id'] ?? "",
      userName: map['data']['loggedInUser']['userName'] ?? "",
      email: map['data']['loggedInUser']['email'] ?? "",
      phoneNo: map['data']['loggedInUser']['phoneNo'] ?? "",
      profile: map['data']['loggedInUser']['profile'] ?? "",
      address: map['data']['loggedInUser']['address'] != null
          ? Address.fromJson(map['data']['loggedInUser']['address'])
          : null,
      apartments: map['data']['loggedInUser']['apartments'] != null
          ? List<Apartment>.from(map['data']['loggedInUser']['apartments']
              .map((x) => Apartment.fromJson(x)))
          : null,
      gate: map['data']['loggedInUser']['gate'] != null
          ? List<Gate>.from(
              map['data']['loggedInUser']['gate'].map((x) => Gate.fromJson(x)))
          : null,
      age: map['data']['loggedInUser']['age'] ?? 0,
      gender: map['data']['loggedInUser']['gender'] ?? "",
      role: map['data']['loggedInUser']['role'] ?? "",
      profileType: map['data']['loggedInUser']['profileType'] ?? "",
      createdAt: map['data']['loggedInUser']['createdAt'] ?? "",
      updatedAt: map['data']['loggedInUser']['updatedAt'] ?? "",
      accessToken: map['data']['accessToken'] ?? "",
      refreshToken: map['data']['refreshToken'] ?? "",
      statusCode: map['statusCode'] ?? 0,
      message: map['message'] ?? "",
    );
  }
}
