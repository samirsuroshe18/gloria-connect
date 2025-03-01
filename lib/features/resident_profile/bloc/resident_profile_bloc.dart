import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../resident_profile/models/member.dart';
import 'package:gloria_connect/features/resident_profile/repository/resident_profile_repository.dart';

import '../../../utils/api_error.dart';

part 'resident_profile_event.dart';
part 'resident_profile_state.dart';

class ResidentProfileBloc extends Bloc<ResidentProfileEvent, ResidentProfileState>{
  final ResidentProfileRepository _residentProfileRepository;
  ResidentProfileBloc({required ResidentProfileRepository residentProfileRepository}) : _residentProfileRepository=residentProfileRepository, super (ResidentProfileInitial()){

    on<GetApartmentMembers>((event, emit) async {
      emit(GetApartmentMembersLoading());
      try{
        final List<Member> response = await _residentProfileRepository.getApartmentMembers();
        emit(GetApartmentMembersSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetApartmentMembersFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetApartmentMembersFailure(message: e.toString()));
        }
      }
    });

  }
}