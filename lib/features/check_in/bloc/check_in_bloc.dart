import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/check_in/repository/check_in_repository.dart';

import '../../../utils/api_error.dart';

part 'check_in_event.dart';
part 'check_in_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final CheckInRepository _checkInRepository;
  FlatState? flatStateInstance;
  CheckInBloc({required CheckInRepository checkInRepository})
      : _checkInRepository = checkInRepository,
        super(CheckInInitial()) {
    on<AddFlat>((event, emit) async {
      flatStateInstance ??= FlatState(selectedFlats: const []);

      final updatedFlats = List<String>.from(flatStateInstance!.selectedFlats);
      if (event.flatName != null) updatedFlats.add(event.flatName!);

      final newState = flatStateInstance!.copyWith(selectedFlats: updatedFlats);
      emit(newState);
      flatStateInstance = newState;
    });

    on<RemoveFlat>((event, emit) async {
      if (flatStateInstance != null) {
        final updatedFlats = List<String>.from(flatStateInstance!.selectedFlats)
          ..remove(event.flatName);
        final newState =
            flatStateInstance!.copyWith(selectedFlats: updatedFlats);
        emit(newState);
        flatStateInstance = newState;
      }
    });

    on<ClearFlat>((event, emit) async {
      if (flatStateInstance != null) {
        final updatedFlats = List<String>.from(flatStateInstance!.selectedFlats)
          ..clear();
        final newState =
            flatStateInstance!.copyWith(selectedFlats: updatedFlats);
        emit(newState);
        flatStateInstance = newState;
      }
      return;
    });

    on<CheckInGetNumber>((event, emit) async {
      emit(CheckInGetNumberLoading());
      try {
        final Map<String, dynamic> response = await _checkInRepository
            .getMobile(mobNumber: event.mobNumber, entryType: event.entryType);
        emit(CheckInGetNumberSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(CheckInGetNumberFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(CheckInGetNumberFailure(message: e.toString()));
        }
      }
    });

    on<CheckInGetBlock>((event, emit) async {
      emit(CheckInGetBlockLoading());
      try {
        final List<String> response = await _checkInRepository.getBlocks();
        emit(CheckInGetBlockSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(CheckInGetBlockFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(CheckInGetBlockFailure(message: e.toString()));
        }
      }
    });

    on<CheckInGetApartment>((event, emit) async {
      emit(CheckInGetApartmentLoading());
      try {
        final List<String> response =
            await _checkInRepository.getApartments(blockName: event.blockName);
        emit(CheckInGetApartmentSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(CheckInGetApartmentFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(CheckInGetApartmentFailure(message: e.toString()));
        }
      }
    });
  }
}
