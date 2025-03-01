import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:gloria_connect/features/invite_visitors/repository/invite_visitors_repository.dart';

import '../../../utils/api_error.dart';

part 'invite_visitors_event.dart';
part 'invite_visitors_state.dart';

class InviteVisitorsBloc
    extends Bloc<InviteVisitorsEvent, InviteVisitorsState> {
  final InviteVisitorsRepository _inviteVisitorsRepository;
  InviteVisitorsBloc(
      {required InviteVisitorsRepository inviteVisitorsRepository})
      : _inviteVisitorsRepository = inviteVisitorsRepository,
        super(InviteVisitorsInitial()) {
    on<AddPreApproveEntry>((event, emit) async {
      emit(AddPreApproveEntryLoading());
      try {
        final PreApprovedBanner response =
            await _inviteVisitorsRepository.addPreApproval(
                name: event.name,
                mobNumber: event.mobNumber,
                profileImg: event.profileImg,
                companyName: event.companyName,
                companyLogo: event.companyLogo,
                serviceName: event.serviceName,
                serviceLogo: event.serviceLogo,
                vehicleNumber: event.vehicleNumber,
                entryType: event.entryType,
                checkInCodeStartDate: event.checkInCodeStartDate,
                checkInCodeExpiryDate: event.checkInCodeExpiryDate,
                checkInCodeStart: event.checkInCodeStart,
                checkInCodeExpiry: event.checkInCodeExpiry);
        emit(AddPreApproveEntrySuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(AddPreApproveEntryFailure(
              message: e.message.toString(), status: e.statusCode));
        } else {
          emit(AddPreApproveEntryFailure(message: e.toString()));
        }
      }
    });
  }
}
