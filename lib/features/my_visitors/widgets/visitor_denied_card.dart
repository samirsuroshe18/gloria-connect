import 'package:flutter/material.dart';
import 'package:gloria_connect/features/guard_waiting/models/entry.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitorDeniedCard extends StatelessWidget {
  final Entry data;

  const VisitorDeniedCard({super.key, required this.data});

  Future<void> _makePhoneCall(BuildContext context) async {
  // Clean the phone number by removing any non-digit characters
  final cleanNumber = data.mobNumber?.replaceAll(RegExp(r'[^\d+]'), '') ?? '';

  if (cleanNumber.isEmpty) {
    // Show error if no phone number available
    if (context.mounted) {
      _showErrorDialog('No phone number available', context);
    }
    return;
  }

  // Create the phone URI
  final Uri phoneUri = Uri(
    scheme: 'tel',
    path: cleanNumber,
  );

  try {
    final canLaunch = await canLaunchUrl(phoneUri);
    
    // Check if the widget is still in the tree after the async operation
    if (!context.mounted) return;
    
    if (canLaunch) {
      await launchUrl(phoneUri);
    } else {
      _showErrorDialog('Could not make phone call', context);
    }
  } catch (e) {
    // Check if the widget is still in the tree
    if (context.mounted) {
      _showErrorDialog('Error launching phone call', context);
    }
  }
}

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status banner
              Container(
                color: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.block_outlined, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Access Denied',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile image with tap functionality
                        GestureDetector(
                          onTap: () => _showImageDialog(data.profileImg, context),
                          child: Hero(
                            tag: 'profile-${data.name}',
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: data.profileImg != null
                                    ? Image.network(
                                  data.profileImg!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 40, color: Colors.grey),
                                )
                                    : const Icon(Icons.person, size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Visitor details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.name ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      data.entryType ?? data.profileType ?? 'Visitor',
                                      style: TextStyle(
                                        color: Colors.orange.shade800,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Denied by: ${data.societyDetails?.societyApartments?[0].entryStatus?.rejectedBy?.userName ?? 'Unknown'}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Time and Date section
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            icon: Icons.access_time_rounded,
                            title: 'Time',
                            value: DateFormat('hh:mm a').format(data.exitTime ?? DateTime.now()),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoTile(
                            icon: Icons.calendar_today_rounded,
                            title: 'Date',
                            value: DateFormat('dd MMM, yyyy').format(data.exitTime ?? DateTime.now()),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Vehicle details
                    if (data.vehicleDetails?.vehicleNumber != null)
                      _buildInfoTile(
                        icon: Icons.directions_car_rounded,
                        title: 'Vehicle Number',
                        value: data.vehicleDetails!.vehicleNumber!,
                      ),

                    const SizedBox(height: 16),

                    // Call button - Only show if phone number exists
                    if (data.mobNumber != null && data.mobNumber!.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _makePhoneCall(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.phone_outlined, color: Colors.white70),
                          label: const Text(
                            'Contact Visitor',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.white60),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImageDialog(String? imageUrl, BuildContext context) {
    if (imageUrl == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Hero(
                tag: 'profile-${data.name}',
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error_outline, size: 64),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -20,
                right: -20,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}