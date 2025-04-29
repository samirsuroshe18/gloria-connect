part of 'guard_duty_bloc.dart';

@immutable
sealed class GuardDutyEvent{}

final class GuardDutyCheckIn extends GuardDutyEvent{
  final String gate;
  final String checkinReason;
  final String shift;

  GuardDutyCheckIn({required this.gate, required this.checkinReason, required this.shift,});
}

final class GuardDutyCheckOut extends GuardDutyEvent{
  final String checkoutReason;

  GuardDutyCheckOut({required this.checkoutReason});
}

final class GetGuardInfo extends GuardDutyEvent{
  final String id;

  GetGuardInfo({required this.id});
}

final class GuardDutyStatus extends GuardDutyEvent{}

final class GuardGetLogs extends GuardDutyEvent{
  final Map<String, dynamic> queryParams;

  GuardGetLogs({required this.queryParams});
}
