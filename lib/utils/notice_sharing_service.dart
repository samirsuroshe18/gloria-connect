// lib/features/notice_board/services/notice_sharing_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NoticeSharingService {
  /// Shares a notice with optional image attachment
  static Future<void> shareNotice(Notice notice) async {
    String shareText = 'Check out this important notice: ${notice.title}\n\n${notice.description}';

    if (notice.image != null && notice.image!.isNotEmpty) {
      try {
        // Download the image
        final response = await http.get(Uri.parse(notice.image!));
        final bytes = response.bodyBytes;

        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/notice_image.jpg');

        // Save the image
        await file.writeAsBytes(bytes);

        await SharePlus.instance.share(
          ShareParams(
              files: [XFile(file.path)],
              text: notice.title
          ),
        );
      } catch (e) {
        debugPrint('Error sharing image: $e');
        await SharePlus.instance.share(
          ShareParams(
              text: shareText,
              subject: notice.title
          ),
        );
      }
    } else {
      await SharePlus.instance.share(
        ShareParams(
            text: shareText,
            subject: notice.title
        ),
      );
    }
  }
}