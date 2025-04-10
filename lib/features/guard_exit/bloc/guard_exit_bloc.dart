import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_exit/repository/guard_exit_repository.dart';

import '../../../utils/api_error.dart';
import '../../guard_waiting/models/entry.dart';

part 'guard_exit_event.dart';
part 'guard_exit_state.dart';

class GuardExitBloc extends Bloc<GuardExitEvent, GuardExitState>{
  final GuardExitRepository _guardExitRepository;
  GuardExitBloc({required GuardExitRepository guardExitRepository}) : _guardExitRepository=guardExitRepository, super (GuardExitInitial()){

    on<ExitGetAllowedEntries>((event, emit) async {
      emit(ExitGetAllowedEntriesLoading());
      try{
        final List<VisitorEntries> response = await _guardExitRepository.getAllowedEntries();
        emit(ExitGetAllowedEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ExitGetAllowedEntriesFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(ExitGetAllowedEntriesFailure(message: e.toString()));
        }
      }
    });

    on<ExitGetGuestEntries>((event, emit) async {
      emit(ExitGetGuestEntriesLoading());
      try{
        final List<VisitorEntries> response = await _guardExitRepository.getGuestEntries();
        emit(ExitGetGuestEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ExitGetGuestEntriesFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(ExitGetGuestEntriesFailure(message: e.toString()));
        }
      }
    });

    on<ExitGetCabEntries>((event, emit) async {
      emit(ExitGetCabEntriesLoading());
      try{
        final List<VisitorEntries> response = await _guardExitRepository.getCabEntries();
        emit(ExitGetCabEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ExitGetCabEntriesFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(ExitGetCabEntriesFailure(message: e.toString()));
        }
      }
    });

    on<ExitGetDeliveryEntries>((event, emit) async {
      emit(ExitGetDeliveryEntriesLoading());
      try{
        final List<VisitorEntries> response = await _guardExitRepository.getDeliveryEntries();
        emit(ExitGetDeliveryEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ExitGetDeliveryEntriesFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(ExitGetDeliveryEntriesFailure(message: e.toString()));
        }
      }
    });

    on<ExitGetServiceEntries>((event, emit) async {
      emit(ExitGetServiceEntriesLoading());
      try{
        final List<VisitorEntries> response = await _guardExitRepository.getServiceEntries();
        emit(ExitGetServiceEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ExitGetServiceEntriesFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(ExitGetServiceEntriesFailure(message: e.toString()));
        }
      }
    });

    on<ExitEntry>((event, emit) async {
      emit(ExitEntryLoading());
      try{
        final Map<String, dynamic> response = await _guardExitRepository.exitEntry(id: event.id, entryType: event.entryType);
        emit(ExitEntrySuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ExitEntryFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(ExitEntryFailure(message: e.toString()));
        }
      }
    });

  }
}