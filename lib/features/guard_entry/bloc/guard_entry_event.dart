part of 'guard_entry_bloc.dart';

@immutable
sealed class GuardEntryEvent{}

class AddDeliveryEntry extends GuardEntryEvent{
  final String name;
  final String mobNumber;
  final dynamic profileImg;
  final String? companyName;
  final String? companyLogo;
  final String? serviceName;
  final String? serviceLogo;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? accompanyingGuest;
  final String entryType;
  final String societyName;
  final List<Map<String, String>> societyApartments;
  final String societyGates;

  AddDeliveryEntry({
    required this.name,
    required this.mobNumber,
    required this.profileImg,
    this.companyName,
    this.companyLogo,
    this.serviceName,
    this.serviceLogo,
    this.vehicleType,
    this.vehicleNumber,
    this.accompanyingGuest,
    required this.entryType,
    required this.societyName,
    required this.societyApartments,
    required this.societyGates,
  });
}

class RejectDeliveryEntry extends GuardEntryEvent{
  final String id;

  RejectDeliveryEntry({
    required this.id,
  });
}

class ApproveDeliveryEntry extends GuardEntryEvent{
  final String id;

  ApproveDeliveryEntry({
    required this.id,
  });
}

class CheckInByCode extends GuardEntryEvent{
  final String checkInCode;

  CheckInByCode({
    required this.checkInCode,
  });
}