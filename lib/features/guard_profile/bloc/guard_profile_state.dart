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
  final List<CheckoutHistory> response;
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
  final GatePassBanner response;
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
  final List<GatePassBanner> response;
  GetGatePassSuccess({required this.response});
}

final class GetGatePassFailure extends GuardProfileState{
  final String message;
  final int? status;

  GetGatePassFailure( {required this.message, this.status});
}