// lib/features/notice_board/services/file_download_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FileDownloadService {
  /// Downloads a file from a URL and opens it
  static Future<void> downloadFile(String url, BuildContext context) async {
    try {
      CustomSnackBar.show(context: context, message: "Downloading file...", type: SnackBarType.info);

      var response = await http.get(Uri.parse(url));
      if (!context.mounted) return;

      if (response.statusCode == 200) {
        Directory? directory = await getExternalStorageDirectory();
        if (!context.mounted) return;

        if (directory == null) {
          CustomSnackBar.show(context: context, message: "Unable to find directory.", type: SnackBarType.error);
          return;
        }

        String fileName = url.split('/').last;
        String filePath = "${directory.path}/$fileName";

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        if (!context.mounted) return;
        CustomSnackBar.show(context: context, message: "Downloaded to $filePath", type: SnackBarType.success);

        OpenFile.open(filePath);
      } else {
        if (!context.mounted) return;
        CustomSnackBar.show(context: context, message: "Download failed: Server error.", type: SnackBarType.error);
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackBar.show(context: context, message: "Download failed: $e", type: SnackBarType.error);
    }
  }
}