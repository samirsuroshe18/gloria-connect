part of 'check_in_bloc.dart';

@immutable
sealed class CheckInEvent{}

class AddFlat extends CheckInEvent {
  final String? flatName;
  AddFlat({this.flatName, });
}

class RemoveFlat extends CheckInEvent {
  final String flatName; // flatName should be String instead of int

  RemoveFlat({required this.flatName});
}

class ClearFlat extends CheckInEvent {}

class CheckInGetNumber extends CheckInEvent{
  final String mobNumber;
  final String entryType;

  CheckInGetNumber({required this.mobNumber, required this.entryType});
}

class CheckInGetBlock extends CheckInEvent {}

class CheckInGetApartment extends CheckInEvent{
  final String blockName;

  CheckInGetApartment({required this.blockName});
}