import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/gate_pass/models/gate_pass_model.dart';
import 'package:gloria_connect/features/gate_pass/repository/gate_pass_repository.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';

import '../../../utils/api_error.dart';

part 'gate_pass_event.dart';
part 'gate_pass_state.dart';

class GatePassBloc extends Bloc<GatePassEvent, GatePassState>{
  final GatePassRepository _gatePassRepository;
  GatePassBloc({required GatePassRepository gatePassRepository}) : _gatePassRepository=gatePassRepository, super (GatePassInitial()){

    on<GatePassGetApprovedRes>((event, emit) async {
      emit(GatePassGetApprovedResLoading());
      try{
        final GatePassModelResident response = await _gatePassRepository.getGatePassApproveRes(queryParams: event.queryParams);
        emit(GatePassGetApprovedResSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassGetApprovedResFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassGetApprovedResFailure(message: e.toString()));
        }
      }
    });

    on<GatePassGetExpiredRes>((event, emit) async {
      emit(GatePassGetExpiredResLoading());
      try{
        final GatePassModelResident response = await _gatePassRepository.getGatePassExpiredRes(queryParams: event.queryParams);
        emit(GatePassGetExpiredResSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassGetExpiredResFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassGetExpiredResFailure(message: e.toString()));
        }
      }
    });

    on<GatePassGetRejectedRes>((event, emit) async {
      emit(GatePassGetRejectedResLoading());
      try{
        final GatePassModelResident response = await _gatePassRepository.getGatePassRejectedRes(queryParams: event.queryParams);
        emit(GatePassGetRejectedResSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassGetRejectedResFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassGetRejectedResFailure(message: e.toString()));
        }
      }
    });

    on<GatePassGetPendingRes>((event, emit) async {
      emit(GatePassGetPendingResLoading());
      try{
        final List<GatePassBanner> response = await _gatePassRepository.getPendingGatePass();
        emit(GatePassGetPendingResSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassGetPendingResFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassGetPendingResFailure(message: e.toString()));
        }
      }
    });

    on<GatePassApprove>((event, emit) async {
      emit(GatePassApproveLoading());
      try{
        final Map<String, dynamic> response = await _gatePassRepository.approveGatePass(id: event.id);
        emit(GatePassApproveSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassApproveFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassApproveFailure(message: e.toString()));
        }
      }
    });

    on<GatePassReject>((event, emit) async {
      emit(GatePassRejectLoading());
      try{
        final Map<String, dynamic> response = await _gatePassRepository.rejectGatePass(id: event.id);
        emit(GatePassRejectSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassRejectFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassRejectFailure(message: e.toString()));
        }
      }
    });

    on<GatePassRemoveApartmentResident>((event, emit) async {
      emit(GatePassRemoveApartmentResidentLoading());
      try{
        final Map<String, dynamic> response = await _gatePassRepository.removeApartmentResident(id: event.id);
        emit(GatePassRemoveApartmentResidentSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassRemoveApartmentResidentFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassRemoveApartmentResidentFailure(message: e.toString()));
        }
      }
    });

    on<GatePassRemoveApartmentSecurity>((event, emit) async {
      emit(GatePassRemoveApartmentSecurityLoading());
      try{
        final GatePassBannerGuard response = await _gatePassRepository.removeApartmentSecurity(id: event.id, aptId: event.aptId);
        emit(GatePassRemoveApartmentSecuritySuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassRemoveApartmentSecurityFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassRemoveApartmentSecurityFailure(message: e.toString()));
        }
      }
    });

    on<GatePassAddApartment>((event, emit) async {
      emit(GatePassAddApartmentLoading());
      try{
        final GatePassBannerGuard response = await _gatePassRepository.addApartmentSecurity(id: event.id, email: event.email);
        emit(GatePassAddApartmentSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GatePassAddApartmentFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GatePassAddApartmentFailure(message: e.toString()));
        }
      }
    });

  }
}