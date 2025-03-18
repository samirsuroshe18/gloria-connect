part of 'auth_bloc.dart';

@immutable
sealed class AuthState{}

final class AuthInitial extends AuthState{}

/// For Login State
final class AuthLoginLoading extends AuthState{}

final class AuthLoginSuccess extends AuthState{
  final GetUserModel response;
  AuthLoginSuccess({required this.response});
}

final class AuthLoginFailure extends AuthState{
  final String message;
  final int? status;

  AuthLoginFailure( {required this.message, this.status});
}

/// For Register state
final class AuthRegisterLoading extends AuthState{}

final class AuthRegisterSuccess extends AuthState{
  final dynamic response;
  AuthRegisterSuccess({this.response});
}

final class AuthRegisterFailure extends AuthState{
  final String message;
  final int? status;

  AuthRegisterFailure( {required this.message, this.status});
}

/// For Forgot Password state
final class AuthForgotPassLoading extends AuthState{}

final class AuthForgotPassSuccess extends AuthState{
  final dynamic response;
  AuthForgotPassSuccess({this.response});
}

final class AuthForgotPassFailure extends AuthState{
  final String message;
  final int? status;

  AuthForgotPassFailure( {required this.message, this.status});
}

/// For Google Signing state
final class AuthGoogleSigningLoading extends AuthState{}

final class AuthGoogleSigningSuccess extends AuthState{
  final GetUserModel response;
  AuthGoogleSigningSuccess({required this.response});
}

final class AuthGoogleSigningFailure extends AuthState{
  final String message;
  final int? status;

  AuthGoogleSigningFailure( {required this.message, this.status});
}

/// To link google account to your existing account
final class AuthGoogleLinkedLoading extends AuthState{}

final class AuthGoogleLinkedSuccess extends AuthState{
  final Map<String, dynamic> response;
  AuthGoogleLinkedSuccess({required this.response});
}

final class AuthGoogleLinkedFailure extends AuthState{
  final String message;
  final int? status;

  AuthGoogleLinkedFailure( {required this.message, this.status});
}

/// Logout user
final class AuthLogoutLoading extends AuthState{}

final class AuthLogoutSuccess extends AuthState{
  final Map<String, dynamic> response;
  AuthLogoutSuccess({required this.response});
}

final class AuthLogoutFailure extends AuthState{
  final String message;
  final int? status;

  AuthLogoutFailure( {required this.message, this.status});
}

/// Get user
final class AuthGetUserLoading extends AuthState{}

final class AuthGetUserSuccess extends AuthState{
  final GetUserModel response;
  AuthGetUserSuccess({required this.response});
}

final class AuthGetUserFailure extends AuthState{
  final String message;
  final int? status;

  AuthGetUserFailure( {required this.message, this.status});
}

/// Get Extra info
final class AuthCompleteProfileLoading extends AuthState{}

final class AuthCompleteProfileSuccess extends AuthState{
  final GetUserModel response;
  AuthCompleteProfileSuccess({required this.response});
}

final class AuthCompleteProfileFailure extends AuthState{
  final String message;
  final int? status;

  AuthCompleteProfileFailure( {required this.message, this.status});
}

/// Add Apartment
final class AuthAddApartmentLoading extends AuthState{}

final class AuthAddApartmentSuccess extends AuthState{
  final Map<String, dynamic> response;
  AuthAddApartmentSuccess({required this.response});
}

final class AuthAddApartmentFailure extends AuthState{
  final String message;
  final int? status;

  AuthAddApartmentFailure( {required this.message, this.status});
}

/// Add Gate
final class AuthAddGateLoading extends AuthState{}

final class AuthAddGateSuccess extends AuthState{
  final Map<String, dynamic> response;
  AuthAddGateSuccess({required this.response});
}

final class AuthAddGateFailure extends AuthState{
  final String message;
  final int? status;

  AuthAddGateFailure( {required this.message, this.status});
}

/// Update FCM Token
final class AuthUpdateFCMLoading extends AuthState{}

final class AuthUpdateFCMSuccess extends AuthState{
  final Map<String, dynamic> response;
  AuthUpdateFCMSuccess({required this.response});
}

final class AuthUpdateFCMFailure extends AuthState{
  final String message;
  final int? status;

  AuthUpdateFCMFailure( {required this.message, this.status});
}

///Get society details
final class AuthSocietyDetailsLoading extends AuthState{}

final class AuthSocietyDetailsSuccess extends AuthState{
  final List<Society> response;
  AuthSocietyDetailsSuccess({required this.response});
}

final class AuthSocietyDetailsFailure extends AuthState{
  final String message;
  final int? status;

  AuthSocietyDetailsFailure( {required this.message, this.status});
}

/// Get contact email
final class AuthGetContactEmailLoading extends AuthState{}

final class AuthGetContactEmailSuccess extends AuthState{
  final Map<String, dynamic> response;
  AuthGetContactEmailSuccess({required this.response});
}

final class AuthGetContactEmailFailure extends AuthState{
  final String message;
  final int? status;

  AuthGetContactEmailFailure( {required this.message, this.status});
}
