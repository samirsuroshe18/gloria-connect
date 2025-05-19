import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/my_visitors/models/past_delivery_model.dart';
import 'package:gloria_connect/utils/phone_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class VisitorPastCard extends StatelessWidget {
  final Entry data;

  const VisitorPastCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image Section
                CustomCachedNetworkImage(
                  isCircular: true,
                  size: 64,
                  imageUrl: data.profileImg,
                  errorImage: Icons.person,
                  borderWidth: 3,
                  onTap: ()=> CustomFullScreenImageViewer.show(context, data.profileImg),
                ),
                const SizedBox(width: 16),

                // Visitor Details Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.name ?? 'Unknown Visitor',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildTypeTag(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoTile(
                        icon: Icons.calendar_today_rounded,
                        title: 'Date',
                        value: data.exitTime != null ? DateFormat('dd MMM, yyyy').format(data.exitTime!) :'NA',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildTimingInfo(),
            const SizedBox(height: 16,),
            _buildApprovalInfo(),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTag() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        data.entryType ?? data.profileType ?? 'Visitor',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimingInfo() {
    return Row(
      children: [
        if(data.entryTime != null)
          Expanded(
            child: _buildInfoTile(
              icon: Icons.login,
              title: 'Entry Time',
              value: data.entryTime != null
                  ? DateFormat('hh:mm a').format(data.entryTime!)
                  :'NA',
            ),
          ),
        if(data.exitTime != null)
          Expanded(
            child: _buildInfoTile(
              icon: Icons.logout,
              title: 'Exit Time',
              value: data.exitTime != null
                  ? DateFormat('hh:mm a').format(data.exitTime!)
                  :'NA',
            ),
          ),
      ],
    );
  }

  Widget _buildInfoTile({required IconData icon, required String title, required String value,}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
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

  Widget _buildApprovalInfo() {

    final approvedBy = data.approvedBy?.user?.userName ??
        (data.societyDetails?.societyApartments?.isEmpty ?? true
            ? 'No one'
            : data.societyDetails?.societyApartments?[0].entryStatus?.approvedBy
                ?.userName);

    final allowedBy = data.allowedBy?.user?.userName ??
        data.guardStatus?.guard?.userName ??
        'Unknown Guard';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          Icons.check_circle_outline,
          'Approved by $approvedBy',
          Colors.green,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.security,
          'Allowed by Guard ($allowedBy)',
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              // color: Colors.grey.shade700,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: ()=> PhoneUtils.makePhoneCall(context, data.mobNumber ?? ''),
            icon: const Icon(Icons.phone),
            label: const Text('Call Visitor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
