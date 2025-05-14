// lib/features/notice_board/presentation/widgets/notice_attachment_card.dart
import 'package:flutter/material.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import 'package:gloria_connect/utils/file_download_service.dart';

class NoticeAttachmentSection extends StatelessWidget {
  final String imageUrl;

  const NoticeAttachmentSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Attachment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        NoticeAttachmentCard(imageUrl: imageUrl),
      ],
    );
  }
}

class NoticeAttachmentCard extends StatelessWidget {
  final String imageUrl;

  const NoticeAttachmentCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.image,
          color: AppColors.accentColor,
        ),
        title: const Text(
          'Image Attachment',
          style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.download,
            color: AppColors.accentColor,
          ),
          onPressed: () => FileDownloadService.downloadFile(imageUrl, context),
        ),
        onTap: () {
          // Handle open image - could navigate to a full-screen image viewer
        },
      ),
    );
  }
}