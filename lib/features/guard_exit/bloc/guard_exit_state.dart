part of 'guard_exit_bloc.dart';

@immutable
sealed class GuardExitState{}

final class GuardExitInitial extends GuardExitState{}

/// Get All entries
final class ExitGetAllowedEntriesLoading extends GuardExitState{}

final class ExitGetAllowedEntriesSuccess extends GuardExitState{
  final List<VisitorEntries> response;
  ExitGetAllowedEntriesSuccess({required this.response});
}

final class ExitGetAllowedEntriesFailure extends GuardExitState{
  final String message;
  final int? status;

  ExitGetAllowedEntriesFailure( {required this.message, this.status});
}

/// Get Guest entries
final class ExitGetGuestEntriesLoading extends GuardExitState{}

final class ExitGetGuestEntriesSuccess extends GuardExitState{
  final List<VisitorEntries> response;
  ExitGetGuestEntriesSuccess({required this.response});
}

final class ExitGetGuestEntriesFailure extends GuardExitState{
  final String message;
  final int? status;

  ExitGetGuestEntriesFailure( {required this.message, this.status});
}

/// Get Cab entries
final class ExitGetCabEntriesLoading extends GuardExitState{}

final class ExitGetCabEntriesSuccess extends GuardExitState{
  final List<VisitorEntries> response;
  ExitGetCabEntriesSuccess({required this.response});
}

final class ExitGetCabEntriesFailure extends GuardExitState{
  final String message;
  final int? status;

  ExitGetCabEntriesFailure( {required this.message, this.status});
}

/// Get Delivery entries
final class ExitGetDeliveryEntriesLoading extends GuardExitState{}

final class ExitGetDeliveryEntriesSuccess extends GuardExitState{
  final List<VisitorEntries> response;
  ExitGetDeliveryEntriesSuccess({required this.response});
}

final class ExitGetDeliveryEntriesFailure extends GuardExitState{
  final String message;
  final int? status;

  ExitGetDeliveryEntriesFailure( {required this.message, this.status});
}

/// Get Services entries
final class ExitGetServiceEntriesLoading extends GuardExitState{}

final class ExitGetServiceEntriesSuccess extends GuardExitState{
  final List<VisitorEntries> response;
  ExitGetServiceEntriesSuccess({required this.response});
}

final class ExitGetServiceEntriesFailure extends GuardExitState{
  final String message;
  final int? status;

  ExitGetServiceEntriesFailure( {required this.message, this.status});
}

/// Exit entries
final class ExitEntryLoading extends GuardExitState{}

final class ExitEntrySuccess extends GuardExitState{
  final Map<String, dynamic> response;
  ExitEntrySuccess({required this.response});
}

final class ExitEntryFailure extends GuardExitState{
  final String message;
  final int? status;

  ExitEntryFailure( {required this.message, this.status});
}