// import 'package:flutter/material.dart';
// import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
// import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
// import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
// // ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart';
//
// class GatePassCard extends StatelessWidget {
//   final GatePassBanner data;
//
//   const GatePassCard({super.key, required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Main Card
//         Card(
//           margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
//           color: Colors.black.withValues(alpha: 0.2),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Header Section with Curved Background
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.2),
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       // Profile Image
//                       CustomCachedNetworkImage(
//                         isCircular: true,
//                         size: 70,
//                         imageUrl: data.profileImg,
//                         errorImage: Icons.person,
//                         borderWidth: 2,
//                         onTap: ()=> CustomFullScreenImageViewer.show(context, data.profileImg),
//                       ),
//                       const SizedBox(width: 16),
//                       // Name and Service Details
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               data.name ?? 'Visitor',
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white70,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 data.serviceName ?? 'Service',
//                                 style: const TextStyle(
//                                   color: Colors.white60,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Service Logo
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Image.asset(
//                           data.serviceLogo ?? 'assets/images/default_service.png',
//                           width: 40,
//                           height: 40,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Details Section
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Society and Entry Type
//                       Row(
//                         children: [
//                           _buildInfoChip(
//                             Icons.location_city,
//                             data.societyName ?? 'N/A',
//                             Colors.white70,
//                           ),
//                           const SizedBox(width: 8),
//                           _buildInfoChip(
//                             Icons.door_front_door,
//                             data.entryType ?? 'N/A',
//                             Colors.white70,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Apartments Section
//                       if (data.gatepassAptDetails?.societyApartments != null) ...[
//                         const Text(
//                           'Allowed Apartments',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white70,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: [
//                             ...(data.gatepassAptDetails?.societyApartments
//                             as List<SocietyApartment>)
//                                 .map((apt) => Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.2),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 '${apt.societyBlock}-${apt.apartment}',
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//
//                       // Validity Timeline
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.2),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: _buildTimelineItem(
//                                     'Start',
//                                     data.checkInCodeStartDate,
//                                     data.checkInCodeStart,
//                                     Icons.play_circle,
//                                     Colors.green.shade600,
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 1,
//                                   width: 40,
//                                   color: Colors.grey.shade300,
//                                 ),
//                                 Expanded(
//                                   child: _buildTimelineItem(
//                                     'End',
//                                     data.checkInCodeExpiryDate,
//                                     data.checkInCodeExpiry,
//                                     Icons.stop_circle,
//                                     Colors.red.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Check-in Code Section
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.2),
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.qr_code, color: Colors.white70),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Check-in Code: ',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(
//                         data.checkInCode ?? 'N/A',
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.share_rounded,
//                           color: Colors.white70,
//                         ),
//                         onPressed: () => _shareCheckInCode(context),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoChip(IconData icon, String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimelineItem(
//       String label,
//       DateTime? date,
//       DateTime? time,
//       IconData icon,
//       Color color,
//       ) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white70,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           date?.toLocal().toString().split(' ')[0] ?? 'N/A',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           _formatTime(time?.toLocal().toString()) ?? 'N/A',
//           style: TextStyle(
//             color: color,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   String? _formatTime(String? timeString) {
//     if (timeString == null) return null;
//     DateTime time = DateTime.parse(timeString);
//     return DateFormat('hh:mm a').format(time);
//   }
//
//   void _shareCheckInCode(BuildContext context) {
//     Navigator.pushNamed(context, '/gate-pass-banner-screen', arguments: data);
//   }
// }

import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';

class GatePassCard extends StatelessWidget {
  final GatePassBannerGuard gatePassBanner;
  final VoidCallback? onViewPressed;

  const GatePassCard({
    super.key,
    required this.gatePassBanner,
    this.onViewPressed,
  });

  bool get _isApproved {
    return gatePassBanner.guardStatus?.status == "approve";
  }

  List<SocietyApartment> get _approvedApartments {
    return gatePassBanner.gatepassAptDetails?.societyApartments
        ?.where((apt) => apt.entryStatus?.status?.toLowerCase() == "approve")
        .toList() ?? [];
  }

