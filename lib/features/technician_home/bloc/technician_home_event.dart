part of 'technician_home_bloc.dart';

@immutable
sealed class TechnicianHomeEvent{}

final class GetAssignComplaint extends TechnicianHomeEvent{}

final class AddComplaintResolution extends TechnicianHomeEvent{
  final String complaintId;
  final String resolutionNote;
  final File file;
  AddComplaintResolution({required this.complaintId, required this.resolutionNote, required this.file});
}

final class ApproveResolution extends TechnicianHomeEvent{
  final String resolutionId;
  ApproveResolution({required this.resolutionId});
}

final class RejectResolution extends TechnicianHomeEvent{
  final String resolutionId;
  final String rejectedNote;
  RejectResolution({required this.resolutionId, required this.rejectedNote});
}