part of 'gate_pass_bloc.dart';

@immutable
sealed class GatePassState{}

final class GatePassInitial extends GatePassState{}

/// To Get Pending Complaint
final class GatePassGetApprovedResLoading extends GatePassState{}

final class GatePassGetApprovedResSuccess extends GatePassState{
  final GatePassModelResident response;
  GatePassGetApprovedResSuccess({required this.response});
}

final class GatePassGetApprovedResFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassGetApprovedResFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class GatePassGetExpiredResLoading extends GatePassState{}

final class GatePassGetExpiredResSuccess extends GatePassState{
  final GatePassModelResident response;
  GatePassGetExpiredResSuccess({required this.response});
}

final class GatePassGetExpiredResFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassGetExpiredResFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class GatePassGetRejectedResLoading extends GatePassState{}

final class GatePassGetRejectedResSuccess extends GatePassState{
  final GatePassModelResident response;
  GatePassGetRejectedResSuccess({required this.response});
}

final class GatePassGetRejectedResFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassGetRejectedResFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class GatePassGetPendingResLoading extends GatePassState{}

final class GatePassGetPendingResSuccess extends GatePassState{
  final List<GatePassBanner> response;
  GatePassGetPendingResSuccess({required this.response});
}

final class GatePassGetPendingResFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassGetPendingResFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class GatePassAddApartmentLoading extends GatePassState{}

final class GatePassAddApartmentSuccess extends GatePassState{
  final GatePassBannerGuard response;
  GatePassAddApartmentSuccess({required this.response});
}

final class GatePassAddApartmentFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassAddApartmentFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class GatePassRemoveApartmentSecurityLoading extends GatePassState{}

final class GatePassRemoveApartmentSecuritySuccess extends GatePassState{
  final GatePassBannerGuard response;
  GatePassRemoveApartmentSecuritySuccess({required this.response});
}

final class GatePassRemoveApartmentSecurityFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassRemoveApartmentSecurityFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class GatePassApproveLoading extends GatePassState{}

final class GatePassApproveSuccess extends GatePassState{
  final Map<String, dynamic> response;
  GatePassApproveSuccess({required this.response});
}

final class GatePassApproveFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassApproveFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class GatePassRejectLoading extends GatePassState{}

final class GatePassRejectSuccess extends GatePassState{
  final Map<String, dynamic> response;
  GatePassRejectSuccess({required this.response});
}

final class GatePassRejectFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassRejectFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class GatePassRemoveApartmentResidentLoading extends GatePassState{}

final class GatePassRemoveApartmentResidentSuccess extends GatePassState{
  final Map<String, dynamic> response;
  GatePassRemoveApartmentResidentSuccess({required this.response});
}

final class GatePassRemoveApartmentResidentFailure extends GatePassState{
  final String message;
  final int? status;

  GatePassRemoveApartmentResidentFailure( {required this.message, this.status});
}

