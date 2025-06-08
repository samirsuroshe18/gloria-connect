import 'package:flutter/material.dart';
import 'package:gloria_connect/features/gate_pass/models/gate_pass_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ApprovedGatepassCard extends StatelessWidget {
  final GatePassBanner gatePass;
  final VoidCallback onDelete;
  final bool isLoading;

  const ApprovedGatepassCard({
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

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: 8,
          ),
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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isTablet),
                  const SizedBox(height: 16),
                  _buildVisitorInfo(isTablet),
                  const SizedBox(height: 16),
                  _buildServiceInfo(isTablet),
                  const SizedBox(height: 16),
                  _buildCheckInInfo(isTablet),
                  if (gatePass.approvedBy != null) ...[
                    const SizedBox(height: 12),
                    _buildApprovalInfo(isTablet),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: isTablet ? 18 : 16,
              ),
              const SizedBox(width: 6),
              Text(
                'APPROVED',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 14 : 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
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
        IconButton(
          onPressed: () => _showDeleteConfirmation(context),
          icon: Icon(
            Icons.delete_rounded,
            color: Colors.red.shade300,
            size: isTablet ? 24 : 20,
          ),
          tooltip: 'Delete Gatepass',
        ),
      ],
    );
  }

  Widget _buildVisitorInfo(bool isTablet) {
    return Row(
      children: [
        Container(
          width: isTablet ? 70 : 60,
          height: isTablet ? 70 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            image: gatePass.profileImg != null && gatePass.profileImg!.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(gatePass.profileImg!),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: gatePass.profileImg == null || gatePass.profileImg!.isEmpty
              ? Icon(
            Icons.person_rounded,
            color: Colors.white.withValues(alpha: 0.7),
            size: isTablet ? 35 : 30,
          )
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gatePass.name ?? 'Unknown Visitor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (gatePass.mobNumber != null)
                Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: isTablet ? 16 : 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      gatePass.mobNumber!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
                ),
                child: Text(
                  gatePass.entryType ?? 'General Entry',
                  style: TextStyle(
                    color: Colors.blue.shade200,
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.business_center_rounded,
            color: Colors.orange.shade300,
            size: isTablet ? 24 : 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  gatePass.serviceName ?? 'Service Visit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInInfo(bool isTablet) {
    final expiryDate = gatePass.checkInCodeExpiryDate;
    final checkInCode = gatePass.checkInCode;
    final isExpired = expiryDate != null && expiryDate.isBefore(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isExpired
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpired
              ? Colors.red.withValues(alpha: 0.3)
              : Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.qr_code_rounded,
                color: isExpired ? Colors.red.shade300 : Colors.green.shade300,
                size: isTablet ? 24 : 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check-in Code',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      checkInCode ?? 'Not Generated',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (expiryDate != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isExpired ? Icons.schedule_rounded : Icons.timer_rounded,
                  color: isExpired
                      ? Colors.red.shade300
                      : Colors.white.withValues(alpha: 0.7),
                  size: isTablet ? 18 : 16,
                ),
                const SizedBox(width: 8),
                Text(
                  isExpired
                      ? 'Expired: ${DateFormat('MMM dd, yyyy hh:mm a').format(expiryDate)}'
                      : 'Valid until: ${DateFormat('MMM dd, yyyy hh:mm a').format(expiryDate)}',
                  style: TextStyle(
                    color: isExpired
                        ? Colors.red.shade300
                        : Colors.white.withValues(alpha: 0.8),
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildApprovalInfo(bool isTablet) {
    final approver = gatePass.approvedBy;
    if (approver == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_pin_rounded,
            color: Colors.white.withValues(alpha: 0.6),
            size: isTablet ? 18 : 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Approved by: ${approver.userName ?? approver.email ?? 'Admin'}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: isTablet ? 14 : 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.orange.shade400,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete Gatepass',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this approved gatepass for ${gatePass.name ?? 'this visitor'}?',
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
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}