import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/technician_home/models/resolution_model.dart';
import 'package:gloria_connect/features/technician_home/repository/technician_home_repository.dart';

import '../../../utils/api_error.dart';

part 'technician_home_event.dart';
part 'technician_home_state.dart';

class TechnicianHomeBloc extends Bloc<TechnicianHomeEvent, TechnicianHomeState>{
  final TechnicianHomeRepository _technicianHomeRepository;
  TechnicianHomeBloc({required TechnicianHomeRepository technicianHomeRepository}) : _technicianHomeRepository=technicianHomeRepository, super (TechnicianHomeInitial()){

    on<GetAssignComplaint>((event, emit) async {
      emit(GetAssignComplaintLoading());
      try{
        final List<ResolutionElement> response = await _technicianHomeRepository.getAssignComplaints();
        emit(GetAssignComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetAssignComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetAssignComplaintFailure(message: e.toString()));
        }
      }
    });

    on<GetResolvedComplaint>((event, emit) async {
      emit(GetResolvedComplaintLoading());
      try{
        final List<ResolutionElement> response = await _technicianHomeRepository.getResolvedComplaints();
        emit(GetResolvedComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetResolvedComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetResolvedComplaintFailure(message: e.toString()));
        }
      }
    });

    on<GetTechnicianDetails>((event, emit) async {
      emit(GetTechnicianDetailsLoading());
      try{
        final ResolutionElement response = await _technicianHomeRepository.getTechnicianDetails(complaintId: event.complaintId);
        emit(GetTechnicianDetailsSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetTechnicianDetailsFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetTechnicianDetailsFailure(message: e.toString()));
        }
      }
    });

    on<AddComplaintResolution>((event, emit) async {
      emit(AddComplaintResolutionLoading());
      try{
        final ResolutionElement response = await _technicianHomeRepository.addComplaintResolution(complaintId: event.complaintId, resolutionNote: event.resolutionNote, file: event.file);
        emit(AddComplaintResolutionSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AddComplaintResolutionFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AddComplaintResolutionFailure(message: e.toString()));
        }
      }
    });

    on<ApproveResolution>((event, emit) async {
      emit(ApproveResolutionLoading());
      try{
        final Map<String, dynamic> response = await _technicianHomeRepository.approveResolution(resolutionId: event.resolutionId);
        emit(ApproveResolutionSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ApproveResolutionFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(ApproveResolutionFailure(message: e.toString()));
        }
      }
    });

    on<RejectResolution>((event, emit) async {
      emit(RejectResolutionLoading());
      try{
        final Map<String, dynamic> response = await _technicianHomeRepository.rejectResolution(resolutionId: event.resolutionId, rejectedNote: event.rejectedNote);
        emit(RejectResolutionSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(RejectResolutionFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(RejectResolutionFailure(message: e.toString()));
        }
      }
    });

  }
}