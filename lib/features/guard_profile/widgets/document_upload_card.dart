import 'dart:io';
import 'package:flutter/material.dart';

class DocumentUploadCard extends StatelessWidget {
  final File? file;
  final VoidCallback onRemove;
  final VoidCallback onUploadTap;
  final String label;

  const DocumentUploadCard({
    Key? key,
    required this.file,
    required this.onRemove,
    required this.onUploadTap,
    this.label = 'Upload Ownership Document',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: file != null
            ? Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(
              file!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        )
            : Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: onUploadTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_photo_alternate, size: 50, color: Colors.white70),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}