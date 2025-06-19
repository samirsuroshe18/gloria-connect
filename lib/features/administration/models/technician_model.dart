class TechnicianRole {
  static const String plumber = 'Plumber';
  static const String carpenter = 'Carpenter';
  static const String electrician = 'Electrician';
  static const String painter = 'Painter';
  static const String hvacTechnician = 'HVAC Technician';
  static const String generalMaintenance = 'General Maintenance';

  static List<String> get values => [
    plumber,
    carpenter,
    electrician,
    painter,
    hvacTechnician,
    generalMaintenance,
  ];
}

class Technician {
  final String? id;
  final String name;
  final String email;
  final String phoneNo;
  final String address;
  final String role;

  Technician({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.address,
    required this.role,
  });

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    phoneNo: json["phoneNo"],
    address: json["address"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "phoneNo": phoneNo,
    "address": address,
    "role": role,
  };
}