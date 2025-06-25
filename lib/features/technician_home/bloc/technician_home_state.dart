part of 'technician_home_bloc.dart';

@immutable
sealed class TechnicianHomeState{}

final class TechnicianHomeInitial extends TechnicianHomeState{}

/// Get assigning complaint
final class GetAssignComplaintLoading extends TechnicianHomeState{}

final class GetAssignComplaintSuccess extends TechnicianHomeState{
  final List<ResolutionElement> response;
  GetAssignComplaintSuccess({required this.response});
}

final class GetAssignComplaintFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  GetAssignComplaintFailure( {required this.message, this.status});
}

/// Get resolved complaint
final class GetResolvedComplaintLoading extends TechnicianHomeState{}

final class GetResolvedComplaintSuccess extends TechnicianHomeState{
  final List<ResolutionElement> response;
  GetResolvedComplaintSuccess({required this.response});
}

final class GetResolvedComplaintFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  GetResolvedComplaintFailure( {required this.message, this.status});
}

/// Add complaint Resolution.
final class GetTechnicianDetailsLoading extends TechnicianHomeState{}

final class GetTechnicianDetailsSuccess extends TechnicianHomeState{
  final ResolutionElement response;
  GetTechnicianDetailsSuccess({required this.response});
}

final class GetTechnicianDetailsFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  GetTechnicianDetailsFailure( {required this.message, this.status});
}

/// Add complaint Resolution.
final class AddComplaintResolutionLoading extends TechnicianHomeState{}

final class AddComplaintResolutionSuccess extends TechnicianHomeState{
  final ResolutionElement response;
  AddComplaintResolutionSuccess({required this.response});
}

final class AddComplaintResolutionFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  AddComplaintResolutionFailure( {required this.message, this.status});
}

/// Approve complaint Resolution.
final class ApproveResolutionLoading extends TechnicianHomeState{}

final class ApproveResolutionSuccess extends TechnicianHomeState{
  final Map<String, dynamic> response;
  ApproveResolutionSuccess({required this.response});
}

final class ApproveResolutionFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  ApproveResolutionFailure( {required this.message, this.status});
}

/// Reject complaint Resolution.
final class RejectResolutionLoading extends TechnicianHomeState{}

final class RejectResolutionSuccess extends TechnicianHomeState{
  final Map<String, dynamic> response;
  RejectResolutionSuccess({required this.response});
}

final class RejectResolutionFailure extends TechnicianHomeState{
  final String message;
  final int? status;

  RejectResolutionFailure( {required this.message, this.status});
}