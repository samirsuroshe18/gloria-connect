import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
import 'package:gloria_connect/features/guard_duty/model/guard_info_model.dart';
import 'package:gloria_connect/features/guard_duty/model/guard_log_model.dart';
import 'package:gloria_connect/features/guard_duty/widgets/info_tile.dart';
import 'package:gloria_connect/features/guard_duty/widgets/shift_history_tile.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class GuardReport extends StatefulWidget {
  final String guardId;

  const GuardReport({super.key, required this.guardId});

  @override
  State<GuardReport> createState() => _GuardReportState();
}

class _GuardReportState extends State<GuardReport> {
  List<GuardLogEntry> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  GuardInfoModel? guardInfo;

  @override
  void initState() {
    super.initState();
    context.read<GuardDutyBloc>().add(GetGuardInfo(id: widget.guardId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guard Report',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: BlocConsumer<GuardDutyBloc, GuardDutyState>(
        listener: (context, state) {
          if (state is GetGuardInfoLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GetGuardInfoSuccess) {
            _isLoading = false;
            _isError = false;
            guardInfo = state.response;
          }
          if (state is GetGuardInfoFailure) {
            data = [];
            _isLoading = false;
            _isError = true;
            statusCode = state.status;
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return const CustomLoader();
          } else if (_isError) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else if (guardInfo != null) {
            return _buildSuccessContent();
          } else {
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'No guard data available.',);
          }
        },
      ),
    );
  }

  Widget _buildSuccessContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildGuardHeaderCard(),
          const SizedBox(height: 16),
          _buildGuardDetailsSection(),
          // const SizedBox(height: 16),
          // _buildShiftActivitySection(),
          // const SizedBox(height: 16),
          // _buildPerformanceMetrics(),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGuardHeaderCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CustomCachedNetworkImage(
                  imageUrl: guardInfo?.user?.profile,
                  errorImage: Icons.person,
                  borderWidth: 3,
                  isCircular: true,
                  size: 80,
                  onTap: ()=> CustomFullScreenImageViewer.show(context, guardInfo?.user?.profile),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guardInfo?.user?.userName ?? "Not Available",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // const SizedBox(height: 4),
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.verified_user,
                      //       size: 16,
                      //       color: Colors.white70,
                      //     ),
                      //     const SizedBox(width: 4),
                      //     Text(
                      //       "ID: ${guardInfo?.user?.id?.substring(0, 8) ?? 'NA'}",
                      //       style: const TextStyle(
                      //         fontSize: 14,
                      //         color: Colors.white70,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.password,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'CheckIn: ${guardInfo?.checkInCode ?? 'NA'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusItem(
                  "Present",
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatusItem(
                  _getFormattedDate(),
                  Icons.calendar_today,
                  Colors.white70,
                ),
                _buildStatusItem(
                  "Gate ${guardInfo?.gateAssign ?? 'NA'}",
                  Icons.door_front_door,
                  Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, IconData icon, Color iconColor) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGuardDetailsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.person_pin,
                  color: Colors.white70,
                  size: 35,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Guard Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                  onPressed: () {
                    // Add edit functionality
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          InfoTile(
            label: 'Society Name',
            value: guardInfo?.societyName ?? 'Not Available',
            icon: Icons.apartment,
          ),
          InfoTile(
            label: 'Assigned Gate',
            value: 'Gate ${guardInfo?.gateAssign ?? 'Not Assigned'}',
            icon: Icons.door_sliding,
          ),
          const InfoTile(
            label: 'Contact',
            value: 'Not Available',
            icon: Icons.phone,
          ),
          ShiftHistoryTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/shift-history-screen',
                arguments: widget.guardId,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<GuardDutyBloc>().add(GetGuardInfo(id: widget.guardId));
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(now);
  }

  // Widget _buildPerformanceMetrics() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Row(
  //             children: [
  //               const Icon(
  //                 Icons.analytics,
  //                 color: Color(0xFF1E3A8A),
  //                 size: 20,
  //               ),
  //               const SizedBox(width: 8),
  //               const Text(
  //                 'Performance Metrics',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF1E3A8A),
  //                 ),
  //               ),
  //               const Spacer(),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 8,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFF0F4FF),
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 child: const Text(
  //                   'This Month',
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xFF2563EB),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Divider(height: 1),
  //         Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: _buildMetricCard(
  //                   'Check-ins',
  //                   '98',
  //                   Icons.how_to_reg,
  //                   Colors.green,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: _buildMetricCard(
  //                   'Visitors',
  //                   '57',
  //                   Icons.person_add,
  //                   Colors.blue,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: _buildMetricCard(
  //                   'Alerts',
  //                   '3',
  //                   Icons.warning_amber,
  //                   Colors.orange,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  //           child: Row(
  //             children: [
  //               _buildProgressIndicator('On Time', 0.92, Colors.green),
  //               const SizedBox(width: 20),
  //               _buildProgressIndicator('Activity', 0.78, Colors.blue),
  //               const SizedBox(width: 20),
  //               _buildProgressIndicator('Response', 0.85, Colors.purple),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildShiftActivitySection() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Row(
  //             children: [
  //               const Icon(
  //                 Icons.timelapse,
  //                 color: Color(0xFF1E3A8A),
  //                 size: 20,
  //               ),
  //               const SizedBox(width: 8),
  //               const Text(
  //                 'Today\'s Activity',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF1E3A8A),
  //                 ),
  //               ),
  //               const Spacer(),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 8,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFF0F4FF),
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 child: const Text(
  //                   'Today',
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xFF2563EB),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Divider(height: 1),
  //         if (data.isEmpty)
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Center(
  //               child: Column(
  //                 children: [
  //                   Lottie.asset(
  //                     'assets/animations/no_data.json',
  //                     width: 120,
  //                     height: 120,
  //                     fit: BoxFit.contain,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   const Text(
  //                     'No activity recorded today',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Color(0xFF64748B),
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           )
  //         else
  //           ListView.builder(
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: data.length > 5 ? 5 : data.length,
  //             itemBuilder: (context, index) {
  //               return _buildActivityItem(data[index], index);
  //             },
  //           ),
  //         if (data.isNotEmpty && data.length > 5)
  //           Padding(
  //             padding: const EdgeInsets.all(16),
  //             child: Center(
  //               child: TextButton(
  //                 onPressed: () {
  //                   // View all activities
  //                 },
  //                 style: TextButton.styleFrom(
  //                   foregroundColor: const Color(0xFF2563EB),
  //                 ),
  //                 child: const Text('View All Activities'),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildActivityItem(GuardLogEntry entry, int index) {
  //   // Replace with actual data from GuardLogEntry
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     decoration: BoxDecoration(
  //       border: Border(
  //         bottom: BorderSide(
  //           color: index == data.length - 1
  //               ? Colors.transparent
  //               : Colors.grey.shade200,
  //         ),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 40,
  //           height: 40,
  //           decoration: BoxDecoration(
  //             color: const Color(0xFFF0F4FF),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: const Icon(
  //             Icons.how_to_reg,
  //             color: Color(0xFF2563EB),
  //             size: 20,
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'Visitor Entry Registered',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 14,
  //                   color: Color(0xFF2C3E50),
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 'Visitor ID: #${10000 + index}',
  //                 style: const TextStyle(
  //                   fontSize: 12,
  //                   color: Color(0xFF64748B),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Text(
  //               '${(index + 8).toString().padLeft(2, '0')}:${(index * 10 + 15).toString().padLeft(2, '0')} AM',
  //               style: const TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w500,
  //                 color: Color(0xFF64748B),
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 6,
  //                 vertical: 2,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFE6F7EF),
  //                 borderRadius: BorderRadius.circular(4),
  //               ),
  //               child: const Text(
  //                 'Completed',
  //                 style: TextStyle(
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.w500,
  //                   color: Color(0xFF059669),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildMetricCard(String label, String value, IconData icon, Color color,) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: color.withValues(alpha: 0.1),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(
  //           icon,
  //           color: color,
  //           size: 24,
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: color,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 12,
  //             color: color.withValues(alpha: 0.8),
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildProgressIndicator(String label, double value, Color color) {
  //   return Expanded(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               label,
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 color: Colors.grey.shade700,
  //               ),
  //             ),
  //             Text(
  //               '${(value * 100).toInt()}%',
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.bold,
  //                 color: color,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 6),
  //         LinearProgressIndicator(
  //           value: value,
  //           backgroundColor: Colors.grey.shade200,
  //           valueColor: AlwaysStoppedAnimation<Color>(color),
  //           borderRadius: BorderRadius.circular(2),
  //           minHeight: 5,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}