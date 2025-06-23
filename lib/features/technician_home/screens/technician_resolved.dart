import 'package:flutter/material.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import '../models/complaint_model.dart';
import 'complaint_details_screen.dart';

// A stateful widget for displaying resolved technician complaints.
class TechnicianResolved extends StatefulWidget {
  const TechnicianResolved({super.key});

  @override
  State<TechnicianResolved> createState() => _TechnicianResolvedState();
}

class _TechnicianResolvedState extends State<TechnicianResolved> {
  final List<Complaint> _complaints = [
    Complaint(
      id: '2',
      title: 'Internet Connection Issues',
      category: 'Technical',
      date: '2024-06-15',
      residentName: 'Bob Wilson',
      flatNumber: 'C-302',
      assignedTo: 'Sarah Davis',
      description: 'Wi-Fi connectivity is very poor in my flat. Need to check the router.',
      status: 'Resolved',
      resolutionNotes: 'Replaced router and checked all connections. Issue resolved.',
      rating: 4,
      imageUrl: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?q=80&w=1964&auto=format&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _complaints.length,
        itemBuilder: (context, index) {
          return _buildComplaintCard(_complaints[index]);
        },
      ),
    );
  }

  Widget _buildComplaintCard(Complaint complaint) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComplaintDetailsScreen(complaint: complaint),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildStatusChip(complaint.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    complaint.category,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.accentColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  Text(complaint.date, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person_outline, '${complaint.residentName} - ${complaint.flatNumber}'),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.assignment_ind_outlined, 'Assigned to: ${complaint.assignedTo}'),
              const SizedBox(height: 12),
              Text(
                complaint.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 14),
          const SizedBox(width: 6),
          Text(
            status,
            style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}
