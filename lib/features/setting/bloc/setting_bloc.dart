import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:gloria_connect/features/setting/repository/setting_repository.dart';

import '../../../utils/api_error.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState>{
  final SettingRepository _settingRepository;
  SettingBloc({required SettingRepository settingRepository}) : _settingRepository=settingRepository, super (SettingInitial()){

    on<SettingChangePassword>((event, emit) async {
      emit(SettingChangePassLoading());
      try{
        final Map<String, dynamic> response = await _settingRepository.changePassword(oldPassword: event.oldPassword, newPassword: event.newPassword);
        emit(SettingChangePassSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingChangePassFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingChangePassFailure(message: e.toString()));
        }
      }
    });

    on<SettingSubmitComplaint>((event, emit) async {
      emit(SettingSubmitComplaintLoading());
      try{
        final Map<String, dynamic> response = await _settingRepository.submitComplaint(area: event.area, category: event.category, subCategory: event.subCategory, description: event.description, file: event.file);
        emit(SettingSubmitComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingSubmitComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingSubmitComplaintFailure(message: e.toString()));
        }
      }
    });

    on<SettingGetComplaint>((event, emit) async {
      emit(SettingGetComplaintLoading());
      try{
        final ComplaintModel response = await _settingRepository.getComplaints(queryParams: event.queryParams);
        emit(SettingGetComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingGetComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingGetComplaintFailure(message: e.toString()));
        }
      }
    });

    on<SettingGetComplaintDetails>((event, emit) async {
      emit(SettingGetComplaintDetailsLoading());
      try{
        final Complaint response = await _settingRepository.getComplaintDetails(id: event.id);
        emit(SettingGetComplaintDetailsSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingGetComplaintDetailsFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingGetComplaintDetailsFailure(message: e.toString()));
        }
      }
    });

    on<SettingAddResponse>((event, emit) async {
      emit(SettingAddResponseLoading());
      try{
        final Complaint response = await _settingRepository.addResponse(id: event.id, message: event.message);
        emit(SettingAddResponseSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingAddResponseFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingAddResponseFailure(message: e.toString()));
        }
      }
    });

    on<SettingResolve>((event, emit) async {
      emit(SettingResolveLoading());
      try{
        final Complaint response = await _settingRepository.resolve(id: event.id);
        emit(SettingResolveSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingResolveFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingResolveFailure(message: e.toString()));
        }
      }
    });

    on<SettingReopen>((event, emit) async {
      emit(SettingReopenLoading());
      try{
        final Complaint response = await _settingRepository.reopen(id: event.id);
        emit(SettingReopenSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingReopenFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingReopenFailure(message: e.toString()));
        }
      }
    });

    on<SettingGetResponse>((event, emit) async {
      emit(SettingGetResponseLoading());
      try{
        final Complaint response = await _settingRepository.getResponse(id: event.id);
        emit(SettingGetResponseSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingGetResponseFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingGetResponseFailure(message: e.toString()));
        }
      }
    });

    on<SettingGetPendingComplaint>((event, emit) async {
      emit(SettingGetPendingComplaintLoading());
      try{
        final ComplaintModel response = await _settingRepository.getPendingComplaints(queryParams: event.queryParams);
        emit(SettingGetPendingComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingGetPendingComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingGetPendingComplaintFailure(message: e.toString()));
        }
      }
    });

    on<SettingGetResolvedComplaint>((event, emit) async {
      emit(SettingGetResolvedComplaintLoading());
      try{
        final ComplaintModel response = await _settingRepository.getResolvedComplaints(queryParams: event.queryParams);
        emit(SettingGetResolvedComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingGetResolvedComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingGetResolvedComplaintFailure(message: e.toString()));
        }
      }
    });

  }
}