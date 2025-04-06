import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/entry.dart';

class FlatRow extends StatelessWidget {
  final SocietyApartment? data;

  const FlatRow({super.key, this.data});

  void _makePhoneCall(String? phoneNo) async {
    // Check if the phone number is valid
    if (phoneNo == null || phoneNo.isEmpty) {
      // Optionally show an error message to the user
      print('Invalid phone number');
      return;
    }

    // Create the URI using Uri.parse
    final Uri url = Uri.parse('tel:$phoneNo');

    // Check if the device supports launching the URL
    if (await canLaunchUrl(url)) {
      try {
        await launchUrl(url);
      } catch (e) {
        // Handle any errors during launch
        print('Error launching URL: $e');
        // Optionally show an error message
      }
    } else {
      // Inform the user the action isn't supported
      print('Could not launch $url');
      // Optionally show a dialog or snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(13))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.home, color: Colors.grey, size: 28), // Home icon
                const SizedBox(width: 12),
                // Reduced font size for flat number
                Text(data!.apartment ?? 'NA',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
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
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(contact?.profile ??
                        'https://www.gravatar.com/avatar/?d=identicon'), // Default profile
                  ),
                  title: Text(
                      contact?.userName ?? 'Default User'), // Default user name
                  subtitle: Text(contact?.phoneNo ?? 'n'),
                  onTap: () {
                    // Handle the click event for the selected contact
                    _makePhoneCall(contact?.phoneNo);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
