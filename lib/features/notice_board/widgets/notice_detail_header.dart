// lib/features/notice_board/presentation/widgets/notice_detail_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/utils/notice_sharing_service.dart';

class NoticeDetailHeader extends StatelessWidget {
  final Notice notice;

  const NoticeDetailHeader({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final bool hasValidImage = notice.image != null && notice.image!.isNotEmpty;

    return SliverAppBar(
      expandedHeight: hasValidImage ? 240.0 : 0.0,
      pinned: true,
      backgroundColor: AppColors.appBarBackground,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.iconBackgroundLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.iconColor),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.iconBackgroundLight,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.share, color: AppColors.iconColor),
          ),
          onPressed: () => NoticeSharingService.shareNotice(notice),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: hasValidImage
          ? FlexibleSpaceBar(
        background: Hero(
          tag: 'notice-image-${notice.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: notice.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const BlurHash(
                  hash: "L6PZfSi_.AyE_3t7t7R**0o#DgR4",
                  imageFit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }
}