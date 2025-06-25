import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';

class AssignCard extends StatelessWidget {
  final Technician data;
  const AssignCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CustomCachedNetworkImage(
          size: 42,
          borderWidth: 1,
          errorImage: Icons.person,
          isCircular: true,
          imageUrl: data.profile,
          onTap: ()=> CustomFullScreenImageViewer.show(
              context,
              data.profile,
              errorImage: Icons.person
          ),
        ),
        title: Text(
          data.userName ?? 'NA',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          data.role ?? '',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.pop(context, data),
      ),
    );
  }
}
