import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_duty/model/guard_info_model.dart';
import 'package:gloria_connect/features/guard_duty/model/guard_log_model.dart';
import 'package:gloria_connect/features/guard_duty/repository/guard_duty_repository.dart';
import 'package:gloria_connect/utils/api_error.dart';

part 'guard_duty_event.dart';
part 'guard_duty_state.dart';

class GuardDutyBloc extends Bloc<GuardDutyEvent, GuardDutyState>{
  final GuardDutyRepository _guardDutyRepository;
  GuardDutyBloc({required GuardDutyRepository guardDutyRepository}) : _guardDutyRepository=guardDutyRepository, super (GuardDutyInitial()){

    on<GuardDutyCheckIn>((event, emit) async {
      emit(GuardDutyCheckInLoading());
      try{
        final Map<String, dynamic> response = await _guardDutyRepository.guardDutyCheckin(gate: event.gate, checkinReason: event.checkinReason, shift: event.shift);
        emit(GuardDutyCheckInSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GuardDutyCheckInFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GuardDutyCheckInFailure(message: e.toString()));
        }
      }
    });

    on<GuardDutyCheckOut>((event, emit) async {
      emit(GuardDutyCheckOutLoading());
      try{
        final Map<String, dynamic> response = await _guardDutyRepository.guardDutyCheckout(checkoutReason: event.checkoutReason);
        emit(GuardDutyCheckOutSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GuardDutyCheckOutFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GuardDutyCheckOutFailure(message: e.toString()));
        }
      }
    });

    on<GuardGetLogs>((event, emit) async {
      emit(GuardGetLogsLoading());
      try{
        final GuardLogModel response = await _guardDutyRepository.getGuardLogs(queryParams: event.queryParams);
        emit(GuardGetLogsSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GuardGetLogsFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GuardGetLogsFailure(message: e.toString()));
        }
      }
    });

    on<GetGuardInfo>((event, emit) async {
      emit(GetGuardInfoLoading());
      try{
        final GuardInfoModel response = await _guardDutyRepository.getGuardInfo(id: event.id);
        emit(GetGuardInfoSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetGuardInfoFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetGuardInfoFailure(message: e.toString()));
        }
      }
    });

  }
}