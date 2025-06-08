import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gloria_connect/features/gate_pass/models/gate_pass_model.dart';

class PendingResidentGatepassCard extends StatefulWidget {
  final GatePassBanner gatePassData;
  final bool isLoadingApprove;
  final bool isLoadingReject;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PendingResidentGatepassCard({
    super.key,
    required this.gatePassData,
    required this.onApprove,
    required this.onReject,
    required this.isLoadingApprove,
    required this.isLoadingReject
  });

  @override
  State<PendingResidentGatepassCard> createState() => _PendingResidentGatepassCardState();
}

class _PendingResidentGatepassCardState extends State<PendingResidentGatepassCard> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (widget.gatePassData.createdAt != null) {
      final now = DateTime.now();
      final expiryTime = widget.gatePassData.createdAt!.add(Duration(minutes: 20));

      if (expiryTime.isAfter(now)) {
        _timeLeft = expiryTime.difference(now);

        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _timeLeft = expiryTime.difference(DateTime.now());
            if (_timeLeft.isNegative) {
              _timeLeft = Duration.zero;
              timer.cancel();
            }
          });
        });
      }
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildTimerWidget() {
    bool isExpired = _timeLeft.isNegative || _timeLeft == Duration.zero;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExpired ? Colors.red.withValues(alpha: 0.8) : Colors.orange.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.timer_off : Icons.timer,
            size: 16,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            isExpired ? 'Expired' : _formatTime(_timeLeft),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    required bool isLoading,
    required IconData icon,
  }) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: color.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? Center(
            child: SizedBox(
              height: 12,
              width: 12,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 4),
              Text(
                text,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth > 600;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
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
                offset: Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(50),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with status and timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pending_actions,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'PENDING',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTimerWidget(),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Main content
                  Row(
                    children: [
                      // Profile Image
                      Container(
                        width: isTablet ? 70 : 60,
                        height: isTablet ? 70 : 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: widget.gatePassData.profileImg?.isNotEmpty == true
                              ? Image.network(
                            widget.gatePassData.profileImg!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: isTablet ? 35 : 30,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          )
                              : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: isTablet ? 35 : 30,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 16),

                      // Visitor Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.gatePassData.name ?? 'Unknown Visitor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 18 : 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (widget.gatePassData.serviceLogo?.isNotEmpty == true) ...[
                                  SizedBox(width: 8),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        widget.gatePassData.serviceLogo!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.business,
                                            size: 20,
                                            color: Colors.grey[600],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            SizedBox(height: 4),

                            if (widget.gatePassData.mobNumber?.isNotEmpty == true)
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.gatePassData.mobNumber!,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: isTablet ? 14 : 12,
                                    ),
                                  ),
                                ],
                              ),

                            SizedBox(height: 2),

                            if (widget.gatePassData.serviceName?.isNotEmpty == true)
                              Row(
                                children: [
                                  Icon(
                                    Icons.work_outline,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.gatePassData.serviceName!,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                            SizedBox(height: 2),

                            if (widget.gatePassData.entryType?.isNotEmpty == true)
                              Row(
                                children: [
                                  Icon(
                                    Icons.directions_walk,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.gatePassData.entryType!,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: isTablet ? 14 : 12,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      _buildActionButton(
                        text: 'Reject',
                        color: Colors.red[600]!,
                        icon: Icons.close,
                        isLoading: widget.isLoadingReject,
                        onPressed: widget.onReject,
                      ),

                      SizedBox(width: 12),

                      _buildActionButton(
                        text: 'Approve',
                        color: Colors.green[600]!,
                        icon: Icons.check,
                        isLoading: widget.isLoadingApprove,
                        onPressed: widget.onApprove,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}