part of 'guard_waiting_bloc.dart';

@immutable
sealed class GuardWaitingEvent{}

final class WaitingGetEntries extends GuardWaitingEvent{}

final class WaitingAllowEntry extends GuardWaitingEvent{
  final String id;

  WaitingAllowEntry({required this.id});
}

final class WaitingDenyEntry extends GuardWaitingEvent{
  final String id;

  WaitingDenyEntry({required this.id});
}