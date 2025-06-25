import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gloria_connect/features/auth/widgets/file_preview.dart';

class ResolutionUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final File? file;
  final VoidCallback onUpload;
  final VoidCallback onRemove;
  final String? tenantAgreementType;
  const ResolutionUploadCard({super.key, required this.title, required this.subtitle, this.file, required this.onUpload, required this.onRemove, this.tenantAgreementType});

  @override
  Widget build(BuildContext context) {
    String? fileType = tenantAgreementType;

    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 16),
            if (file != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FilePreview(file: file!, fileType: fileType),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: onRemove,
                  ),
                ],
              )
            else
              InkWell(
                onTap: onUpload,
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: Colors.grey.shade300,
                      radius: const Radius.circular(12),
                      dashPattern: [8, 4],
                      strokeWidth: 1,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file_rounded,
                            size: 48,
                            color: Colors.white70,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Upload Document',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tap to upload image or PDF',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
