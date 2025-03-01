part of 'invite_visitors_bloc.dart';

@immutable
sealed class InviteVisitorsState{}

final class InviteVisitorsInitial extends InviteVisitorsState{}

/// Add Pre approve entry
final class AddPreApproveEntryLoading extends InviteVisitorsState{}

final class AddPreApproveEntrySuccess extends InviteVisitorsState{
  final PreApprovedBanner response;
  AddPreApproveEntrySuccess({required this.response});
}

final class AddPreApproveEntryFailure extends InviteVisitorsState{
  final String message;
  final int? status;

  AddPreApproveEntryFailure( {required this.message, this.status});
}