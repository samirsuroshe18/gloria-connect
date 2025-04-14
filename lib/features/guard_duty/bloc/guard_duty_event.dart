part of 'guard_duty_bloc.dart';

@immutable
sealed class GuardDutyEvent{}

final class GuardDutyCheckIn extends GuardDutyEvent{
  final String gate;
  final String checkinReason;

  GuardDutyCheckIn({required this.gate, required this.checkinReason});
}

final class GuardDutyCheckOut extends GuardDutyEvent{
  final String checkoutReason;

  GuardDutyCheckOut({required this.checkoutReason});
}

final class GuardDutyStatus extends GuardDutyEvent{}
