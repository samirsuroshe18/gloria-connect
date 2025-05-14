import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/resident_profile/models/member.dart';
import 'package:gloria_connect/utils/phone_utils.dart';

class BuildResidentMember extends StatelessWidget {
  final Member member;
  const BuildResidentMember({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      child: ListTile(
        leading: CustomCachedNetworkImage(
          imageUrl: member.user?.profile,
          isCircular: true,
          size: 40,
          borderWidth: 1,
          errorImage: Icons.person,
          onTap: () => CustomFullScreenImageViewer.show(context, member.user?.profile, errorImage: Icons.person),
        ),
        title: Text(
          member.user?.userName ?? "NA",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(member.user?.phoneNo ?? ""),
        trailing: IconButton(
          icon: const Icon(Icons.call),
          onPressed: ()=> PhoneUtils.makePhoneCall(context, member.user?.phoneNo ?? ""),
        ),
      ),
    );
  }
}
