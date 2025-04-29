part of 'guard_profile_bloc.dart';

@immutable
sealed class GuardProfileEvent {}

final class GuardUpdateDetails extends GuardProfileEvent {
  final String? userName;
  final File? profile;

  GuardUpdateDetails({this.userName, this.profile});
}

final class GetCheckoutHistory extends GuardProfileEvent {
  final Map<String, dynamic> queryParams;

  GetCheckoutHistory({required this.queryParams});
}

final class AddGatePass extends GuardProfileEvent {
  final String? name;
  final File? profile;
  final String? mobNumber;
  final String? gender;
  final String? serviceName;
  final String? serviceLogo;
  final String? address;
  final File? addressProof;
  final List<Map<String, String>>? gatepassAptDetails;
  final String? checkInCodeStartDate;
  final String? checkInCodeExpiryDate;
  final String? checkInCodeStart;
  final String? checkInCodeExpiry;

  AddGatePass({
    this.name,
    this.profile,
    this.mobNumber,
    this.gender,
    this.serviceName,
    this.serviceLogo,
    this.address,
    this.addressProof,
    this.gatepassAptDetails,
    this.checkInCodeStartDate,
    this.checkInCodeExpiryDate,
    this.checkInCodeStart,
    this.checkInCodeExpiry,
  });
}

final class GetGatePass extends GuardProfileEvent {
  final Map<String, dynamic> queryParams;

  GetGatePass({required this.queryParams});
}
