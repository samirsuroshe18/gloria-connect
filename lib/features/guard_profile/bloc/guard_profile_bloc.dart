import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/features/guard_profile/models/checkout_history.dart';
import 'package:gloria_connect/features/guard_profile/repository/guard_profile_repository.dart';

import '../../../utils/api_error.dart';

part 'guard_profile_event.dart';
part 'guard_profile_state.dart';

class GuardProfileBloc extends Bloc<GuardProfileEvent, GuardProfileState>{
  final GuardProfileRepository _guardProfileRepository;
  GuardProfileBloc({required GuardProfileRepository guardProfileRepository}) : _guardProfileRepository=guardProfileRepository, super (GuardProfileInitial()){

    on<GuardUpdateDetails>((event, emit) async {
      emit(GuardUpdateDetailsLoading());
      try{
        final Map<String, dynamic> response = await _guardProfileRepository.updateDetails(userName: event.userName, profile: event.profile);
        emit(GuardUpdateDetailsSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GuardUpdateDetailsFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(GuardUpdateDetailsFailure(message: e.toString()));
        }
      }
    });

    on<GetCheckoutHistory>((event, emit) async {
      emit(GetCheckoutHistoryLoading());
      try{
        final CheckoutHistoryModel response = await _guardProfileRepository.getCheckoutHistory(queryParams: event.queryParams);
        emit(GetCheckoutHistorySuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetCheckoutHistoryFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetCheckoutHistoryFailure(message: e.toString()));
        }
      }
    });

    on<AddGatePass>((event, emit) async {
      emit(AddGatePassLoading());
      try{
        final GatePassBannerGuard response = await _guardProfileRepository.addGatePass(name: event.name, profile: event.profile, mobNumber: event.mobNumber, serviceName: event.serviceName, serviceLogo: event.serviceLogo, gender: event.gender, address: event.address, addressProof: event.addressProof, gatepassAptDetails: event.gatepassAptDetails, checkInCodeStartDate: event.checkInCodeStartDate, checkInCodeExpiryDate: event.checkInCodeExpiryDate, checkInCodeStart: event.checkInCodeStart, checkInCodeExpiry: event.checkInCodeExpiry);
        emit(AddGatePassSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AddGatePassFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AddGatePassFailure(message: e.toString()));
        }
      }
    });

    on<GetGatePass>((event, emit) async {
      emit(GetGatePassLoading());
      try{
        final GatePassModel response = await _guardProfileRepository.getGatePass(queryParams: event.queryParams);
        emit(GetGatePassSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetGatePassFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetGatePassFailure(message: e.toString()));
        }
      }
    });

    on<GetPendingGatePass>((event, emit) async {
      emit(GetPendingGatePassLoading());
      try{
        final List<GatePassBannerGuard> response = await _guardProfileRepository.getPendingGatePass();
        emit(GetPendingGatePassSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetPendingGatePassFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetPendingGatePassFailure(message: e.toString()));
        }
      }
    });

    on<GetExpiredGatePassSecurity>((event, emit) async {
      emit(GetExpiredGatePassSecurityLoading());
      try{
        final GatePassModel response = await _guardProfileRepository.getExpiredGatePassSecurity(queryParams: event.queryParams);
        emit(GetExpiredGatePassSecuritySuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetExpiredGatePassSecurityFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetExpiredGatePassSecurityFailure(message: e.toString()));
        }
      }
    });

    on<GetGatePassDetails>((event, emit) async {
      emit(GetGatePassDetailsLoading());
      try{
        final GatePassBannerGuard response = await _guardProfileRepository.getGatePassDetails(id: event.id);
        emit(GetGatePassDetailsSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetGatePassDetailsFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetGatePassDetailsFailure(message: e.toString()));
        }
      }
    });

    on<RemoveGatePass>((event, emit) async {
      emit(RemoveGetGatePassLoading());
      try{
        final Map<String, dynamic> response = await _guardProfileRepository.removeGatePass(id: event.id);
        emit(RemoveGetGatePassSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(RemoveGetGatePassFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(RemoveGetGatePassFailure(message: e.toString()));
        }
      }
    });

  }
}