part of 'guard_waiting_bloc.dart';

@immutable
sealed class GuardWaitingState{}

final class GuardWaitingInitial extends GuardWaitingState{}

/// Get entries
final class WaitingGetEntriesLoading extends GuardWaitingState{}

final class WaitingGetEntriesSuccess extends GuardWaitingState{
  final List<Entry> response;
  WaitingGetEntriesSuccess({required this.response});
}

final class WaitingGetEntriesFailure extends GuardWaitingState{
  final String message;
  final int? status;

  WaitingGetEntriesFailure( {required this.message, this.status});
}

/// Allow by security
final class WaitingAllowEntryLoading extends GuardWaitingState{}

final class WaitingAllowEntrySuccess extends GuardWaitingState{
  final Map<String, dynamic> response;
  WaitingAllowEntrySuccess({required this.response});
}

final class WaitingAllowEntryFailure extends GuardWaitingState{
  final String message;
  final int? status;

  WaitingAllowEntryFailure( {required this.message, this.status});
}

/// Deny by security
final class WaitingDenyEntryLoading extends GuardWaitingState{}

final class WaitingDenyEntrySuccess extends GuardWaitingState{
  final Map<String, dynamic> response;
  WaitingDenyEntrySuccess({required this.response});
}

final class WaitingDenyEntryFailure extends GuardWaitingState{
  final String message;
  final int? status;

  WaitingDenyEntryFailure( {required this.message, this.status});
}