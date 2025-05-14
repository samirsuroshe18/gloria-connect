// lib/features/notice_board/presentation/widgets/notice_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/utils/notice_sharing_service.dart';

class NoticeActionButtons extends StatelessWidget {
  final Notice notice;

  const NoticeActionButtons({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => NoticeSharingService.shareNotice(notice),
          icon: const Icon(
            Icons.share,
            size: 18,
            color: AppColors.buttonTextColor,
          ),
          label: const Text(
            'Share',
            style: TextStyle(color: AppColors.buttonTextColor),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryButtonColor,
            foregroundColor: AppColors.buttonTextColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
            color: AppColors.buttonTextColor,
          ),
          label: const Text(
            'Back to Notices',
            style: TextStyle(color: AppColors.buttonTextColor),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.secondaryButtonColor,
            side: const BorderSide(color: AppColors.accentColor),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}