part of 'my_visitors_bloc.dart';

@immutable
sealed class MyVisitorsEvent{}

final class GetExpectedEntries extends MyVisitorsEvent{}

final class GetCurrentEntries extends MyVisitorsEvent{}

final class GetPastEntries extends MyVisitorsEvent{
  final Map<String, dynamic> queryParams;

  GetPastEntries({
    required this.queryParams,
  });
}

final class GetDeniedEntries extends MyVisitorsEvent{
  final Map<String, dynamic> queryParams;

  GetDeniedEntries({required this.queryParams});
}

final class GetServiceRequest extends MyVisitorsEvent{}