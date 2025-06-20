part of 'administration_bloc.dart';

@immutable
sealed class AdministrationState{}

final class AdministrationInitial extends AdministrationState{}

///Get pending resident requests
final class AdminGetPendingResidentReqLoading extends AdministrationState{}

final class AdminGetPendingResidentReqSuccess extends AdministrationState{
  final List<ResidentRequestsModel> response;
  AdminGetPendingResidentReqSuccess({required this.response});
}

final class AdminGetPendingResidentReqFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetPendingResidentReqFailure( {required this.message, this.status});
}

///Get pending guard requests
final class AdminGetPendingGuardReqLoading extends AdministrationState{}

final class AdminGetPendingGuardReqSuccess extends AdministrationState{
  final List<GuardRequestsModel> response;
  AdminGetPendingGuardReqSuccess({required this.response});
}

final class AdminGetPendingGuardReqFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetPendingGuardReqFailure( {required this.message, this.status});
}

///Verify guard requests
final class AdminVerifyGuardLoading extends AdministrationState{}

final class AdminVerifyGuardSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminVerifyGuardSuccess({required this.response});
}

final class AdminVerifyGuardFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminVerifyGuardFailure( {required this.message, this.status});
}

///Verify resident requests
final class AdminVerifyResidentLoading extends AdministrationState{}

final class AdminVerifyResidentSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminVerifyResidentSuccess({required this.response});
}

final class AdminVerifyResidentFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminVerifyResidentFailure( {required this.message, this.status});
}

///Get all society resident
final class AdminGetSocietyMemberLoading extends AdministrationState{}

final class AdminGetSocietyMemberSuccess extends AdministrationState{
  final SocietyMemberModel response;
  AdminGetSocietyMemberSuccess({required this.response});
}

final class AdminGetSocietyMemberFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetSocietyMemberFailure( {required this.message, this.status});
}

///Get all society guards
final class AdminGetSocietyGuardLoading extends AdministrationState{}

final class AdminGetSocietyGuardSuccess extends AdministrationState{
  final List<SocietyGuard> response;
  AdminGetSocietyGuardSuccess({required this.response});
}

final class AdminGetSocietyGuardFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetSocietyGuardFailure( {required this.message, this.status});
}

///Get all society Admin
final class AdminGetSocietyAdminLoading extends AdministrationState{}

final class AdminGetSocietyAdminSuccess extends AdministrationState{
  final List<SocietyMember> response;
  AdminGetSocietyAdminSuccess({required this.response});
}

final class AdminGetSocietyAdminFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetSocietyAdminFailure( {required this.message, this.status});
}

///Create admin
final class AdminCreateAdminLoading extends AdministrationState{}

final class AdminCreateAdminSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminCreateAdminSuccess({required this.response});
}

final class AdminCreateAdminFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminCreateAdminFailure( {required this.message, this.status});
}

///remove admin
final class AdminRemoveAdminLoading extends AdministrationState{}

final class AdminRemoveAdminSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminRemoveAdminSuccess({required this.response});
}

final class AdminRemoveAdminFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminRemoveAdminFailure( {required this.message, this.status});
}

///remove resident
final class AdminRemoveResidentLoading extends AdministrationState{}

final class AdminRemoveResidentSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminRemoveResidentSuccess({required this.response});
}

final class AdminRemoveResidentFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminRemoveResidentFailure( {required this.message, this.status});
}

///remove guard
final class AdminRemoveGuardLoading extends AdministrationState{}

final class AdminRemoveGuardSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminRemoveGuardSuccess({required this.response});
}

final class AdminRemoveGuardFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminRemoveGuardFailure( {required this.message, this.status});
}

/// To Get Raising Complaint
final class AdminGetComplaintLoading extends AdministrationState{}

final class AdminGetComplaintSuccess extends AdministrationState{
  final ComplaintModel response;
  AdminGetComplaintSuccess({required this.response});
}

final class AdminGetComplaintFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetComplaintFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class AdminGetPendingComplaintLoading extends AdministrationState{}

final class AdminGetPendingComplaintSuccess extends AdministrationState{
  final ComplaintModel response;
  AdminGetPendingComplaintSuccess({required this.response});
}

final class AdminGetPendingComplaintFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetPendingComplaintFailure( {required this.message, this.status});
}

/// To Get Pending Complaint
final class AdminGetResolvedComplaintLoading extends AdministrationState{}

final class AdminGetResolvedComplaintSuccess extends AdministrationState{
  final ComplaintModel response;
  AdminGetResolvedComplaintSuccess({required this.response});
}

final class AdminGetResolvedComplaintFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetResolvedComplaintFailure( {required this.message, this.status});
}

///add technician
final class AdminAddTechnicianLoading extends AdministrationState{}

final class AdminAddTechnicianSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminAddTechnicianSuccess({required this.response});
}

final class AdminAddTechnicianFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminAddTechnicianFailure( {required this.message, this.status});
}

/// To Get all technician
final class AdminGetTechnicianLoading extends AdministrationState{}

final class AdminGetTechnicianSuccess extends AdministrationState{
  final TechnicianModel response;
  AdminGetTechnicianSuccess({required this.response});
}

final class AdminGetTechnicianFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetTechnicianFailure( {required this.message, this.status});
}

///remove technician
final class AdminRemoveTechnicianLoading extends AdministrationState{}

final class AdminRemoveTechnicianSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminRemoveTechnicianSuccess({required this.response});
}

final class AdminRemoveTechnicianFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminRemoveTechnicianFailure( {required this.message, this.status});
}
