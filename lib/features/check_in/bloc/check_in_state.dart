part of 'check_in_bloc.dart';

@immutable
sealed class CheckInState{}

final class CheckInInitial extends CheckInState{}

class FlatState extends CheckInState {
  final List<String> selectedFlats;

  FlatState({required this.selectedFlats});
  // A copyWith method to return a new state with updated flats.
  FlatState copyWith({List<String>? selectedFlats}) {
    return FlatState(
      selectedFlats: selectedFlats ?? this.selectedFlats,
    );
  }
}

///Get mobile number
final class CheckInGetNumberLoading extends CheckInState{}

final class CheckInGetNumberSuccess extends CheckInState{
  final Map<String, dynamic> response;
  CheckInGetNumberSuccess({required this.response});
}

final class CheckInGetNumberFailure extends CheckInState{
  final String message;
  final int? status;

  CheckInGetNumberFailure( {required this.message, this.status});
}

///Get Blocks
final class CheckInGetBlockLoading extends CheckInState{}

final class CheckInGetBlockSuccess extends CheckInState{
  final List<String> response;
  CheckInGetBlockSuccess({required this.response});
}

final class CheckInGetBlockFailure extends CheckInState{
  final String message;
  final int? status;

  CheckInGetBlockFailure( {required this.message, this.status});
}

///Get apartments
final class CheckInGetApartmentLoading extends CheckInState{}

final class CheckInGetApartmentSuccess extends CheckInState{
  final List<String> response;
  CheckInGetApartmentSuccess({required this.response});
}

final class CheckInGetApartmentFailure extends CheckInState{
  final String message;
  final int? status;

  CheckInGetApartmentFailure( {required this.message, this.status});
}