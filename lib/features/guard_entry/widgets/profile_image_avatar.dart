import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImageAvatar extends StatelessWidget {
  final dynamic imageSource; // Either a File or a String (URL)
  final double size;
  final double borderWidth;
  final Color borderColor;

  const ProfileImageAvatar({
    super.key,
    required this.imageSource,
    this.size = 90.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = imageSource is File
        ? FileImage(imageSource)
        : imageSource is String
        ? NetworkImage(imageSource)
        : const AssetImage('assets/images/default_avatar.png') as ImageProvider;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: CircleAvatar(
        backgroundImage: imageProvider,
        radius: size / 2,
      ),
    );
  }
}