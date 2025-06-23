class Complaint {
  final String id;
  final String title;
  final String category;
  final String date;
  final String residentName;
  final String flatNumber;
  final String assignedTo;
  final String description;
  final String status;
  final String? resolutionNotes;
  final int? rating;
  final String? imageUrl;

  Complaint({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.residentName,
    required this.flatNumber,
    required this.assignedTo,
    required this.description,
    required this.status,
    this.resolutionNotes,
    this.rating,
    this.imageUrl,
  });
}