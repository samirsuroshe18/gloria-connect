import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_entry/repository/guard_entry_repository.dart';

import '../../../utils/api_error.dart';

part 'guard_entry_event.dart';
part 'guard_entry_state.dart';

class GuardEntryBloc extends Bloc<GuardEntryEvent, GuardEntryState>{
  final GuardEntryRepository _guardEntryRepository;
  GuardEntryBloc({required GuardEntryRepository guardEntryRepository}) : _guardEntryRepository=guardEntryRepository, super (GuardEntryInitial()){

    on<AddDeliveryEntry>((event, emit) async {
      emit(AddDeliveryEntryLoading());
      try{
        final Map<String, dynamic> response = await _guardEntryRepository.addDeliveryEntry(name: event.name, mobNumber: event.mobNumber, profileImg: event.profileImg, companyName: event.companyName, companyLogo: event.companyLogo, serviceName: event.serviceName, serviceLogo: event.serviceLogo, accompanyingGuest: event.accompanyingGuest, vehicleType: event.vehicleType, vehicleNumber: event.vehicleNumber, entryType: event.entryType, societyName: event.societyName, societyApartments: event.societyApartments, societyGates: event.societyGates);
        emit(AddDeliveryEntrySuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AddDeliveryEntryFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(AddDeliveryEntryFailure(message: e.toString()));
        }
      }
    });

    on<ApproveDeliveryEntry>((event, emit) async {
      emit(ApproveDeliveryEntryLoading());
      try{
        final Map<String, dynamic> response = await _guardEntryRepository.approveDeliveryEntry(id: event.id);
        emit(ApproveDeliveryEntrySuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(ApproveDeliveryEntryFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(ApproveDeliveryEntryFailure(message: e.toString()));
        }
      }
    });

    on<RejectDeliveryEntry>((event, emit) async {
      emit(RejectDeliveryEntryLoading());
      try{
        final Map<String, dynamic> response = await _guardEntryRepository.rejectDeliveryEntry(id: event.id);
        emit(RejectDeliveryEntrySuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(RejectDeliveryEntryFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(RejectDeliveryEntryFailure(message: e.toString()));
        }
      }
    });

    on<CheckInByCode>((event, emit) async {
      emit(CheckInByCodeLoading());
      try{
        final Map<String, dynamic> response = await _guardEntryRepository.checkInByCode(checkInCode: event.checkInCode);
        emit(CheckInByCodeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(CheckInByCodeFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(CheckInByCodeFailure(message: e.toString()));
        }
      }
    });

  }
}