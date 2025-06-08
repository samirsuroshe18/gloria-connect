import 'package:flutter/material.dart';
import 'package:gloria_connect/features/gate_pass/models/gate_pass_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class RejectedGatePassCard extends StatelessWidget {
  final GatePassBanner gatePassData;

  const RejectedGatePassCard({
    super.key,
    required this.gatePassData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive design - adjust layout based on screen width
        bool isTablet = constraints.maxWidth > 600;
        double cardPadding = isTablet ? 20.0 : 16.0;
        double avatarSize = isTablet ? 70.0 : 60.0;
        double titleFontSize = isTablet ? 18.0 : 16.0;
        double subtitleFontSize = isTablet ? 14.0 : 12.0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xCC125AAA), // Deep Blue
                Color(0xCCA72524), // Rich Red
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with rejected status
                Row(
                  children: [
                    Icon(
                      Icons.cancel,
                      color: Colors.red[400],
                      size: isTablet ? 28 : 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'REJECTED GATEPASS',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.red[400]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        gatePassData.entryType ?? 'VISITOR',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: subtitleFontSize - 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Main content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile image
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: gatePassData.profileImg != null
                            ? Image.network(
                          gatePassData.profileImg!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildDefaultAvatar(avatarSize, titleFontSize),
                        )
                            : _buildDefaultAvatar(avatarSize, titleFontSize),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            gatePassData.name ?? 'Unknown Visitor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Phone number
                          if (gatePassData.mobNumber != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.white70,
                                  size: subtitleFontSize + 2,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  gatePassData.mobNumber!,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: subtitleFontSize,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),

                          // Service name
                          if (gatePassData.serviceName != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                gatePassData.serviceName!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Rejection information
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.block,
                            color: Colors.red[400],
                            size: subtitleFontSize + 4,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Access Rejected',
                            style: TextStyle(
                              color: Colors.red[400],
                              fontSize: subtitleFontSize + 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Rejected by information
                      if (_getRejectionInfo() != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Rejected by: ${_getRejectionInfo()!['name']}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: subtitleFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_getRejectionInfo()!['role'] != null)
                          Text(
                            'Role: ${_getRejectionInfo()!['role']}',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: subtitleFontSize - 1,
                            ),
                          ),
                      ],

                      // Date information
                      if (gatePassData.createdAt != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Request Date: ${_formatDate(gatePassData.createdAt!)}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Apartment details
                if (gatePassData.apartment != null || gatePassData.societyBlock != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white60,
                        size: subtitleFontSize + 2,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${gatePassData.societyBlock ?? ''} ${gatePassData.apartment ?? ''}',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultAvatar(double size, double fontSize) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.red[300]!,
            Colors.red[500]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }

  Map<String, String?>? _getRejectionInfo() {
    // Check for rejection in entry status
    if (gatePassData.gatepassAptDetails?.societyApartments != null) {
      for (var apartment in gatePassData.gatepassAptDetails!.societyApartments!) {
        if (apartment.entryStatus?.rejectedBy != null) {
          return {
            'name': apartment.entryStatus!.rejectedBy!.userName ?? 'Unknown',
            'role': apartment.entryStatus!.rejectedBy!.role,
          };
        }
      }
    }

    // Check guard status for rejection
    if (gatePassData.guardStatus?.status?.toLowerCase() == 'rejected' &&
        gatePassData.guardStatus?.guard != null) {
      return {
        'name': gatePassData.guardStatus!.guard!.userName ?? 'Security Guard',
        'role': gatePassData.guardStatus!.guard!.role ?? 'Guard',
      };
    }

    return null;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

// Usage Example:
class RejectedGatePassList extends StatelessWidget {
  final List<GatePassBanner> rejectedGatePasses;

  const RejectedGatePassList({
    super.key,
    required this.rejectedGatePasses,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rejectedGatePasses.length,
      itemBuilder: (context, index) {
        return RejectedGatePassCard(
          gatePassData: rejectedGatePasses[index],
        );
      },
    );
  }
}