import 'package:flutter/material.dart';
import 'dart:async';

import '../models/gate_pass_banner.dart';

class PendingGatepassCard extends StatefulWidget {
  final GatePassBannerGuard gatepassData;
  final VoidCallback? onViewPressed;

  const PendingGatepassCard({
    super.key,
    required this.gatepassData,
    this.onViewPressed,
  });

  @override
  State<PendingGatepassCard> createState() => _PendingGatepassCardState();
}

class _PendingGatepassCardState extends State<PendingGatepassCard> {
  Timer? _timer;
  Duration _timeLeft = const Duration(minutes: 20);

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateTimeLeft() {
    try {
      final createdAt = widget.gatepassData.createdAt ?? DateTime.now();
      final now = DateTime.now();
      final elapsed = now.difference(createdAt);
      final tenMinutes = const Duration(minutes: 20);

      if (elapsed < tenMinutes) {
        _timeLeft = tenMinutes - elapsed;
      } else {
        _timeLeft = Duration.zero;
      }
    } catch (e) {
      _timeLeft = const Duration(minutes: 20);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pending_actions,
                          color: Colors.orange[300],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'PENDING',
                          style: TextStyle(
                            color: Colors.orange[300],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _timeLeft.inSeconds > 0
                          ? Colors.red.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _timeLeft.inSeconds > 0
                            ? Colors.red.withValues(alpha: 0.5)
                            : Colors.grey.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: _timeLeft.inSeconds > 0
                              ? Colors.red[300]
                              : Colors.grey[400],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _timeLeft.inSeconds > 0
                              ? _formatDuration(_timeLeft)
                              : 'EXPIRED',
                          style: TextStyle(
                            color: _timeLeft.inSeconds > 0
                                ? Colors.red[300]
                                : Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Service info section
              Row(
                children: [
                  // Service logo
                  Container(
                    width: isTablet ? 60 : 50,
                    height: isTablet ? 60 : 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.gatepassData.serviceLogo != null &&
                          widget.gatepassData.serviceLogo!.isNotEmpty
                          ? Image.asset(
                        widget.gatepassData.serviceLogo!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person_outline,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: isTablet ? 30 : 24,
                          );
                        },
                      )
                          : Icon(
                        Icons.person_outline,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: isTablet ? 30 : 24,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Service details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.gatepassData.name ?? 'Unknown',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.gatepassData.serviceName ?? 'Service',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: isTablet ? 14 : 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.gatepassData.mobNumber ?? 'N/A',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
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

              const SizedBox(height: 16),

              // Apartment details
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withValues(alpha: 0.05),
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(
              //       color: Colors.white.withValues(alpha: 0.1),
              //       width: 1,
              //     ),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             Icons.apartment_outlined,
              //             color: Colors.white.withValues(alpha: 0.7),
              //             size: 16,
              //           ),
              //           const SizedBox(width: 8),
              //           Text(
              //             'Pending Apartments',
              //             style: TextStyle(
              //               color: Colors.white.withValues(alpha: 0.9),
              //               fontSize: isTablet ? 14 : 12,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 8),
              //       Text(
              //         _getPendingApartments() ?? 'N/A',
              //         style: TextStyle(
              //           color: Colors.white.withValues(alpha: 0.8),
              //           fontSize: isTablet ? 14 : 12,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              _buildApartmentDropdown(),

              const SizedBox(height: 16),

              // Bottom section with view button
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       widget.gatepassData.societyName ?? 'Society',
              //       style: TextStyle(
              //         color: Colors.white.withValues(alpha: 0.7),
              //         fontSize: isTablet ? 14 : 12,
              //       ),
              //     ),
              //     ElevatedButton(
              //       onPressed: widget.onViewPressed,
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: const Color(0xFF125AAA),
              //         foregroundColor: Colors.white,
              //         padding: EdgeInsets.symmetric(
              //           horizontal: isTablet ? 24 : 20,
              //           vertical: isTablet ? 12 : 10,
              //         ),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         elevation: 2,
              //       ),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           const Icon(Icons.visibility, size: 16),
              //           const SizedBox(width: 4),
              //           Text(
              //             'View',
              //             style: TextStyle(
              //               fontSize: isTablet ? 14 : 12,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<SocietyApartment?> get _approvedApartments {
    return widget.gatepassData.gatepassAptDetails?.societyApartments
        ?.where((apt) => apt.entryStatus?.status?.toLowerCase() == "pending")
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
                  'Pending Apartments',
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
                          '${approvedApartments.isNotEmpty ? approvedApartments[0]?.societyBlock ?? '' : 'No pending Apartment'} ${approvedApartments.isNotEmpty ? approvedApartments[0]?.apartment ?? '' : ''}'.trim(),
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
}