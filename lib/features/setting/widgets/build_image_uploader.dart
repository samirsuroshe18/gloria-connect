import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gloria_connect/utils/document_picker_utils.dart';
import 'package:image_picker/image_picker.dart';

class BuildImageUploader extends StatelessWidget {
  final File? file;
  final VoidCallback onCancel;
  final Future<void> Function(ImageSource) pickImage;
  const BuildImageUploader({super.key, this.file, required this.onCancel, required this.pickImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (file != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      file!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 20),
                        onPressed: onCancel,
                      ),
                    ),
                  ),
                ],
              )
            else
              InkWell(
                onTap: ()=> DocumentPickerUtils.showDocumentPickerSheet(
                  context: context,
                  onPickImage: pickImage,
                  onPickPDF: null,
                  isOnlyImage: true,
                ),
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border:
                    Border.all(color: const Color(0xFF3498DB), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 50, color: Color(0xFF3498DB)),
                      SizedBox(height: 8),
                      Text(
                        'Upload Supporting Image',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '(Optional)',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
