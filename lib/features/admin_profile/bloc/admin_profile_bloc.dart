import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/admin_profile/repository/admin_profile_repository.dart';

part 'admin_profile_event.dart';
part 'admin_profile_state.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState>{
  // ignore: unused_field
  final AdminProfileRepository _adminProfileRepository;
  // ignore: empty_constructor_bodies
  AdminProfileBloc({required AdminProfileRepository adminProfileRepository}) : _adminProfileRepository=adminProfileRepository, super (AdminProfileInitial()){

  }
}