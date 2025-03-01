import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {
  final String category;
  final String subCategory;
  final bool isResolved;
  final String description;
  final DateTime date;
  final String id;
  final int rating;
  final int responses;
  final VoidCallback onTap;

  const ComplaintCard({
    super.key,
    required this.category,
    required this.subCategory,
    required this.isResolved,
    required this.description,
    required this.date,
    required this.id,
    required this.rating,
    required this.responses,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category and Status
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.category, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                subCategory,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isResolved ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isResolved ? Icons.check_circle : Icons.pending,
                          size: 16,
                          color: isResolved ? Colors.green[700] : Colors.red[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isResolved ? 'Resolved' : 'Pending',
                          style: TextStyle(
                            color: isResolved ? Colors.green[700] : Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                description,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              // Date and ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: $id',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Rating and Responses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Star Rating
                  // Row(
                  //   children: List.generate(5, (index) {
                  //     return Icon(
                  //       index < rating ? Icons.star : Icons.star_border,
                  //       color: Colors.amber,
                  //       size: 20,
                  //     );
                  //   }),
                  // ),
                  // Responses
                  Row(
                    children: [
                      const Icon(Icons.message_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$responses Responses',
                        style: const TextStyle(fontSize: 12),
                      ),
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