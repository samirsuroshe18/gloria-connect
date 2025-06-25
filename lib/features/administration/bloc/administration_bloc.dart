import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/administration/models/guard_requests_model.dart';
import 'package:gloria_connect/features/administration/models/resident_requests_model.dart';
import 'package:gloria_connect/features/administration/models/society_guard.dart';
import 'package:gloria_connect/features/administration/models/society_member.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';
import 'package:gloria_connect/features/administration/repository/administration_repository.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';

import '../../../utils/api_error.dart';

part 'administration_event.dart';
part 'administration_state.dart';

class AdministrationBloc extends Bloc<AdministrationEvent, AdministrationState>{
  final AdministrationRepository _administrationRepository;
  AdministrationBloc({required AdministrationRepository administrationRepository}) : _administrationRepository=administrationRepository, super (AdministrationInitial()){

    on<AdminGetPendingResidentReq>((event, emit) async {
      emit(AdminGetPendingResidentReqLoading());
      try{
        final List<ResidentRequestsModel> response = await _administrationRepository.getPendingResidentRequest();
        emit(AdminGetPendingResidentReqSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetPendingResidentReqFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetPendingResidentReqFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetPendingGuardReq>((event, emit) async {
      emit(AdminGetPendingGuardReqLoading());
      try{
        final List<GuardRequestsModel> response = await _administrationRepository.getPendingGuardRequest();
        emit(AdminGetPendingGuardReqSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetPendingGuardReqFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetPendingGuardReqFailure(message: e.toString()));
        }
      }
    });

    on<AdminVerifyResident>((event, emit) async {
      emit(AdminVerifyResidentLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.verifyResidentRequest(requestId: event.requestId, user: event.user, residentStatus: event.residentStatus, );
        emit(AdminVerifyResidentSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminVerifyResidentFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminVerifyResidentFailure(message: e.toString()));
        }
      }
    });

    on<AdminVerifyGuard>((event, emit) async {
      emit(AdminVerifyGuardLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.verifyGuardRequest(requestId: event.requestId, user: event.user, guardStatus: event.guardStatus);
        emit(AdminVerifyGuardSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminVerifyGuardFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminVerifyGuardFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetSocietyMember>((event, emit) async {
      emit(AdminGetSocietyMemberLoading());
      try{
        final SocietyMemberModel response = await _administrationRepository.getAllResidents(queryParams: event.queryParams);
        emit(AdminGetSocietyMemberSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetSocietyMemberFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetSocietyMemberFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetSocietyGuard>((event, emit) async {
      emit(AdminGetSocietyGuardLoading());
      try{
        final List<SocietyGuard> response = await _administrationRepository.getAllGuards();
        emit(AdminGetSocietyGuardSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetSocietyGuardFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetSocietyGuardFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetSocietyAdmin>((event, emit) async {
      emit(AdminGetSocietyAdminLoading());
      try{
        final List<SocietyMember> response = await _administrationRepository.getAllAdmin();
        emit(AdminGetSocietyAdminSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetSocietyAdminFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetSocietyAdminFailure(message: e.toString()));
        }
      }
    });

    on<AdminCreateAdmin>((event, emit) async {
      emit(AdminCreateAdminLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.createAdmin(email: event.email);
        emit(AdminCreateAdminSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminCreateAdminFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminCreateAdminFailure(message: e.toString()));
        }
      }
    });

    on<AdminRemoveAdmin>((event, emit) async {
      emit(AdminRemoveAdminLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.removeAdmin(email: event.email);
        emit(AdminRemoveAdminSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminRemoveAdminFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminRemoveAdminFailure(message: e.toString()));
        }
      }
    });

    on<AdminRemoveResident>((event, emit) async {
      emit(AdminRemoveResidentLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.removeResident(id: event.id);
        emit(AdminRemoveResidentSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminRemoveResidentFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminRemoveResidentFailure(message: e.toString()));
        }
      }
    });

    on<AdminRemoveGuard>((event, emit) async {
      emit(AdminRemoveGuardLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.removeGuard(id: event.id);
        emit(AdminRemoveGuardSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminRemoveGuardFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminRemoveGuardFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetComplaint>((event, emit) async {
      emit(AdminGetComplaintLoading());
      try{
        final ComplaintModel response = await _administrationRepository.getComplaints(queryParams: event.queryParams);
        emit(AdminGetComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetComplaintFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetPendingComplaint>((event, emit) async {
      emit(AdminGetPendingComplaintLoading());
      try{
        final ComplaintModel response = await _administrationRepository.getPendingComplaints(queryParams: event.queryParams);
        emit(AdminGetPendingComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetPendingComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetPendingComplaintFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetResolvedComplaint>((event, emit) async {
      emit(AdminGetResolvedComplaintLoading());
      try{
        final ComplaintModel response = await _administrationRepository.getResolvedComplaints(queryParams: event.queryParams);
        emit(AdminGetResolvedComplaintSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetResolvedComplaintFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetResolvedComplaintFailure(message: e.toString()));
        }
      }
    });

    on<AdminAddTechnician>((event, emit) async {
      emit(AdminAddTechnicianLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.addTechnicians(userName: event.userName, email: event.email, phoneNo: event.phoneNo, role: event.role);
        emit(AdminAddTechnicianSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminAddTechnicianFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminAddTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetTechnician>((event, emit) async {
      emit(AdminGetTechnicianLoading());
      try{
        final TechnicianModel response = await _administrationRepository.getTechnician(queryParams: event.queryParams);
        emit(AdminGetTechnicianSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetTechnicianFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<AdminRemoveTechnician>((event, emit) async {
      emit(AdminRemoveTechnicianLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.removeTechnician(id: event.id);
        emit(AdminRemoveTechnicianSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminRemoveTechnicianFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminRemoveTechnicianFailure(message: e.toString()));
        }
      }
    });

    on<AssignTechnician>((event, emit) async {
      emit(AssignTechnicianLoading());
      try{
        final Complaint response = await _administrationRepository.assignTechnician(complaintId: event.complaintId, technicianId: event.technicianId);
        emit(AssignTechnicianSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AssignTechnicianFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AssignTechnicianFailure(message: e.toString()));
        }
      }
    });

  }
}