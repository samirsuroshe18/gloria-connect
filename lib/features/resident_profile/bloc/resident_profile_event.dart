part of 'resident_profile_bloc.dart';

@immutable
sealed class ResidentProfileEvent{}

final class GetApartmentMembers extends ResidentProfileEvent{}