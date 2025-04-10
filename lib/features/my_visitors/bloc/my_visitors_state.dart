part of 'my_visitors_bloc.dart';

@immutable
sealed class MyVisitorsState{}

final class MyVisitorsInitial extends MyVisitorsState{}

/// Add Pre approve entry
final class GetExpectedEntriesLoading extends MyVisitorsState{}

final class GetExpectedEntriesSuccess extends MyVisitorsState{
  final List<PreApprovedBanner> response;
  GetExpectedEntriesSuccess({required this.response});
}

final class GetExpectedEntriesFailure extends MyVisitorsState{
  final String message;
  final int? status;

  GetExpectedEntriesFailure( {required this.message, this.status});
}

/// Get Current entry
final class GetCurrentEntriesLoading extends MyVisitorsState{}

final class GetCurrentEntriesSuccess extends MyVisitorsState{
  final List<VisitorEntries> response;
  GetCurrentEntriesSuccess({required this.response});
}

final class GetCurrentEntriesFailure extends MyVisitorsState{
  final String message;
  final int? status;

  GetCurrentEntriesFailure( {required this.message, this.status});
}

/// Get Current entry
final class GetDeniedEntriesLoading extends MyVisitorsState{}

final class GetDeniedEntriesSuccess extends MyVisitorsState{
  final List<VisitorEntries> response;
  GetDeniedEntriesSuccess({required this.response});
}

final class GetDeniedEntriesFailure extends MyVisitorsState{
  final String message;
  final int? status;

  GetDeniedEntriesFailure( {required this.message, this.status});
}

/// Get Past entry
final class GetPastEntriesLoading extends MyVisitorsState{}

final class GetPastEntriesSuccess extends MyVisitorsState{
  final PastDeliveryModel response;
  GetPastEntriesSuccess({required this.response});
}

final class GetPastEntriesFailure extends MyVisitorsState{
  final String message;
  final int? status;

  GetPastEntriesFailure( {required this.message, this.status});
}

/// Get service requests
final class GetServiceRequestLoading extends MyVisitorsState{}

final class GetServiceRequestSuccess extends MyVisitorsState{
  final VisitorEntries response;
  GetServiceRequestSuccess({required this.response});
}

final class GetServiceRequestFailure extends MyVisitorsState{
  final String message;
  final int? status;

  GetServiceRequestFailure( {required this.message, this.status});
}