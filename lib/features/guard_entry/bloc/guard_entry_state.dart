part of 'guard_entry_bloc.dart';

@immutable
sealed class GuardEntryState{}

final class GuardEntryInitial extends GuardEntryState{}

///Add delivery entry
final class AddDeliveryEntryLoading extends GuardEntryState{}

final class AddDeliveryEntrySuccess extends GuardEntryState{
  final Map<String, dynamic> response;
  AddDeliveryEntrySuccess({required this.response});
}

final class AddDeliveryEntryFailure extends GuardEntryState{
  final String message;
  final int? status;

  AddDeliveryEntryFailure( {required this.message, this.status});
}

///Approve delivery entry
final class ApproveDeliveryEntryLoading extends GuardEntryState{}

final class ApproveDeliveryEntrySuccess extends GuardEntryState{
  final Map<String, dynamic> response;
  ApproveDeliveryEntrySuccess({required this.response});
}

final class ApproveDeliveryEntryFailure extends GuardEntryState{
  final String message;
  final int? status;

  ApproveDeliveryEntryFailure( {required this.message, this.status});
}

///Reject delivery entry
final class RejectDeliveryEntryLoading extends GuardEntryState{}

final class RejectDeliveryEntrySuccess extends GuardEntryState{
  final Map<String, dynamic> response;
  RejectDeliveryEntrySuccess({required this.response});
}

final class RejectDeliveryEntryFailure extends GuardEntryState{
  final String message;
  final int? status;

  RejectDeliveryEntryFailure( {required this.message, this.status});
}

///Check in  by code
final class CheckInByCodeLoading extends GuardEntryState{}

final class CheckInByCodeSuccess extends GuardEntryState{
  final Map<String, dynamic> response;
  CheckInByCodeSuccess({required this.response});
}

final class CheckInByCodeFailure extends GuardEntryState{
  final String message;
  final int? status;

  CheckInByCodeFailure( {required this.message, this.status});
}