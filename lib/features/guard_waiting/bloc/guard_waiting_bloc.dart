import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/models/entry.dart';
import 'package:gloria_connect/features/guard_waiting/repository/guard_waiting_repository.dart';

import '../../../utils/api_error.dart';

part 'guard_waiting_event.dart';
part 'guard_waiting_state.dart';

class GuardWaitingBloc extends Bloc<GuardWaitingEvent, GuardWaitingState> {
  final GuardWaitingRepository _guardWaitingRepository;
  GuardWaitingBloc({required GuardWaitingRepository guardWaitingRepository})
      : _guardWaitingRepository = guardWaitingRepository,
        super(GuardWaitingInitial()) {
    on<WaitingGetEntries>((event, emit) async {
      emit(WaitingGetEntriesLoading());
      try {
        final List<Entry> response = await _guardWaitingRepository.getEntries();
        emit(WaitingGetEntriesSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(WaitingGetEntriesFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(WaitingGetEntriesFailure(message: e.toString()));
        }
      }
    });

    on<WaitingAllowEntry>((event, emit) async {
      emit(WaitingAllowEntryLoading());
      try {
        final Map<String, dynamic> response =
            await _guardWaitingRepository.allowEntryBySecurity(id: event.id);
        emit(WaitingAllowEntrySuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(WaitingAllowEntryFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(WaitingAllowEntryFailure(message: e.toString()));
        }
      }
    });

    on<WaitingDenyEntry>((event, emit) async {
      emit(WaitingDenyEntryLoading());
      try {
        final Map<String, dynamic> response =
            await _guardWaitingRepository.denyEntryBySecurity(id: event.id);
        emit(WaitingDenyEntrySuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(WaitingDenyEntryFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(WaitingDenyEntryFailure(message: e.toString()));
        }
      }
    });
  }
}
