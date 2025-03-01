import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../guard_waiting/models/entry.dart';

class VisitorPastCard extends StatelessWidget {
  final Entry data;

  const VisitorPastCard({super.key, required this.data});

  void _makePhoneCall() async {
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetailSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Section
                  _buildProfileImage(context),
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
                                style: theme.textTheme.titleLarge?.copyWith(
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
                        _buildTimingInfo(),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildApprovalInfo(),
              const SizedBox(height: 12),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return GestureDetector(
      onTap: () => data.profileImg != null
          ? _showImageDialog(data.profileImg!, context)
          : null,
      child: Hero(
        tag: 'profile-${data.id}',
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: _getProfileImage(),
          ),
        ),
      ),
    );
  }

  Widget _getProfileImage() {
    if (data.entryType == 'service') {
      return Image.network(
        data.profileImg!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.person),
      );
    } else if (data.allowedBy != null && data.approvedBy?.user != null) {
      return Image.asset(
        data.profileImg!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.person),
      );
    } else if (data.profileImg != null) {
      return Image.network(
        data.profileImg!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.person),
      );
    }
    return Image.asset(
      'assets/images/profile.png',
      fit: BoxFit.cover,
    );
  }

  Widget _buildTypeTag() {
    return Container(
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
    );
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    //   decoration: BoxDecoration(
    //     color: _getTypeColor(),
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    //   child: Text(
    //     data.entryType ?? data.profileType ?? 'Visitor',
    //     style: const TextStyle(
    //       color: Colors.white,
    //       fontSize: 12,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // );
  }

  Color _getTypeColor() {
    switch (data.entryType ?? data.profileType) {
      case 'service':
        return Colors.blue;
      case 'delivery':
        return Colors.green;
      case 'guest':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  Widget _buildTimingInfo() {
    return Row(
      children: [
        _buildTimeInfo(
          Icons.login,
          DateFormat('hh:mm a').format(data.entryTime ?? DateTime.now()),
          'Entry',
        ),
        const SizedBox(width: 16),
        _buildTimeInfo(
          Icons.logout,
          DateFormat('hh:mm a').format(data.exitTime ?? DateTime.now()),
          'Exit',
        ),
      ],
    );
  }

  Widget _buildTimeInfo(IconData icon, String time, String label) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalInfo() {
    final approvedBy = data.approvedBy?.user?.userName ??
        (data.societyDetails?.societyApartments?.isEmpty ?? true ?
        'No one' :
        data.societyDetails?.societyApartments?[0].entryStatus?.approvedBy?.userName);

    final allowedBy = data.allowedBy?.user?.userName ??
        data.guardStatus?.guard?.userName ?? 'Unknown Guard';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          Icons.check_circle_outline,
          'Approved by $approvedBy',
          Colors.green,
        ),
        const SizedBox(height: 4),
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
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _makePhoneCall,
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

  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _DetailSheet(data: data),
    );
  }

  void _showImageDialog(String imageUrl, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Hero(
                tag: 'profile-${data.id}',
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.4,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.error_outline,
                    size: 64,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -16,
              right: -16,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.black),
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

class _DetailSheet extends StatelessWidget {
  final Entry data;

  const _DetailSheet({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Date', DateFormat('dd MMM, yyyy').format(data.entryTime ?? DateTime.now())),
          _buildDetailRow('Entry Time', DateFormat('hh:mm a').format(data.entryTime ?? DateTime.now())),
          _buildDetailRow('Exit Time', DateFormat('hh:mm a').format(data.exitTime ?? DateTime.now())),
          _buildDetailRow('Type', data.entryType ?? data.profileType ?? 'Visitor'),
          if (data.mobNumber != null) _buildDetailRow('Contact', data.mobNumber!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}