import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? selectedImage;
  final String profileImageUrl;
  final VoidCallback onPickImage;

  const ProfileImagePicker({
    super.key,
    required this.selectedImage,
    required this.profileImageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!);
    } else if (profileImageUrl.isNotEmpty) {
      imageProvider = NetworkImage(profileImageUrl);
    } else {
      imageProvider = const AssetImage('assets/images/profile.png');
    }

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
              backgroundImage: imageProvider,
            ),
          ),
          Positioned(
            bottom: 0,
            right: -4,
            child: GestureDetector(
              onTap: onPickImage,
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