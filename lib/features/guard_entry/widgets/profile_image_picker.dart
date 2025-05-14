import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? localImage;
  final String? networkImageUrl;
  final double size;
  final VoidCallback onPickImage;

  const ProfileImagePicker({
    super.key,
    this.localImage,
    this.networkImageUrl,
    required this.onPickImage,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (localImage != null) {
      imageProvider = FileImage(localImage!);
    } else if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(networkImageUrl!);
    } else {
      imageProvider = const AssetImage('assets/images/profile.png');
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white70,
              width: 2.5,
            ),
          ),
          child: CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.grey[300],
            backgroundImage: imageProvider,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 25),
              onPressed: onPickImage,
            ),
          ),
        ),
      ],
    );
  }
}