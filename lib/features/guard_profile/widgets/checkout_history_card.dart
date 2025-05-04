import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/checkout_history.dart';

class CheckoutHistoryCard extends StatelessWidget {
  final CheckoutEntry data;

  const CheckoutHistoryCard({super.key, required this.data});

  Future<void> _makePhoneCall() async {
    final Uri url = Uri(scheme: 'tel', path: data.mobNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not connect $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with profile and basic info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                GestureDetector(
                  onTap: () => _showImageDialog(data.profileImg, context),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      backgroundImage: _getProfileImage(),
                      onBackgroundImageError: (_, __) => const Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Name and Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.name ?? 'Visitor',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white70
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusChip(data.entryType ?? data.profileType ?? 'Visitor'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.calendar_today,
                        DateFormat('dd MMM, yyyy').format(data.entryTime ?? DateTime.now()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Time information section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.05),
              border: Border(
                top: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
                bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeInfo(
                  'Entry Time',
                  DateFormat('hh:mm a').format(data.entryTime ?? DateTime.now()),
                  Icons.login,
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: theme.dividerColor.withOpacity(0.2),
                ),
                _buildTimeInfo(
                  'Exit Time',
                  DateFormat('hh:mm a').format(data.exitTime ?? DateTime.now()),
                  Icons.logout,
                ),
              ],
            ),
          ),

          // Approval information
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildApprovalInfo(
                  'Approved by',
                  data.approvedBy?.user?.userName ??
                      data.societyDetails?.societyApartments?[0].entryStatus?.approvedBy?.userName ??
                      'No one',
                  Icons.verified_user,
                ),
                const SizedBox(height: 8),
                _buildApprovalInfo(
                  'Allowed by Guard',
                  data.allowedBy?.user?.userName ?? data.guardStatus?.guard?.userName ?? 'Unknown',
                  Icons.security,
                ),
              ],
            ),
          ),

          // Call button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _makePhoneCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.phone),
                label: const Text('Call'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (data.allowedBy != null && data.approvedBy?.user != null) {
      return AssetImage(data.profileImg!);
    } else if (data.profileImg != null) {
      return NetworkImage(data.profileImg!);
    }
    return const AssetImage('assets/images/profile.png');
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(String label, String time, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.white70),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalInfo(String label, String name, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                TextSpan(
                  text: name,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showImageDialog(String? imageUrl, BuildContext context) {
    if (imageUrl == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: imageUrl.contains("assets")
                    ? Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                )
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 100, color: Colors.white70,);
                  },
                ),
              ),
            ),
            Positioned(
              top: -16,
              right: -16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}