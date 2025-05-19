import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/utils/phone_utils.dart';

import '../models/entry.dart';

class FlatRow extends StatelessWidget {
  final SocietyApartment? data;

  const FlatRow({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(13))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.home, color: Colors.grey, size: 28), // Home icon
                const SizedBox(width: 12),
                // Reduced font size for flat number
                Text(
                  data!.apartment ?? 'NA',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  data?.entryStatus?.status == 'pending'
                      ? Icons.hourglass_empty
                      : data?.entryStatus?.status == 'approve'
                          ? Icons.check_circle
                          : Icons.cancel, // Conditionally show icons
                  color: data?.entryStatus?.status == 'pending'
                      ? Colors.yellow
                      : data?.entryStatus?.status == 'approve'
                          ? Colors.green
                          : Colors.red, // Green for approved, red for declined
                  size: 28,
                ),
                const SizedBox(width: 12),
                // Reduced font size for flat number
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.grey),
                  onPressed: () => _showContactDialog(context),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Contact'),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(
              maxHeight: 400, // Adjust the maximum height as needed
            ),
            child: ListView.builder(
              itemCount: data?.members?.length ?? 0,
              itemBuilder: (context, index) {
                final contact = data?.members?[index];
                return ListTile(
                  leading: CustomCachedNetworkImage(
                    imageUrl: contact?.profile,
                    size: 45,
                    isCircular: true,
                    borderWidth: 2,
                    errorImage: Icons.person,
                    onTap: ()=> CustomFullScreenImageViewer.show(context, contact?.profile
                    ),
                  ),
                  title: Text(
                    contact?.userName ?? 'Default User',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ), // Default user name
                  subtitle: Text(contact?.phoneNo ?? 'n'),
                  onTap: ()=> PhoneUtils.makePhoneCall(context, contact?.phoneNo ?? ''),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
