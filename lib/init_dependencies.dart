import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/auth/repository/auth_repository.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/repository/administration_repository.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/check_in/repository/check_in_repository.dart';
import 'package:gloria_connect/features/gate_pass/bloc/gate_pass_bloc.dart';
import 'package:gloria_connect/features/gate_pass/repository/gate_pass_repository.dart';
import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
import 'package:gloria_connect/features/guard_duty/repository/guard_duty_repository.dart';
import 'package:gloria_connect/features/guard_entry/bloc/guard_entry_bloc.dart';
import 'package:gloria_connect/features/guard_entry/repository/guard_entry_repository.dart';
import 'package:gloria_connect/features/guard_exit/bloc/guard_exit_bloc.dart';
import 'package:gloria_connect/features/guard_exit/repository/guard_exit_repository.dart';
import 'package:gloria_connect/features/guard_profile/bloc/guard_profile_bloc.dart';
import 'package:gloria_connect/features/guard_profile/repository/guard_profile_repository.dart';
import 'package:gloria_connect/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/repository/guard_waiting_repository.dart';
import 'package:gloria_connect/features/invite_visitors/bloc/invite_visitors_bloc.dart';
import 'package:gloria_connect/features/invite_visitors/repository/invite_visitors_repository.dart';
import 'package:gloria_connect/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gloria_connect/features/my_visitors/repository/my_visitors_repository.dart';
import 'package:gloria_connect/features/notice_board/bloc/notice_board_bloc.dart';
import 'package:gloria_connect/features/notice_board/repository/notice_board_repository.dart';
import 'package:gloria_connect/features/resident_profile/bloc/resident_profile_bloc.dart';
import 'package:gloria_connect/features/resident_profile/repository/resident_profile_repository.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:gloria_connect/features/setting/repository/setting_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies()async {
  _initAuth();
  _initAdministration();
  _initCheckIn();
  _initGuardEntry();
  _initGuardWaiting();
  _initGuardExit();
  _initInviteVisitor();
  _initMyVisitor();
  _initGuardProfile();
  _initResidentProfile();
  _initSetting();
  _initNoticeBoard();
  _initGuardDuty();
  _initGatePass();
}

void _initAuth(){
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  serviceLocator.registerLazySingleton(()=> AuthBloc(authRepository: serviceLocator()));
}

void _initAdministration(){
  serviceLocator.registerLazySingleton<AdministrationRepository>(() => AdministrationRepository());
  serviceLocator.registerLazySingleton(()=> AdministrationBloc(administrationRepository: serviceLocator()));
}

void _initCheckIn(){
  serviceLocator.registerLazySingleton<CheckInRepository>(() => CheckInRepository());
  serviceLocator.registerLazySingleton(()=> CheckInBloc(checkInRepository: serviceLocator()));
}

void _initGuardEntry(){
  serviceLocator.registerLazySingleton<GuardEntryRepository>(() => GuardEntryRepository());
  serviceLocator.registerLazySingleton(()=> GuardEntryBloc(guardEntryRepository: serviceLocator()));
}

void _initGuardWaiting(){
  serviceLocator.registerLazySingleton<GuardWaitingRepository>(() => GuardWaitingRepository());
  serviceLocator.registerLazySingleton(()=> GuardWaitingBloc(guardWaitingRepository: serviceLocator()));
}

void _initGuardExit(){
  serviceLocator.registerLazySingleton<GuardExitRepository>(() => GuardExitRepository());
  serviceLocator.registerLazySingleton(()=> GuardExitBloc(guardExitRepository: serviceLocator()));
}

void _initInviteVisitor(){
  serviceLocator.registerLazySingleton<InviteVisitorsRepository>(() => InviteVisitorsRepository());
  serviceLocator.registerLazySingleton(()=> InviteVisitorsBloc(inviteVisitorsRepository: serviceLocator()));
}

void _initMyVisitor(){
  serviceLocator.registerLazySingleton<MyVisitorsRepository>(() => MyVisitorsRepository());
  serviceLocator.registerLazySingleton(()=> MyVisitorsBloc(myVisitorsRepository: serviceLocator()));
}

void _initGuardProfile(){
  serviceLocator.registerLazySingleton<GuardProfileRepository>(() => GuardProfileRepository());
  serviceLocator.registerLazySingleton(()=> GuardProfileBloc(guardProfileRepository: serviceLocator()));
}

void _initResidentProfile(){
  serviceLocator.registerLazySingleton<ResidentProfileRepository>(() => ResidentProfileRepository());
  serviceLocator.registerLazySingleton(()=> ResidentProfileBloc(residentProfileRepository: serviceLocator()));
}

void _initSetting(){
  serviceLocator.registerLazySingleton<SettingRepository>(() => SettingRepository());
  serviceLocator.registerLazySingleton(()=> SettingBloc(settingRepository: serviceLocator()));
}

void _initNoticeBoard(){
  serviceLocator.registerLazySingleton<NoticeBoardRepository>(() => NoticeBoardRepository());
  serviceLocator.registerLazySingleton(()=> NoticeBoardBloc(noticeBoardRepository: serviceLocator()));
}

void _initGuardDuty(){
  serviceLocator.registerLazySingleton<GuardDutyRepository>(() => GuardDutyRepository());
  serviceLocator.registerLazySingleton(()=> GuardDutyBloc(guardDutyRepository: serviceLocator()));
}

void _initGatePass(){
  serviceLocator.registerLazySingleton<GatePassRepository>(() => GatePassRepository());
  serviceLocator.registerLazySingleton(()=> GatePassBloc(gatePassRepository: serviceLocator()));
}