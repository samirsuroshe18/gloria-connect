part of 'gate_pass_bloc.dart';

@immutable
sealed class GatePassEvent{}

final class GatePassGetApprovedRes extends GatePassEvent{
  final Map<String, dynamic> queryParams;

  GatePassGetApprovedRes({required this.queryParams});
}

final class GatePassGetExpiredRes extends GatePassEvent{
  final Map<String, dynamic> queryParams;

  GatePassGetExpiredRes({required this.queryParams});
}

final class GatePassGetRejectedRes extends GatePassEvent{
  final Map<String, dynamic> queryParams;

  GatePassGetRejectedRes({required this.queryParams});
}

final class GatePassGetPendingRes extends GatePassEvent{}

final class GatePassAddApartment extends GatePassEvent{
  final String id;
  final String email;

  GatePassAddApartment({required this.id, required this.email});
}

final class GatePassRemoveApartmentSecurity extends GatePassEvent{
  final String id;
  final String aptId;

  GatePassRemoveApartmentSecurity({required this.id, required this.aptId});
}

final class GatePassRemoveApartmentResident extends GatePassEvent{
  final String id;

  GatePassRemoveApartmentResident({required this.id});
}

final class GatePassApprove extends GatePassEvent{
  final String id;

  GatePassApprove({required this.id});
}

final class GatePassReject extends GatePassEvent{
  final String id;

  GatePassReject({required this.id});
}
