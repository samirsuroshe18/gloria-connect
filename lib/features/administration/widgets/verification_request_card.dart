import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class VerificationRequestCard extends StatelessWidget {
  final String profileImageUrl;
  final String userName;
  final String date;
  final String role;
  final Color tagColor;
  final String societyName;
  final String? blockName;
  final String? apartment;
  final String? gateAssign;
  final bool isLoadingApprove;
  final bool isLoadingReject;
  final String time;
  final VoidCallback onApprove;
  final VoidCallback onCall;
  final VoidCallback onReject;
  final String? profileType;
  final String? ownership;
  final String? tenantAgreement;
  final String? ownershipDocument;
  final DateTime? startDate;
  final DateTime? endDate;

  const VerificationRequestCard({
    super.key,
    required this.profileImageUrl,
    required this.userName,
    required this.date,
    required this.role,
    required this.tagColor,
    required this.societyName,
    this.blockName,
    this.apartment,
    this.gateAssign,
    required this.isLoadingApprove,
    required this.isLoadingReject,
    required this.time,
    required this.onApprove,
    required this.onCall,
    required this.onReject,
    this.profileType,
    this.ownership,
    this.tenantAgreement,
    this.ownershipDocument,
    this.startDate,
    this.endDate,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _showDocumentDialog(BuildContext context, {
    required String documentUrl,
    String? startDate,
    String? endDate,
    bool isTenantAgreement = false,
  }) {
    Map<String, dynamic> data = {
      "documentUrl": documentUrl,
      "isTenantAgreement": isTenantAgreement,
      "endDate": endDate,
      "startDate": startDate,
      "title": isTenantAgreement ? 'Tenant Agreement' : 'Ownership Document'
    };
    Navigator.pushNamed(context, '/document-view-screen', arguments: data);
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'profile_$userName',
                        child: CustomCachedNetworkImage(
                          imageUrl: profileImageUrl,
                          size: 60,
                          isCircular: true,
                          borderWidth: 3,
                          errorImage: Icons.person,
                          onTap: ()=> CustomFullScreenImageViewer.show(context, profileImageUrl),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tagColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: tagColor),
                                  ),
                                  child: Text(
                                    role,
                                    style: TextStyle(
                                      color: tagColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildInfoChip(
                                  Icons.calendar_today,
                                  date,
                                  Colors.white70,
                                ),
                                const SizedBox(width: 8),
                                _buildInfoChip(
                                  Icons.access_time,
                                  time,
                                  Colors.white70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailSection(),
                  if (_shouldShowDocumentButton())
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _buildDocumentButton(context),
                    ),
                ],
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.location_city, societyName),
          if (blockName != null) _buildDetailRow(Icons.apartment, blockName!),
          if (apartment != null) _buildDetailRow(Icons.home, apartment!),
          if (gateAssign != null)
            _buildDetailRow(Icons.door_sliding_outlined, gateAssign!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowDocumentButton() {
    return (profileType == 'Resident' && ownership == 'tenant' && tenantAgreement != null) ||
        (profileType == 'Resident' && ownership == 'owner' && ownershipDocument != null);
  }

  Widget _buildDocumentButton(BuildContext context) {
    final bool isTenant = profileType == 'Resident' && ownership == 'tenant';
    return ElevatedButton.icon(
      onPressed: () {
        _showDocumentDialog(
          context,
          documentUrl: isTenant ? tenantAgreement! : ownershipDocument!,
          startDate: isTenant ? _formatDate(startDate) : null,
          endDate: isTenant ? _formatDate(endDate) : null,
          isTenantAgreement: isTenant,
        );
      },
      icon: const Icon(Icons.description, color: Colors.white70,),
      label: Text(
        isTenant ? 'View Tenant Agreement' : 'View Ownership Document',
        style: const TextStyle(
          color: Colors.white70
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade50.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.blue.shade200),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              onPressed: onApprove,
              icon: Icons.check_circle_outline,
              label: "Approve",
              isLoading: isLoadingApprove,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              onPressed: onCall,
              icon: Icons.phone,
              label: "Call",
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              onPressed: onReject,
              icon: Icons.cancel_outlined,
              label: "Reject",
              isLoading: isLoadingReject,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    bool isLoading = false,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.5)),
        ),
      ),
      child: isLoading
          ? SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70
            ),
          ),
        ],
      ),
    );
  }
}