  Widget _buildApartmentDropdown(bool isTablet) {
    final List<SocietyApartment?> approvedApartments = _approvedApartments;

    return Container(
      padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.home,
            color: Colors.white.withValues(alpha: 0.8),
            size: isTablet ? 18.0 : 16.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apartments',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: isTablet ? 11.0 : 10.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (String value) {},
                  itemBuilder: (BuildContext context) {
                    return approvedApartments.map((apartment) {
                      final aptText = '${apartment?.societyBlock ?? ''} ${apartment?.apartment ?? ''}'.trim();
                      return PopupMenuItem<String>(
                        height: 36.0, // ✅ Compact item height
                        value: aptText,
                        child: Text(
                          aptText.isEmpty ? 'N/A' : aptText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 13.0 : 12.0,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  color: const Color(0xFF125AAA),
                  offset: const Offset(0, 25), // 👈 Adjust dropdown position
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded( // same as Expanded but more conservative
                        child: Text(
                          '${approvedApartments.isNotEmpty ? approvedApartments[0]?.societyBlock ?? '' : 'No approved Apartment'} ${approvedApartments.isNotEmpty ? approvedApartments[0]?.apartment ?? '' : ''}'.trim(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: isTablet ? 14.0 : 13.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _isNotExpired {
    if (gatePassBanner.checkInCodeExpiryDate == null) return false;
    return gatePassBanner.checkInCodeExpiryDate!.isAfter(DateTime.now());
  }

  bool get _shouldShowCard => _isApproved && _isNotExpired;

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowCard) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isTablet, context),
            const SizedBox(height: 16.0),
            _buildServiceInfo(isTablet),
            const SizedBox(height: 12.0),
            _buildResidentInfo(isTablet),
            const SizedBox(height: 12.0),
            _buildLocationInfo(isTablet),
            const SizedBox(height: 16.0),
            _buildBottomSection(isTablet, context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isTablet, BuildContext context) {
    return Row(
      children: [
        if (gatePassBanner.serviceLogo != null) ...[
          CustomCachedNetworkImage(
            imageUrl: gatePassBanner.serviceLogo!,
            size: 50,
            isCircular: true,
            borderWidth: 2,
            errorImage: Icons.person,
            onTap: ()=> CustomFullScreenImageViewer.show(context, gatePassBanner.serviceLogo!, errorImage: Icons.person),
          ),
          const SizedBox(width: 12.0),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gatePassBanner.serviceName ?? 'Service Request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 20.0 : 18.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'APPROVED',
                  style: TextStyle(
                    color: Colors.green.shade200,
                    fontSize: isTablet ? 12.0 : 10.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: Colors.white.withValues(alpha: 0.9),
            size: isTablet ? 22.0 : 20.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visitor Details',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: isTablet ? 13.0 : 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  gatePassBanner.name ?? 'N/A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16.0 : 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (gatePassBanner.mobNumber != null) ...[
            Icon(
              Icons.phone,
              color: Colors.white.withValues(alpha: 0.7),
              size: isTablet ? 18.0 : 16.0,
            ),
            const SizedBox(width: 4.0),
            Text(
              gatePassBanner.mobNumber!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: isTablet ? 14.0 : 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResidentInfo(bool isTablet) {
    final approvedBy = gatePassBanner.approvedBy;

    return Row(
      children: [
        Expanded(
          child: _buildApartmentDropdown(isTablet),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: _buildInfoItem(
            icon: Icons.person_outline,
            label: 'Approved By',
            value: approvedBy?.userName ?? 'N/A',
            isTablet: isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(bool isTablet) {
    return _buildInfoItem(
      icon: Icons.location_city,
      label: 'Society',
      value: gatePassBanner.societyName ?? 'N/A',
      isTablet: isTablet,
      fullWidth: true,
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
    bool fullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.8),
            size: isTablet ? 18.0 : 16.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: isTablet ? 11.0 : 10.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value.trim().isEmpty ? 'N/A' : value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 14.0 : 13.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool isTablet, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (gatePassBanner.checkInCodeExpiryDate != null) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valid Until',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: isTablet ? 12.0 : 11.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  _formatDate(gatePassBanner.checkInCodeExpiryDate!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 14.0 : 13.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        ElevatedButton(
          onPressed: onViewPressed ?? () {
            // Placeholder for navigation
            Navigator.pushNamed(context, '/gate-pass-service-screen', arguments: gatePassBanner);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF125AAA),
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24.0 : 20.0,
              vertical: isTablet ? 12.0 : 10.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View',
                style: TextStyle(
                  fontSize: isTablet ? 15.0 : 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6.0),
              Icon(
                Icons.arrow_forward_ios,
                size: isTablet ? 16.0 : 14.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}