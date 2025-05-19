import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/administration/models/society_guard.dart';
import 'package:gloria_connect/utils/phone_utils.dart';

class GuardCard extends StatelessWidget {
  final SocietyGuard data;
  final Future<void> Function(String) deleteGuard;
  final Future<void> Function(String) guardReport;
  const GuardCard({super.key, required this.data, required this.deleteGuard, required this.guardReport});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      child: ListTile(
        leading: CustomCachedNetworkImage(
          isCircular: true,
          size: 45,
          imageUrl: data.user?.profile,
          errorImage: Icons.person,
          borderWidth: 2,
          onTap: ()=> CustomFullScreenImageViewer.show(context, data.user?.profile),
        ),
        title: Text(
          data.user?.userName ?? "NA",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(data.user?.phoneNo ?? ""),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              deleteGuard(data.user?.id ?? "");
            } else if(value == 'call'){
              PhoneUtils.makePhoneCall(context, data.user?.phoneNo ?? '');
            } else if(value == 'guard_report'){
              guardReport(data.user?.id ?? "");
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete Guard'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'call',
              child: Row(
                children: [
                  Icon(Icons.call, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Call'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'guard_report',
              child: Row(
                children: [
                  Icon(Icons.report, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Guard Report'),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert), // Three-dot icon
        ),
      ),
    );
  }
}
