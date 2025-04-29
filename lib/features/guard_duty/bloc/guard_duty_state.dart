part of 'guard_duty_bloc.dart';

@immutable
sealed class GuardDutyState{}

final class GuardDutyInitial extends GuardDutyState{}

///To check-in
final class GuardDutyCheckInLoading extends GuardDutyState{}

final class GuardDutyCheckInSuccess extends GuardDutyState{
  final Map<String, dynamic> response;
  GuardDutyCheckInSuccess({required this.response});
}

final class GuardDutyCheckInFailure extends GuardDutyState{
  final String message;
  final int? status;

  GuardDutyCheckInFailure( {required this.message, this.status});
}

///To check-out
final class GuardDutyCheckOutLoading extends GuardDutyState{}

final class GuardDutyCheckOutSuccess extends GuardDutyState{
  final Map<String, dynamic> response;
  GuardDutyCheckOutSuccess({required this.response});
}

final class GuardDutyCheckOutFailure extends GuardDutyState{
  final String message;
  final int? status;

  GuardDutyCheckOutFailure( {required this.message, this.status});
}

///check status
final class GuardDutyStatusLoading extends GuardDutyState{}

final class GuardDutyStatusSuccess extends GuardDutyState{
  final Map<String, dynamic> response;
  GuardDutyStatusSuccess({required this.response});
}

final class GuardDutyStatusFailure extends GuardDutyState{
  final String message;
  final int? status;

  GuardDutyStatusFailure( {required this.message, this.status});
}

///get guard logs
final class GuardGetLogsLoading extends GuardDutyState{}

final class GuardGetLogsSuccess extends GuardDutyState{
  final GuardLogModel response;
  GuardGetLogsSuccess({required this.response});
}

final class GuardGetLogsFailure extends GuardDutyState{
  final String message;
  final int? status;

  GuardGetLogsFailure( {required this.message, this.status});
}

///get guard logs
final class GetGuardInfoLoading extends GuardDutyState{}

final class GetGuardInfoSuccess extends GuardDutyState{
  final GuardInfoModel response;
  GetGuardInfoSuccess({required this.response});
}

final class GetGuardInfoFailure extends GuardDutyState{
  final String message;
  final int? status;

  GetGuardInfoFailure( {required this.message, this.status});
}