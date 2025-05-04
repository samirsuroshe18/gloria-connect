part of 'setting_bloc.dart';

@immutable
sealed class SettingEvent{}

final class SettingChangePassword extends SettingEvent{
  final String oldPassword;
  final String newPassword;

  SettingChangePassword({required this.oldPassword, required this.newPassword});
}

final class SettingSubmitComplaint extends SettingEvent{
  final String area;
  final String category;
  final String subCategory;
  final String description;
  final File? file;


  SettingSubmitComplaint({required this.area, required this.category, required this.subCategory, required this.description, this.file});
}

final class SettingGetComplaint extends SettingEvent{
  final Map<String, dynamic> queryParams;

  SettingGetComplaint({required this.queryParams});
}

final class SettingGetPendingComplaint extends SettingEvent{
  final Map<String, dynamic> queryParams;

  SettingGetPendingComplaint({required this.queryParams});
}

final class SettingGetResolvedComplaint extends SettingEvent{
  final Map<String, dynamic> queryParams;

  SettingGetResolvedComplaint({required this.queryParams});
}

final class SettingGetComplaintDetails extends SettingEvent{
  final String id;

  SettingGetComplaintDetails({required this.id});
}

final class SettingAddResponse extends SettingEvent{
  final String id;
  final String message;

  SettingAddResponse({required this.id, required this.message});
}

final class SettingResolve extends SettingEvent{
  final String id;

  SettingResolve({required this.id});
}

final class SettingReopen extends SettingEvent{
  final String id;

  SettingReopen({required this.id});
}

final class SettingGetResponse extends SettingEvent{
  final String id;

  SettingGetResponse({required this.id});
}