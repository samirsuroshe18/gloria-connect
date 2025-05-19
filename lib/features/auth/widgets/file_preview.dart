import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class FilePreview extends StatelessWidget {
  final File file;
  final String? fileType;
  const FilePreview({super.key, required this.file, this.fileType,});

  @override
  Widget build(BuildContext context) {
    final String fileExtension = file.path.split('.').last.toLowerCase();
    if (fileExtension == 'pdf') {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/pdf-preview-screen', arguments: file);
        },
        child: Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey.shade100.withValues(alpha: 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 64,
                color: Colors.white70,
              ),
              const SizedBox(height: 8),
              Text(
                path.basename(file.path),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap to preview PDF',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // For image files
      return Image.file(
        file,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Error loading image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
