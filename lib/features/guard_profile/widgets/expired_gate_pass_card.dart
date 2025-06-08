import 'package:flutter/material.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ExpiredGatePassCard extends StatelessWidget {
  final GatePassBannerGuard gatePass;
  final VoidCallback onDelete;
  final bool isLoading;

  const ExpiredGatePassCard({
    super.key,
    required this.gatePass,
    required this.onDelete,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final screenWidth = MediaQuery.of(context).size.width;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? 16 : 12,
            vertical: 8,
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.black.withValues(alpha: 0.2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xCC125AAA), // Deep Blue
                    Color(0xCCA72524), // Rich Red
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black.withValues(alpha: 0.2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  child: _buildCardContent(context, isTablet, screenWidth),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context, bool isTablet, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with delete button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'EXPIRED GATEPASS',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            if(isLoading)
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            if (!isLoading)
            _buildDeleteButton(context),
          ],
        ),
        const SizedBox(height: 16),

        // Main content
        if (isTablet)
          _buildTabletLayout(context)
        else
          _buildMobileLayout(context),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Profile section
        Row(
          children: [
            _buildProfileImage(false),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVisitorInfo(false),
                  const SizedBox(height: 8),
                  _buildServiceInfo(false),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Location and date info
        _buildLocationInfo(false),
        const SizedBox(height: 12),
        _buildExpiryInfo(false),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileImage(true),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVisitorInfo(true),
              const SizedBox(height: 12),
              _buildServiceInfo(true),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationInfo(true),
              const SizedBox(height: 12),
              _buildExpiryInfo(true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage(bool isTablet) {
    final size = isTablet ? 80.0 : 60.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: gatePass.profileImg != null && gatePass.profileImg!.isNotEmpty
            ? Image.network(
          gatePass.profileImg!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(size),
        )
            : _buildDefaultAvatar(size),
      ),
    );
  }

  Widget _buildDefaultAvatar(double size) {
    return Container(
      color: Colors.grey[600],
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Colors.white.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildVisitorInfo(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gatePass.name ?? 'Unknown Visitor',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.phone,
              size: isTablet ? 18 : 16,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              gatePass.mobNumber ?? 'N/A',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceInfo(bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (gatePass.serviceLogo != null && gatePass.serviceLogo!.isNotEmpty) ...[
            Image.network(
              gatePass.serviceLogo!,
              width: isTablet ? 20 : 16,
              height: isTablet ? 20 : 16,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.work_outline,
                size: isTablet ? 20 : 16,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 6),
          ] else ...[
            Icon(
              Icons.work_outline,
              size: isTablet ? 20 : 16,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              gatePass.serviceName ?? 'Service',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          Icons.location_city,
          'Society',
          gatePass.societyName ?? 'N/A',
          isTablet,
        ),
        const SizedBox(height: 8),
        _buildApartmentDropdown()
      ],
    );
  }
  List<SocietyApartment> get _approvedApartments {
    return gatePass.gatepassAptDetails?.societyApartments
        ?.where((apt) => apt.entryStatus?.status?.toLowerCase() == "approve")
        .toList() ?? [];
  }

  Widget _buildApartmentDropdown() {
    final List<SocietyApartment?> approvedApartments = _approvedApartments;

    return Container(
      padding: EdgeInsets.all(10.0),
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
            size: 16.0,
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
                    fontSize: 10.0,
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
                            fontSize: 12.0,
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
                            fontSize: 13.0,
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

  Widget _buildExpiryInfo(bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_filled,
                size: isTablet ? 20 : 18,
                color: Colors.red[300],
              ),
              const SizedBox(width: 8),
              Text(
                'EXPIRED ON',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(gatePass.checkInCodeExpiryDate),
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: isTablet ? 18 : 16,
          color: Colors.white.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: isTablet ? 12 : 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: isTablet ? 15 : 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showDeleteConfirmation(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.red.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.delete_outline,
            color: Colors.red[300],
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Expired Gatepass',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this expired gatepass?',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed:() {
                Navigator.of(context).pop();
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }
}