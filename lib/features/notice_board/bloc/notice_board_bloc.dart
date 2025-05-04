import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/features/notice_board/repository/notice_board_repository.dart';
import 'package:gloria_connect/utils/api_error.dart';

part 'notice_board_event.dart';
part 'notice_board_state.dart';

class NoticeBoardBloc extends Bloc<NoticeBoardEvent, NoticeBoardState>{
  final NoticeBoardRepository _noticeBoardRepository;
  NoticeBoardBloc({required NoticeBoardRepository noticeBoardRepository}) : _noticeBoardRepository=noticeBoardRepository, super (NoticeBoardInitial()){

    on<NoticeBoardCreateNotice>((event, emit) async {
      emit(NoticeBoardCreateNoticeLoading());
      try{
        
        final Notice response = await _noticeBoardRepository.createNotice(title: event.title, description: event.description, category: event.category, file: event.file);
        emit(NoticeBoardCreateNoticeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardCreateNoticeFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardCreateNoticeFailure(message: e.toString()));
        }
      }
    });

    on<NoticeBoardUpdateNotice>((event, emit) async {
      emit(NoticeBoardUpdateNoticeLoading());
      try{
        final NoticeBoardModel response = await _noticeBoardRepository.updateNotice(id: event.id, title: event.title, description: event.description, file: event.file, image: event.image);
        emit(NoticeBoardUpdateNoticeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardUpdateNoticeFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardUpdateNoticeFailure(message: e.toString()));
        }
      }
    });

    on<NoticeBoardGetAllNotices>((event, emit) async {
      emit(NoticeBoardGetAllNoticesLoading());
      try{
        final NoticeBoardModel response = await _noticeBoardRepository.getAllNotices(queryParams: event.queryParams);
        emit(NoticeBoardGetAllNoticesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardGetAllNoticesFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardGetAllNoticesFailure(message: e.toString()));
        }
      }
    });

    on<NoticeBoardGetNotice>((event, emit) async {
      emit(NoticeBoardGetNoticeLoading());
      try{
        final NoticeBoardModel response = await _noticeBoardRepository.getNotice(id: event.id);
        emit(NoticeBoardGetNoticeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardGetNoticeFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardGetNoticeFailure(message: e.toString()));
        }
      }
    });

    on<NoticeBoardDeleteNotice>((event, emit) async {
      emit(NoticeBoardDeleteNoticeLoading());
      try{
        final NoticeBoardModel response = await _noticeBoardRepository.deleteNotice(id: event.id);
        emit(NoticeBoardDeleteNoticeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardDeleteNoticeFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardDeleteNoticeFailure(message: e.toString()));
        }
      }
    });

    on<NoticeBoardUnreadNotice>((event, emit) async {
      emit(NoticeBoardUnreadNoticeLoading());
      try{
        final List<NoticeBoardModel> response = await _noticeBoardRepository.unreadNotice();
        emit(NoticeBoardUnreadNoticeSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(NoticeBoardUnreadNoticeFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(NoticeBoardUnreadNoticeFailure(message: e.toString()));
        }
      }
    });

  }
}
