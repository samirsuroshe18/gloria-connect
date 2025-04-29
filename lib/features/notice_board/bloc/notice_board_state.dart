part of 'notice_board_bloc.dart';

@immutable
sealed class NoticeBoardState{}

final class NoticeBoardInitial extends NoticeBoardState{}

/// Create notice
final class NoticeBoardCreateNoticeLoading extends NoticeBoardState{}

final class NoticeBoardCreateNoticeSuccess extends NoticeBoardState{
  final NoticeBoardModel response;
  NoticeBoardCreateNoticeSuccess({required this.response});
}

final class NoticeBoardCreateNoticeFailure extends NoticeBoardState{
  final String message;
  final int? status;

  NoticeBoardCreateNoticeFailure( {required this.message, this.status});
}

/// Update notice
final class NoticeBoardUpdateNoticeLoading extends NoticeBoardState{}

final class NoticeBoardUpdateNoticeSuccess extends NoticeBoardState{
  final NoticeBoardModel response;
  NoticeBoardUpdateNoticeSuccess({required this.response});
}

final class NoticeBoardUpdateNoticeFailure extends NoticeBoardState{
  final String message;
  final int? status;

  NoticeBoardUpdateNoticeFailure({required this.message, this.status});
}

/// get notice
final class NoticeBoardGetNoticeLoading extends NoticeBoardState{}

final class NoticeBoardGetNoticeSuccess extends NoticeBoardState{
  final NoticeBoardModel response;
  NoticeBoardGetNoticeSuccess({required this.response});
}

final class NoticeBoardGetNoticeFailure extends NoticeBoardState{
  final String message;
  final int? status;

  NoticeBoardGetNoticeFailure({required this.message, this.status});
}


/// get all notice
final class NoticeBoardGetAllNoticesLoading extends NoticeBoardState{}

final class NoticeBoardGetAllNoticesSuccess extends NoticeBoardState{
  final NoticeBoardModel response;
  NoticeBoardGetAllNoticesSuccess({required this.response});
}

final class NoticeBoardGetAllNoticesFailure extends NoticeBoardState{
  final String message;
  final int? status;

  NoticeBoardGetAllNoticesFailure({required this.message, this.status});
}

/// delete notice
final class NoticeBoardDeleteNoticeLoading extends NoticeBoardState{}

final class NoticeBoardDeleteNoticeSuccess extends NoticeBoardState{
  final NoticeBoardModel response;
  NoticeBoardDeleteNoticeSuccess({required this.response});
}

final class NoticeBoardDeleteNoticeFailure extends NoticeBoardState{
  final String message;
  final int? status;

  NoticeBoardDeleteNoticeFailure({required this.message, this.status});
}


/// unread notice
final class NoticeBoardUnreadNoticeLoading extends NoticeBoardState{}

final class NoticeBoardUnreadNoticeSuccess extends NoticeBoardState{
  final List<NoticeBoardModel> response;
  NoticeBoardUnreadNoticeSuccess({required this.response});
}

final class NoticeBoardUnreadNoticeFailure extends NoticeBoardState{
  final String message;
  final int? status;

  NoticeBoardUnreadNoticeFailure({required this.message, this.status});
}

