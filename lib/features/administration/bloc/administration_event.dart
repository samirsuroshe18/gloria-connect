part of 'administration_bloc.dart';

@immutable
sealed class AdministrationEvent{}

final class AdminGetPendingResidentReq extends AdministrationEvent{}

final class AdminGetPendingGuardReq extends AdministrationEvent{}

final class AdminVerifyResident extends AdministrationEvent{
  final String requestId;
  final String user;
  final String residentStatus;

  AdminVerifyResident({required this.requestId, required this.user, required this.residentStatus});
}

final class AdminVerifyGuard extends AdministrationEvent{
  final String requestId;
  final String user;
  final String guardStatus;

  AdminVerifyGuard({required this.requestId, required this.user, required this.guardStatus});
}

final class AdminGetSocietyMember extends AdministrationEvent{
  final Map<String, dynamic> queryParams;

  AdminGetSocietyMember({required this.queryParams});
}

final class AdminGetSocietyGuard extends AdministrationEvent{}

final class AdminGetSocietyAdmin extends AdministrationEvent{}

final class AdminCreateAdmin extends AdministrationEvent{
  final String email;

  AdminCreateAdmin({required this.email});
}

final class AdminRemoveAdmin extends AdministrationEvent{
  final String email;

  AdminRemoveAdmin({required this.email});
}

final class AdminRemoveResident extends AdministrationEvent{
  final String id;

  AdminRemoveResident({required this.id});
}

final class AdminRemoveGuard extends AdministrationEvent{
  final String id;

  AdminRemoveGuard({required this.id});
}

final class AdminGetComplaint extends AdministrationEvent{
  final Map<String, dynamic> queryParams;

  AdminGetComplaint({required this.queryParams});
}

final class AdminGetPendingComplaint extends AdministrationEvent{
  final Map<String, dynamic> queryParams;

  AdminGetPendingComplaint({required this.queryParams});
}

final class AdminGetResolvedComplaint extends AdministrationEvent{
  final Map<String, dynamic> queryParams;

  AdminGetResolvedComplaint({required this.queryParams});
}


final class AdminAddTechnician extends AdministrationEvent{
  final String userName;
  final String email;
  final String phoneNo;
  final String role;

  AdminAddTechnician({required this.userName, required this.email, required this.phoneNo, required this.role});
}

final class AdminGetTechnician extends AdministrationEvent{
  final Map<String, dynamic> queryParams;

  AdminGetTechnician({required this.queryParams});
}

final class AdminRemoveTechnician extends AdministrationEvent{
  final String id;

  AdminRemoveTechnician({required this.id});
}

final class AssignTechnician extends AdministrationEvent{
  final String complaintId;
  final String technicianId;

  AssignTechnician({required this.complaintId, required this.technicianId});
}
