part of 'guard_exit_bloc.dart';

@immutable
sealed class GuardExitEvent{}

final class ExitGetAllowedEntries extends GuardExitEvent{}

final class ExitGetGuestEntries extends GuardExitEvent{}

final class ExitGetCabEntries extends GuardExitEvent{}

final class ExitGetDeliveryEntries extends GuardExitEvent{}

final class ExitGetServiceEntries extends GuardExitEvent{}

final class ExitEntry extends GuardExitEvent{
  final String id;
  final String entryType;

  ExitEntry({required this.id, required this.entryType});
}