part of 'notice_board_bloc.dart';

@immutable
sealed class NoticeBoardEvent{}

final class NoticeBoardCreateNotice extends NoticeBoardEvent{
  final String title;
  final String description;
  final String category;
  final File? file;

  NoticeBoardCreateNotice({required this.title, required this.description, required this.category, this.file});
}

final class NoticeBoardUpdateNotice extends NoticeBoardEvent{
  final String id;
  final String title;
  final String description;
  final File? file;
  final String? image;

  NoticeBoardUpdateNotice({required this.id, required this.title, required this.description, this.file, this.image});
}

final class NoticeBoardGetAllNotices extends NoticeBoardEvent{
  final Map<String, dynamic> queryParams;

  NoticeBoardGetAllNotices({required this.queryParams});
}

final class NoticeBoardDeleteNotice extends NoticeBoardEvent{
  final String id;

  NoticeBoardDeleteNotice({required this.id});
}

final class NoticeBoardGetNotice extends NoticeBoardEvent{
  final String id;

  NoticeBoardGetNotice({required this.id});
}

final class NoticeBoardUnreadNotice extends NoticeBoardEvent{}

