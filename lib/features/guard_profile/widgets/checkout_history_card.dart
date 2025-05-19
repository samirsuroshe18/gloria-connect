import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/guard_profile/models/checkout_history.dart';
import 'package:gloria_connect/utils/phone_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CheckoutHistoryCard extends StatelessWidget {
  final CheckoutEntry data;

  const CheckoutHistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                  onTap: () => CustomFullScreenImageViewer.show(context, data.profileImg),
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
                        value: data.exitTime != null ? DateFormat('dd MMM, yyyy').format(data.exitTime!) : 'NA',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildTimingInfo(),
            const SizedBox(height: 16),
            _buildApprovalInfo(context),
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
        if (data.entryTime != null)
          Expanded(
            child: _buildInfoTile(
              icon: Icons.login,
              title: 'Entry Time',
              value: data.entryTime != null
                  ? DateFormat('hh:mm a').format(data.entryTime!)
                  : 'NA',
            ),
          ),
        if (data.exitTime != null)
          Expanded(
            child: _buildInfoTile(
              icon: Icons.logout,
              title: 'Exit Time',
              value: data.exitTime != null
                  ? DateFormat('hh:mm a').format(data.exitTime!)
                  : 'NA',
            ),
          ),
      ],
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

  Widget _buildApprovalInfo(BuildContext context) {
    // Get primary approver
    final primaryApprover = data.approvedBy?.user?.userName;
    final primaryApproverApt = data.apartment;

    // Get apartment details for primary approver
    String? apartmentDetails;
    bool isShowDialog = true;
    if (data.societyDetails?.societyApartments?.isNotEmpty ?? false) {
      final List<SocietyApartment>? apartment = data.societyDetails?.societyApartments;
      if(apartment!=null && apartment.isNotEmpty && apartment.length<2 && apartment[0].entryStatus?.status == 'approve'){
        apartmentDetails = "${apartment[0].entryStatus?.approvedBy?.userName} (${apartment[0].apartment})";
      }else if(apartment!=null && apartment.isNotEmpty && apartment.length>1){
        SocietyApartment? isApproveByPresent;
        for(var apt in apartment){
          if(apt.entryStatus?.status == 'approve' && isApproveByPresent==null){
            isApproveByPresent = apt;
          }
        }
        if(isApproveByPresent!=null){
          apartmentDetails = "${isApproveByPresent.entryStatus?.approvedBy?.userName} (${isApproveByPresent.apartment})";
        }else{
          apartmentDetails = "No one";
          isShowDialog = false;
        }
      }else{
        apartmentDetails = "No one";
        isShowDialog = false;
      }
    }

    // Get guard name
    final allowedBy = data.allowedBy?.user?.userName ??
        data.guardStatus?.guard?.userName ??
        'Unknown Guard';

    final String? approvedBy = primaryApprover!=null? '$primaryApprover ($primaryApproverApt)' : apartmentDetails;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Approval row - now clickable to show dialog
        InkWell(
          onTap: () => _showApprovalDetailsDialog(context, isShowDialog),
          child: _buildInfoRow(
            Icons.check_circle_outline,
            'Approved by $approvedBy',
            Colors.green,
            showArrow: isShowDialog,
          ),
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

  Widget _buildInfoRow(IconData icon, String text, Color color, {bool showArrow = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showArrow) Icon(Icons.keyboard_arrow_right, size: 16, color: color),
      ],
    );
  }

  void _showApprovalDetailsDialog(BuildContext context, bool isShowDialog) {
    if (!isShowDialog) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approval Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.approvedBy != null)
                _buildApproverTile(
                  context: context,
                  name: data.approvedBy?.user?.userName ?? "NA",
                  email: data.approvedBy?.user?.email ?? 'NA',
                  apartment: data.apartment,
                  block: data.blockName,
                  mobNumber: data.approvedBy?.user?.phoneNo ?? '',
                ),
              if (data.societyDetails?.societyApartments != null &&
                  data.societyDetails!.societyApartments!.isNotEmpty)
                ...List.generate(
                  data.societyDetails!.societyApartments!.length,
                      (apartmentIndex) {
                    final SocietyApartment apartment =
                    data.societyDetails!.societyApartments![apartmentIndex];
                    final RejectedByClass? approver =
                        apartment.entryStatus?.approvedBy;

                    if (apartment.entryStatus?.status == "pending") {
                      return const SizedBox.shrink();
                    }

                    return _buildApproverTile(
                      context: context,
                      name: approver?.userName ?? 'Unknown',
                      profileImage: approver?.profile,
                      email: approver?.email ?? 'NA',
                      apartment: apartment.apartment,
                      block: apartment.societyBlock,
                      mobNumber: approver?.phoneNo ?? '',
                    );
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildApproverTile({
    required String name,
    required BuildContext context,
    String? email,
    String? apartment,
    String? block,
    String? profileImage,
    bool isIndented = false,
    required String mobNumber,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: isIndented ? 16.0 : 0.0, bottom: 8.0),
      child: Row(
        children: [
          // Profile image or icon
          if (profileImage != null)
            CustomCachedNetworkImage(
              size: 35,
              isCircular: true,
              borderWidth: 1,
              imageUrl: profileImage,
              onTap: ()=> CustomFullScreenImageViewer.show(context, profileImage),
            )
          else
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 16),
            ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (email != null)
                  Text(
                    email,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                if (apartment != null || block != null)
                  Text(
                    '${block ?? ''} ${apartment ?? ''}'.trim(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),

          // Suffix: Call icon
          IconButton(
            icon: const Icon(Icons.call, color: Colors.green),
            onPressed: ()=> PhoneUtils.makePhoneCall(context, mobNumber),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => PhoneUtils.makePhoneCall(context, data.mobNumber ?? ''),
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