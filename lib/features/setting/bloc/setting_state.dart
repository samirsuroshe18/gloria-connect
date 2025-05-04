part of 'setting_bloc.dart';

@immutable
sealed class SettingState{}

final class SettingInitial extends SettingState{}

/// For Change password
final class SettingChangePassLoading extends SettingState{}

final class SettingChangePassSuccess extends SettingState{
  final Map<String, dynamic> response;
  SettingChangePassSuccess({required this.response});
}

final class SettingChangePassFailure extends SettingState{
  final String message;
  final int? status;

  SettingChangePassFailure( {required this.message, this.status});
}

/// For Raising Complaint
final class SettingSubmitComplaintLoading extends SettingState{}

final class SettingSubmitComplaintSuccess extends SettingState{
  final Map<String, dynamic> response;
  SettingSubmitComplaintSuccess({required this.response});
}

final class SettingSubmitComplaintFailure extends SettingState{
  final String message;
  final int? status;

  SettingSubmitComplaintFailure( {required this.message, this.status});
}

/// To Get Raising Complaint
final class SettingGetComplaintLoading extends SettingState{}

final class SettingGetComplaintSuccess extends SettingState{
  final ComplaintModel response;
  SettingGetComplaintSuccess({required this.response});
}

final class SettingGetComplaintFailure extends SettingState{
  final String message;
  final int? status;

  SettingGetComplaintFailure( {required this.message, this.status});
}

/// To Get Raising Complaint
final class SettingGetPendingComplaintLoading extends SettingState{}

final class SettingGetPendingComplaintSuccess extends SettingState{
  final ComplaintModel response;
  SettingGetPendingComplaintSuccess({required this.response});
}

final class SettingGetPendingComplaintFailure extends SettingState{
  final String message;
  final int? status;

  SettingGetPendingComplaintFailure( {required this.message, this.status});
}

/// To Get Raising Complaint
final class SettingGetResolvedComplaintLoading extends SettingState{}

final class SettingGetResolvedComplaintSuccess extends SettingState{
  final ComplaintModel response;
  SettingGetResolvedComplaintSuccess({required this.response});
}

final class SettingGetResolvedComplaintFailure extends SettingState{
  final String message;
  final int? status;

  SettingGetResolvedComplaintFailure( {required this.message, this.status});
}

/// To add response
final class SettingGetComplaintDetailsLoading extends SettingState{}

final class SettingGetComplaintDetailsSuccess extends SettingState{
  final Complaint response;
  SettingGetComplaintDetailsSuccess({required this.response});
}

final class SettingGetComplaintDetailsFailure extends SettingState{
  final String message;
  final int? status;

  SettingGetComplaintDetailsFailure( {required this.message, this.status});
}

/// To add response
final class SettingAddResponseLoading extends SettingState{}

final class SettingAddResponseSuccess extends SettingState{
  final Complaint response;
  SettingAddResponseSuccess({required this.response});
}

final class SettingAddResponseFailure extends SettingState{
  final String message;
  final int? status;

  SettingAddResponseFailure( {required this.message, this.status});
}

/// To resolve
final class SettingResolveLoading extends SettingState{}

final class SettingResolveSuccess extends SettingState{
  final Complaint response;
  SettingResolveSuccess({required this.response});
}

final class SettingResolveFailure extends SettingState{
  final String message;
  final int? status;

  SettingResolveFailure( {required this.message, this.status});
}

/// To reopen
final class SettingReopenLoading extends SettingState{}

final class SettingReopenSuccess extends SettingState{
  final Complaint response;
  SettingReopenSuccess({required this.response});
}

final class SettingReopenFailure extends SettingState{
  final String message;
  final int? status;

  SettingReopenFailure( {required this.message, this.status});
}

/// To get response messages
final class SettingGetResponseLoading extends SettingState{}

final class SettingGetResponseSuccess extends SettingState{
  final Complaint response;
  SettingGetResponseSuccess({required this.response});
}

final class SettingGetResponseFailure extends SettingState{
  final String message;
  final int? status;

  SettingGetResponseFailure( {required this.message, this.status});
}