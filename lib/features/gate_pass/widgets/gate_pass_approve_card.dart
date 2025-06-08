import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/gate_pass/models/gate_pass_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class GatePassApproveCard extends StatelessWidget {
  final GatePassBanner data;

  const GatePassApproveCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Card
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
          color: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section with Curved Background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Profile Image
                      CustomCachedNetworkImage(
                        isCircular: true,
                        size: 70,
                        imageUrl: data.profileImg,
                        errorImage: Icons.person,
                        borderWidth: 2,
                        onTap: ()=> CustomFullScreenImageViewer.show(context, data.profileImg),
                      ),
                      const SizedBox(width: 16),
                      // Name and Service Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name ?? 'Visitor',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                data.serviceName ?? 'Service',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Service Logo
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          data.serviceLogo ?? 'assets/images/default_service.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Society and Entry Type
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.location_city,
                            data.societyName ?? 'N/A',
                            Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.door_front_door,
                            data.entryType ?? 'N/A',
                            Colors.white70,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Apartments Section
                      if (data.gatepassAptDetails?.societyApartments != null) ...[
                        const Text(
                          'Allowed Apartments',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...(data.gatepassAptDetails?.societyApartments
                            as List<SocietyApartment>)
                                .map((apt) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${apt.societyBlock}-${apt.apartment}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Validity Timeline
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimelineItem(
                                    'Start',
                                    data.checkInCodeStartDate,
                                    data.checkInCodeStart,
                                    Icons.play_circle,
                                    Colors.green.shade600,
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: 40,
                                  color: Colors.grey.shade300,
                                ),
                                Expanded(
                                  child: _buildTimelineItem(
                                    'End',
                                    data.checkInCodeExpiryDate,
                                    data.checkInCodeExpiry,
                                    Icons.stop_circle,
                                    Colors.red.shade600,
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

                // Check-in Code Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code, color: Colors.white70),
                      const SizedBox(width: 8),
                      const Text(
                        'Check-in Code: ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        data.checkInCode ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(
                          Icons.share_rounded,
                          color: Colors.white70,
                        ),
                        onPressed: () => _shareCheckInCode(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      String label,
      DateTime? date,
      DateTime? time,
      IconData icon,
      Color color,
      ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date?.toLocal().toString().split(' ')[0] ?? 'N/A',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatTime(time?.toLocal().toString()) ?? 'N/A',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String? _formatTime(String? timeString) {
    if (timeString == null) return null;
    DateTime time = DateTime.parse(timeString);
    return DateFormat('hh:mm a').format(time);
  }

  void _shareCheckInCode(BuildContext context) {
    Navigator.pushNamed(context, '/gate-pass-banner-screen', arguments: data);
  }
}