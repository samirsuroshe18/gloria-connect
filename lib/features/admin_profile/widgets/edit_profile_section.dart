import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gloria_connect/utils/document_picker_utils.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileSection extends StatelessWidget {
  final File? selectedImage;
  final String profileImage;
  final Future<void> Function(ImageSource) pickImage;
  const EditProfileSection({super.key, this.selectedImage, required this.profileImage, required this.pickImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage: selectedImage != null
                  ? FileImage(selectedImage!)
                  : profileImage.isNotEmpty
                  ? NetworkImage(profileImage) as ImageProvider
                  : const AssetImage('assets/images/profile.png'),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -4,
            child: GestureDetector(
              onTap: ()=> DocumentPickerUtils.showDocumentPickerSheet(
                context: context,
                onPickImage: pickImage,
                onPickPDF: null,
                isOnlyImage: true,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
