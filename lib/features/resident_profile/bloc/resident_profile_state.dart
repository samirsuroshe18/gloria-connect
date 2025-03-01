part of 'resident_profile_bloc.dart';

@immutable
sealed class ResidentProfileState{}

final class ResidentProfileInitial extends ResidentProfileState{}

/// Get Apartment members
final class GetApartmentMembersLoading extends ResidentProfileState{}

final class GetApartmentMembersSuccess extends ResidentProfileState{
  final List<Member> response;
  GetApartmentMembersSuccess({required this.response});
}

final class GetApartmentMembersFailure extends ResidentProfileState{
  final String message;
  final int? status;

  GetApartmentMembersFailure( {required this.message, this.status});
}