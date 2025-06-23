import 'package:flutter/material.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import '../models/complaint_model.dart';
import 'complaint_details_screen.dart';

class TechnicianPending extends StatefulWidget {
  const TechnicianPending({super.key});

  @override
  State<TechnicianPending> createState() => _TechnicianPendingState();
}

class _TechnicianPendingState extends State<TechnicianPending> {
  final List<Complaint> _complaints = [
    Complaint(
      id: '1',
      title: 'Elevator Not Working',
      category: 'Maintenance',
      date: '2024-06-17',
      residentName: 'Jane Smith',
      flatNumber: 'B-105',
      assignedTo: 'Mike Johnson',
      description:
      'The main elevator has been out of order for 2 days. It gets stuck between floors.',
      status: 'Assigned',
      imageUrl: 'https://images.unsplash.com/photo-1590223849159-1d4a8e0e6409?q=80&w=1974&auto=format&fit=crop',
    ),
    Complaint(
      id: '3',
      title: 'Water Leakage in Bathroom',
      category: 'Plumbing',
      date: '2024-06-18',
      residentName: 'John Doe',
      flatNumber: 'A-201',
      assignedTo: 'Unassigned',
      description:
      'There is a continuous water leak from the ceiling in my bathroom.',
      status: 'Pending',
      imageUrl: 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?q=80&w=2070&auto=format&fit=crop',
    ),
    Complaint(
      id: '4',
      title: 'AC unit not cooling',
      category: 'Electrical',
      date: '2024-06-19',
      residentName: 'Emily Brown',
      flatNumber: 'C-404',
      assignedTo: 'Mike Johnson',
      description:
      'The AC unit was fixed yesterday but it has stopped cooling again.',
      status: 'Rework',
      imageUrl: 'https://images.unsplash.com/photo-1542382257-80ded54d739d?q=80&w=2070&auto=format&fit=crop',
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
              builder: (context) =>
                  ComplaintDetailsScreen(complaint: complaint),
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
    Color color;
    IconData icon;

    switch (status) {
      case 'Pending':
        color = Colors.orange;
        icon = Icons.pending_actions;
        break;
      case 'Rework':
        color = Colors.red;
        icon = Icons.build;
        break;
      case 'Assigned':
      default:
        color = Colors.blue;
        icon = Icons.person_pin_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}
