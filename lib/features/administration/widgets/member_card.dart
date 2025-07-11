import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/administration/models/society_member.dart';
import 'package:gloria_connect/utils/phone_utils.dart';

class MemberCard extends StatelessWidget {
  final SocietyMember data;
  final Future<void> Function(String) deleteResident;
  final Future<void> Function(String) makeAdmin;
  const MemberCard({super.key, required this.data, required this.deleteResident, required this.makeAdmin,});

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
              deleteResident(data.user?.id ?? "");
            } else if (value == 'makeAdmin') {
              makeAdmin(data.user?.email ?? "");
            }else if(value == 'call'){
              PhoneUtils.makePhoneCall(context, data.user?.phoneNo ?? "");
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete Resident'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'makeAdmin',
              child: Row(
                children: [
                  Icon(Icons.person_add, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Make Admin'),
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
          ],
          icon: const Icon(Icons.more_vert), // Three-dot icon
        ),
      ),
    );
  }
}
