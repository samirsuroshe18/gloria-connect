import 'package:flutter/material.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:gloria_connect/features/setting/widgets/build_status_chip.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final Future<void> Function(Complaint, BuildContext) onTap;

  const ComplaintCard({
    super.key,
    required this.onTap,
    required this.complaint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => onTap(complaint, context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '#${complaint.complaintId}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  BuildStatusChip(status: complaint.status ?? 'pending'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                complaint.category ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70
                ),
              ),
              const SizedBox(height: 8),
              Text(
                complaint.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.white60),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(complaint.date!),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.comment_outlined, size: 16, color: Colors.white60),
                      const SizedBox(width: 4),
                      Text(
                        '${complaint.responses?.length ?? 0}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                      if (complaint.review != null && complaint.review! > 0) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          complaint.review.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}