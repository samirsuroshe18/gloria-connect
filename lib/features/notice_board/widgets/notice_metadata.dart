// lib/features/notice_board/presentation/widgets/notice_metadata.dart
import 'package:flutter/material.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';

class NoticeMetadata extends StatelessWidget {
  final String date;
  final DBy? publisher;

  const NoticeMetadata({
    super.key,
    required this.date,
    this.publisher,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date row
        Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                date,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        // Publisher info if available
        if (publisher != null && (publisher!.userName?.isNotEmpty ?? false))
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.avatarBackground,
                  child: Text(
                    (publisher?.userName?.isNotEmpty ?? false)
                        ? publisher!.userName![0].toUpperCase()
                        : 'A',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Posted by ${publisher?.userName ?? "Unknown"}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}