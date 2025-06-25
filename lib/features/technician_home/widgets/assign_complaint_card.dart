import 'package:flutter/material.dart';
import 'package:gloria_connect/features/technician_home/models/resolution_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AssignComplaintCard extends StatelessWidget {
  final ResolutionElement data;
  const AssignComplaintCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(context, '/tech-complaint-details-screen', arguments: data);
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
                      data.category ?? 'NA',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildStatusChip(data.status ?? 'NA'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    data.subCategory ?? 'NA',
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: Colors.white70)),
                  const SizedBox(width: 8),
                  Text(DateFormat('MMM dd, yyyy').format(data.createdAt!), style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person_outline, data.raisedBy?.userName ?? 'NA'),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.assignment_ind_outlined, 'Assigned to: ${data.technicianId?.userName ?? 'NA'}'),
              const SizedBox(height: 12),
              Text(
                data.description ?? "NA",
                style: TextStyle(
                  color: Colors.white70
                ),
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
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70)),
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
        color: color.withValues(alpha: 0.2),
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
