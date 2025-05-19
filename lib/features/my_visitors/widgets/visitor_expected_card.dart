import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:gloria_connect/utils/phone_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class VisitorExpectedCard extends StatelessWidget {
  final PreApprovedBanner data;
  final String profileImageUrl;
  final String userName;
  final String date;
  final String? companyName;
  final String? companyLogo;
  final String? serviceName;
  final String? serviceLogo;
  final String tag;
  final Color tagColor;

  const VisitorExpectedCard({
    required this.profileImageUrl,
    required this.userName,
    this.companyName,
    this.companyLogo,
    this.serviceName,
    this.serviceLogo,
    required this.date,
    required this.tag,
    required this.tagColor,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with status banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_available,
                    size: 20,
                    color: tagColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tag,
                    style: TextStyle(
                      color: tagColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('MMM d, y').format(DateTime.parse(date)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
        
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image with tap to expand
                  CustomCachedNetworkImage(
                    imageUrl: profileImageUrl,
                    isCircular: true,
                    borderWidth: 2,
                    size: 60,
                    onTap: ()=> CustomFullScreenImageViewer.show(
                      context,
                      profileImageUrl
                    ),
                  ),
                  const SizedBox(width: 16),
        
                  // Visitor details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            color: Colors.white70
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (serviceName != null || companyName != null)
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      serviceLogo ?? companyLogo!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  serviceName ?? companyName!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('hh:mm a').format(DateTime.parse(date)),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.share,
                      label: 'Share Code',
                      isCall: false,
                      primary: true,
                      onShare: (){
                        Navigator.pushNamed(
                          context,
                          '/otp-banner',
                          arguments: data,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      mobNumber: data.mobNumber,
                      icon: Icons.phone,
                      label: 'Call Visitor',
                      isCall: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String? mobNumber;
  final IconData icon;
  final String label;
  final bool primary;
  final bool isCall;
  final VoidCallback? onShare;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.primary = false,
    this.mobNumber,
    required this.isCall,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if(isCall && onShare==null){
          PhoneUtils.makePhoneCall(context, mobNumber?? '');
        }else{
          onShare!();
        }

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? Theme.of(context).primaryColor : Colors.grey[200],
        foregroundColor: primary ? Colors.white : Colors.grey[800],
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}