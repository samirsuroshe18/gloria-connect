part of 'guard_profile_bloc.dart';

@immutable
sealed class GuardProfileState{}

final class GuardProfileInitial extends GuardProfileState{}

/// Update Account details
final class GuardUpdateDetailsLoading extends GuardProfileState{}

final class GuardUpdateDetailsSuccess extends GuardProfileState{
  final Map<String, dynamic> response;
  GuardUpdateDetailsSuccess({required this.response});
}

final class GuardUpdateDetailsFailure extends GuardProfileState{
  final String message;
  final int? status;

  GuardUpdateDetailsFailure( {required this.message, this.status});
}

/// Get Checkout history
final class GetCheckoutHistoryLoading extends GuardProfileState{}

final class GetCheckoutHistorySuccess extends GuardProfileState{
  final CheckoutHistoryModel response;
  GetCheckoutHistorySuccess({required this.response});
}

final class GetCheckoutHistoryFailure extends GuardProfileState{
  final String message;
  final int? status;

  GetCheckoutHistoryFailure( {required this.message, this.status});
}

/// Add gate pass
final class AddGatePassLoading extends GuardProfileState{}

final class AddGatePassSuccess extends GuardProfileState{
  final GatePassBannerGuard response;
  AddGatePassSuccess({required this.response});
}

final class AddGatePassFailure extends GuardProfileState{
  final String message;
  final int? status;

  AddGatePassFailure( {required this.message, this.status});
}

/// Get Checkout history
final class GetGatePassLoading extends GuardProfileState{}

final class GetGatePassSuccess extends GuardProfileState{
  final GatePassModel response;
  GetGatePassSuccess({required this.response});
}

final class GetGatePassFailure extends GuardProfileState{
  final String message;
  final int? status;

  GetGatePassFailure( {required this.message, this.status});
}

/// Get Pending gate pass
final class GetPendingGatePassLoading extends GuardProfileState{}

final class GetPendingGatePassSuccess extends GuardProfileState{
  final List<GatePassBannerGuard> response;
  GetPendingGatePassSuccess({required this.response});
}

final class GetPendingGatePassFailure extends GuardProfileState{
  final String message;
  final int? status;

  GetPendingGatePassFailure( {required this.message, this.status});
}

/// Get Checkout history
final class GetExpiredGatePassSecurityLoading extends GuardProfileState{}

final class GetExpiredGatePassSecuritySuccess extends GuardProfileState{
  final GatePassModel response;
  GetExpiredGatePassSecuritySuccess({required this.response});
}

final class GetExpiredGatePassSecurityFailure extends GuardProfileState{
  final String message;
  final int? status;

  GetExpiredGatePassSecurityFailure( {required this.message, this.status});
}

/// Get Checkout history
final class GetGatePassDetailsLoading extends GuardProfileState{}

final class GetGatePassDetailsSuccess extends GuardProfileState{
  final GatePassBannerGuard response;
  GetGatePassDetailsSuccess({required this.response});
}

final class GetGatePassDetailsFailure extends GuardProfileState{
  final String message;
  final int? status;

  GetGatePassDetailsFailure( {required this.message, this.status});
}

/// Get Checkout history
final class RemoveGetGatePassLoading extends GuardProfileState{}

final class RemoveGetGatePassSuccess extends GuardProfileState{
  final Map<String, dynamic> response;
  RemoveGetGatePassSuccess({required this.response});
}

final class RemoveGetGatePassFailure extends GuardProfileState{
  final String message;
  final int? status;

  RemoveGetGatePassFailure( {required this.message, this.status});
}