part of 'invite_visitors_bloc.dart';

@immutable
sealed class InviteVisitorsEvent{}

final class AddPreApproveEntry extends InviteVisitorsEvent{
  final String name;
  final String mobNumber;
  final String? profileImg;
  final String? companyName;
  final String? companyLogo;
  final String? serviceName;
  final String? serviceLogo;
  final String? vehicleNumber;
  final String entryType;
  final String checkInCodeStartDate;
  final String checkInCodeExpiryDate;
  final String checkInCodeStart;
  final String checkInCodeExpiry;

  AddPreApproveEntry({
    required this.name,
    required this.mobNumber,
    this.profileImg,
    this.companyName,
    this.companyLogo,
    this.serviceName,
    this.serviceLogo,
    this.vehicleNumber,
    required this.entryType,
    required this.checkInCodeStartDate,
    required this.checkInCodeExpiryDate,
    required this.checkInCodeStart,
    required this.checkInCodeExpiry,
  });
}