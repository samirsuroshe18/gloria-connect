import 'dart:typed_data';
import 'package:flutter/material.dart';

class ContactListTile extends StatelessWidget {
  final String displayName;
  final String phoneNumber;
  final Uint8List? photo;
  final void Function(String name, String phoneNumber) onContactSelected;

  const ContactListTile({
    super.key,
    required this.displayName,
    required this.phoneNumber,
    required this.onContactSelected,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () => onContactSelected(displayName, phoneNumber),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: photo != null
              ? ClipOval(
            child: Image.memory(
              photo!,
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            ),
          )
              : const Icon(Icons.person, color: Colors.grey),
        ),
        title: Text(
          displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        subtitle: Text(
          phoneNumber,
          style: const TextStyle(
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}