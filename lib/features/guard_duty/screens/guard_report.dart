// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_blurhash/flutter_blurhash.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
// import 'package:gloria_connect/features/guard_duty/model/guard_info_model.dart';
// import 'package:gloria_connect/features/guard_duty/model/guard_log_model.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
//
// class GuardReport extends StatefulWidget {
//   final String guardId;
//
//   const GuardReport({super.key, required this.guardId});
//
//   @override
//   State<GuardReport> createState() => _GuardReportState();
// }
//
// class _GuardReportState extends State<GuardReport> {
//   final ScrollController _scrollController = ScrollController();
//   List<GuardLogEntry> data = [];
//   bool _isLoading = false;
//   bool _isError = false;
//   int? statusCode;
//   bool _isLazyLoading = false;
//   int _page = 1;
//   final int _limit = 3;
//   bool _hasMore = true;
//   String _selectedShift = '';
//   String _selectedGate = '';
//   DateTime? _startDate;
//   DateTime? _endDate;
//   bool _hasActiveFilters = false;
//   GuardInfoModel? guardInfo;
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<GuardDutyBloc>().add(GetGuardInfo(id: widget.guardId));
//     _fetchEntries();
//     _scrollController.addListener(_scrollListener);
//   }
//
//   void _scrollListener() {
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
//       if (!_isLoading && _hasMore && data.length>=_limit) {
//         _isLazyLoading = true;
//         _fetchEntries();
//       }
//     }
//   }
//
//   Future<void> _fetchEntries()async {
//     final queryParams = {
//       'page': _page.toString(),
//       'limit': _limit.toString(),
//       'id': widget.guardId,
//     };
//
//     if (_selectedGate.isNotEmpty) {
//       queryParams['entryType'] = _selectedGate;
//     }
//
//     if (_selectedShift.isNotEmpty) {
//       queryParams['entryType'] = _selectedShift;
//     }
//
//     if (_startDate != null) {
//       queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
//     }
//
//     if (_endDate != null) {
//       queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
//     }
//
//     context.read<GuardDutyBloc>().add(GuardGetLogs(queryParams: queryParams));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Guard Report',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.black.withOpacity(0.2),
//       ),
//       body: BlocConsumer<GuardDutyBloc, GuardDutyState>(
//         listener: (context, state) {
//           if (state is GuardGetLogsLoading) {
//             _isLoading = true;
//             _isError = false;
//             print('logs loading');
//           }
//           if (state is GuardGetLogsSuccess) {
//             if (_page == 1) {
//               data.clear();
//             }
//             data.addAll(state.response.guardLogEntries as Iterable<GuardLogEntry>);
//             _page++;
//             _hasMore = state.response.pagination?.hasMore ?? false;
//             _isLoading = false;
//             _isLazyLoading = false;
//             _isError = false;
//             print('logs success : ${state.response.guardLogEntries?.length}');
//           }
//           if (state is GuardGetLogsFailure) {
//             data = [];
//             _isLoading = false;
//             _isLazyLoading = false;
//             _isError = true;
//             statusCode= state.status;
//             _hasMore = false;
//             print('logs failure : ${state.message}');
//           }
//           if (state is GuardGetLogsLoading) {
//             _isLoading = true;
//             _isError = false;
//             print('loading');
//           }
//           if (state is GetGuardInfoSuccess) {
//             _isLoading = false;
//             _isLazyLoading = false;
//             _isError = false;
//             print('success : ${state.response.societyName}');
//             guardInfo = state.response;
//           }
//           if (state is GetGuardInfoFailure) {
//             data = [];
//             _isLoading = false;
//             _isLazyLoading = false;
//             _isError = true;
//             statusCode= state.status;
//             print(state.message);
//           }
//         },
//         builder: (context, state) {
//           if (data.isNotEmpty && _isLoading == false) {
//             return RefreshIndicator(
//               onRefresh: _onRefresh,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildGuardHeader(context, guardInfo),
//                   _buildInfoSection(guardInfo),
//                   _buildTimelineView(context, guardInfo),
//                 ],
//               ),
//             );
//           } else if (_isLazyLoading) {
//             return RefreshIndicator(
//               onRefresh: _onRefresh,
//               child: AnimationLimiter(
//                 child: _buildGroupedEntriesList(),
//               ),
//             );
//           } else if (_isLoading && _isLazyLoading==false) {
//             return Center(
//               child: Lottie.asset(
//                 'assets/animations/loader.json',
//                 width: 100,
//                 height: 100,
//                 fit: BoxFit.contain,
//               ),
//             );
//           } else if (data.isEmpty && _isError == true && statusCode == 401) {
//             return RefreshIndicator(
//               onRefresh: _onRefresh,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height - 200,
//                   alignment: Alignment.center,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Lottie.asset(
//                         'assets/animations/error.json',
//                         width: 200,
//                         height: 200,
//                         fit: BoxFit.cover,
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         "Something went wrong!",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return RefreshIndicator(
//               onRefresh: _onRefresh,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height - 200,
//                   alignment: Alignment.center,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Lottie.asset(
//                         'assets/animations/no_data.json',
//                         width: 200,
//                         height: 200,
//                         fit: BoxFit.cover,
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         "There is no past visitors",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Future<void> _onRefresh() async {
//     if(data.length==10) {
//       await _fetchEntries();
//     }
//   }
//
//   Widget _buildGuardHeader(BuildContext context, GuardInfoModel? guardData) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.1),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.grey.shade300,
//             child: CachedNetworkImage(
//               imageUrl: guardData?.user?.profile ?? '',
//               fit: BoxFit.cover,
//               placeholder: (context, url) => const BlurHash(
//                 hash: "L6PZfSi_.AyE_3t7t7R**0o#DgR4",
//                 imageFit: BoxFit.cover,
//               ),
//               errorWidget: (context, url, error) => Container(
//                 color: Colors.grey[200],
//                 child: const Icon(
//                   Icons.person,
//                   size: 50,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   guardData?.user?.userName ?? "NA",
//                   style: const TextStyle(
//                     fontSize: 24,
//                     color: Colors.white70,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     'CheckIn Code: ${guardData?.checkInCode ?? 'NA'}',
//                     style: const TextStyle(
//                       color: Colors.white60,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoSection(GuardInfoModel? guardData) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Guard Information',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.white70,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Card(
//             color: Colors.black.withOpacity(0.2),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildInfoRow(
//                     'Society Name',
//                     guardData?.societyName ?? 'NA',
//                     Icons.apartment,
//                   ),
//                   const Divider(height: 24),
//                   _buildInfoRow(
//                     'Assigned Gate',
//                     guardData?.gateAssign ?? 'NA',
//                     Icons.door_sliding,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value, IconData icon,) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           color: Colors.blue,
//           size: 20,
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 12,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white60,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimelineView(BuildContext context, guardData) {
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Shift History',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white70,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(8.0),
//                     onTap: () => _showFilterBottomSheet(context),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Icon(
//                             Icons.filter_list,
//                             color: _hasActiveFilters
//                                 ? Theme.of(context).colorScheme.primary
//                                 : null,
//                           ),
//                           if (_hasActiveFilters)
//                             Positioned(
//                               top: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 8,
//                                 height: 8,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           AnimationLimiter(
//             child: _buildGroupedEntriesList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGroupedEntriesList() {
//
//     return ListView.builder(
//         controller: _scrollController,
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: data.length + 1,
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         itemBuilder: (context, index) {
//           if (index < data.length) {
//             final guardLog = data[index];
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: Card(
//                 color: Colors.black.withOpacity(0.2),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             DateFormat('MMM d, yyyy').format(guardLog.date ?? DateTime.now()),
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white70,
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.amber.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               guardLog.shift ?? 'NA',
//                               style: const TextStyle(
//                                 color: Colors.amber,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Gate',
//                                   style: TextStyle(
//                                     color: Colors.white60,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   guardLog.gate ?? 'NA',
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white70
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Check-in',
//                                   style: TextStyle(
//                                     color: Colors.white60,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   DateFormat('h:mm a').format(guardLog.checkinTime ?? DateTime.now()),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white70
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Check-out',
//                                   style: TextStyle(
//                                     color: Colors.white60,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   DateFormat('h:mm a').format(guardLog.checkoutTime ?? DateTime.now()),
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                         const Text(
//                           'Checkin Note',
//                           style: TextStyle(
//                             color: Colors.white60,
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           guardLog.checkinReason ?? 'NA',
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                         const SizedBox(height: 12,),
//                         const Text(
//                           'Checkout Note',
//                           style: TextStyle(
//                             color: Colors.white60,
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           guardLog.checkoutReason ?? 'NA',
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             if (_hasMore) {
//               return const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 child: Center(child: CircularProgressIndicator()),
//               );
//             } else {
//               return const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 child: Center(child: Text("No more data to load")),
//               );
//             }
//           }
//         }
//     );
//   }
//
//   void _showFilterBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Filter Entries',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             setModalState(() {
//                               _selectedShift = '';
//                               _selectedGate = '';
//                               _startDate = null;
//                               _endDate = null;
//                             });
//                           },
//                           child: const Text('Reset'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Gate',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Wrap(
//                       spacing: 8,
//                       children: [
//                         _buildGateFilterChip('Ground Floor Entry', 'Ground Floor Entry', setModalState),
//                         _buildGateFilterChip('Podium Entry', 'Podium Entry', setModalState),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Shift',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Wrap(
//                       spacing: 8,
//                       children: [
//                         _buildShiftFilterChip('All Shifts', 'All Shifts', setModalState),
//                         _buildShiftFilterChip('Morning', 'Morning', setModalState),
//                         _buildShiftFilterChip('Evening', 'Evening', setModalState),
//                         _buildShiftFilterChip('Night', 'Night', setModalState),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Date Range',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     InkWell(
//                       onTap: () async {
//                         await _selectDateRange(context);
//                         setModalState(() {});
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.date_range),
//                             const SizedBox(width: 8),
//                             Text(
//                               _startDate != null && _endDate != null
//                                   ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}'
//                                   : 'Select date range',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       children: [
//                         // Cancel button
//                         Expanded(
//                           child: SizedBox(
//                             height: 48, // Equal height for both buttons
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text('Cancel'),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: SizedBox(
//                             height: 48, // Same height
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                                 _applyFilters();
//                               },
//                               child: const Text('Apply'),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _applyFilters() {
//     setState(() {
//       _page = 1;
//       _hasMore = true;
//       data.clear();
//       _hasActiveFilters = _selectedGate.isNotEmpty || _selectedShift.isNotEmpty || _startDate != null || _endDate != null;
//     });
//     _fetchEntries();
//   }
//
//   Future<void> _selectDateRange(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       initialDateRange: _startDate != null && _endDate != null
//           ? DateTimeRange(start: _startDate!, end: _endDate!)
//           : null,
//     );
//
//     if (picked != null) {
//       setState(() {
//         _startDate = picked.start;
//         _endDate = picked.end;
//       });
//     }
//   }
//
//   Widget _buildGateFilterChip(String label, String value, StateSetter setModalState) {
//     return FilterChip(
//       label: Text(label),
//       selected: _selectedGate == value,
//       onSelected: (selected) {
//         setModalState(() {
//           _selectedGate = selected ? value : '';
//         });
//       },
//     );
//   }
//
//   Widget _buildShiftFilterChip(String label, String value, StateSetter setModalState) {
//     return FilterChip(
//       label: Text(label),
//       selected: _selectedShift == value,
//       onSelected: (selected) {
//         setModalState(() {
//           _selectedShift = selected ? value : '';
//         });
//       },
//     );
//   }
// }
//
// // DateFormat('MMM d, yyyy').format(history['date'])
// // DateFormat('h:mm a').format(history['checkIn'])

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
import 'package:gloria_connect/features/guard_duty/model/guard_info_model.dart';
import 'package:gloria_connect/features/guard_duty/model/guard_log_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class GuardReport extends StatefulWidget {
  final String guardId;

  const GuardReport({super.key, required this.guardId});

  @override
  State<GuardReport> createState() => _GuardReportState();
}

class _GuardReportState extends State<GuardReport> {
  final ScrollController _scrollController = ScrollController();
  List<GuardLogEntry> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  bool _isLazyLoading = false;
  int _page = 1;
  final int _limit = 3;
  bool _hasMore = true;
  String _selectedShift = '';
  String _selectedGate = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _hasActiveFilters = false;
  GuardInfoModel? guardInfo;

  @override
  void initState() {
    super.initState();
    context.read<GuardDutyBloc>().add(GetGuardInfo(id: widget.guardId));
    _fetchEntries();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore && data.length>=_limit) {
        _isLazyLoading = true;
        _fetchEntries();
      }
    }
  }

  Future<void> _fetchEntries()async {
    final queryParams = {
      'page': _page.toString(),
      'limit': _limit.toString(),
      'id': widget.guardId,
    };

    if (_selectedGate.isNotEmpty) {
      queryParams['gate'] = _selectedGate;
    }

    if (_selectedShift.isNotEmpty) {
      queryParams['shift'] = _selectedShift;
    }

    if (_startDate != null) {
      queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
    }

    if (_endDate != null) {
      queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    context.read<GuardDutyBloc>().add(GuardGetLogs(queryParams: queryParams));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guard Report',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
      body: BlocConsumer<GuardDutyBloc, GuardDutyState>(
        listener: (context, state) {
          if (state is GuardGetLogsLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GuardGetLogsSuccess) {
            if (_page == 1) {
              data.clear();
            }
            data.addAll(state.response.guardLogEntries as Iterable<GuardLogEntry>);
            _page++;
            _hasMore = state.response.pagination?.hasMore ?? false;
            _isLoading = false;
            _isLazyLoading = false;
            _isError = false;
          }
          if (state is GuardGetLogsFailure) {
            data = [];
            _isLoading = false;
            _isLazyLoading = false;
            _isError = true;
            statusCode= state.status;
            _hasMore = false;
          }
          if (state is GuardGetLogsLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GetGuardInfoSuccess) {
            _isLoading = false;
            _isLazyLoading = false;
            _isError = false;
            guardInfo = state.response;
          }
          if (state is GetGuardInfoFailure) {
            data = [];
            _isLoading = false;
            _isLazyLoading = false;
            _isError = true;
            statusCode= state.status;
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuardHeader(context, guardInfo),
                _buildInfoSection(guardInfo),
                _buildTimelineView(context),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: _buildGroupedEntriesList(),
                  ),
                ),
              ],
            );
          } else if (_isLazyLoading) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuardHeader(context, guardInfo),
                _buildInfoSection(guardInfo),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: AnimationLimiter(
                      child: _buildGroupedEntriesList(),
                    ),
                  ),
                ),
              ],
            );
          } else if (_isLoading && _isLazyLoading == false) {
            return Center(
              child: Lottie.asset(
                'assets/animations/loader.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            );
          } else if (data.isEmpty && _isError == true && statusCode == 401) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/error.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Something went wrong!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/no_data.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "There is no past visitors",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

// Then modify your _buildTimelineView to not include the ListView directly
  Widget _buildTimelineView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Shift History',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () => _showFilterBottomSheet(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: _hasActiveFilters
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      if (_hasActiveFilters)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    if(data.length==10) {
      await _fetchEntries();
    }
  }

  Widget _buildGuardHeader(BuildContext context, GuardInfoModel? guardData) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade300,
            child: guardData?.user?.profile?.isNotEmpty == true
                ? CachedNetworkImage(
              imageUrl: guardData!.user!.profile!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.person, size: 50, color: Colors.grey),
            )
                : const Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guardData?.user?.userName ?? "NA",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'CheckIn Code: ${guardData?.checkInCode ?? 'NA'}',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(GuardInfoModel? guardData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Guard Information',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(
                    'Society Name',
                    guardData?.societyName ?? 'NA',
                    Icons.apartment,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Assigned Gate',
                    guardData?.gateAssign ?? 'NA',
                    Icons.door_sliding,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.blue,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildTimelineView(BuildContext context, guardData) {
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text(
  //               'Shift History',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 color: Colors.white70,
  //                 fontWeight: FontWeight.bold,
  //              
  //             ),
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(8.0),
  //               ),
  //               child: Material(
  //                 color: Colors.transparent,
  //                 child: InkWell(
  //                   borderRadius: BorderRadius.circular(8.0),
  //                   onTap: () => _showFilterBottomSheet(context),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(12.0),
  //                     child: Stack(
  //                       alignment: Alignment.center,
  //                       children: [
  //                         Icon(
  //                           Icons.filter_list,
  //                           color: _hasActiveFilters
  //                               ? Theme.of(context).colorScheme.primary
  //                               : null,
  //                         ),
  //                         if (_hasActiveFilters)
  //                           Positioned(
  //                             top: 0,
  //                             right: 0,
  //                             child: Container(
  //                               width: 8,
  //                               height: 8,
  //                               decoration: BoxDecoration(
  //                                 color: Theme.of(context).colorScheme.primary,
  //                                 shape: BoxShape.circle,
  //                               ),
  //                             ),
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         AnimationLimiter(
  //           child: _buildGroupedEntriesList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildGroupedEntriesList() {

    return ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length + 1,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          if (index < data.length) {
            final guardLog = data[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                color: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            guardLog.date != null
                            ? DateFormat('MMM d, yyyy').format(guardLog.date!)
                            : 'NA',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              guardLog.shift ?? 'NA',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Gate',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  guardLog.gate ?? 'NA',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Check-in',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  guardLog.checkinTime != null
                                  ? DateFormat('h:mm a').format(guardLog.checkinTime!)
                                  :'NA',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Check-out',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  guardLog.checkoutTime!=null
                                  ? DateFormat('h:mm a').format(guardLog.checkoutTime!)
                                  :'NA',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Checkin Note',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        guardLog.checkinReason ?? 'NA',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12,),
                      const Text(
                        'Checkout Note',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        guardLog.checkoutReason ?? 'NA',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            if (_hasMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text("No more data to load")),
              );
            }
          }
        }
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Entries',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedShift = '';
                              _selectedGate = '';
                              _startDate = null;
                              _endDate = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildGateFilterChip('Ground Floor Entry', 'Ground Floor Entry', setModalState),
                        _buildGateFilterChip('Podium Entry', 'Podium Entry', setModalState),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Shift',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildShiftFilterChip('All Shifts', 'All Shifts', setModalState),
                        _buildShiftFilterChip('Morning', 'Morning', setModalState),
                        _buildShiftFilterChip('Evening', 'Evening', setModalState),
                        _buildShiftFilterChip('Night', 'Night', setModalState),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Date Range',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        await _selectDateRange(context);
                        setModalState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(width: 8),
                            Text(
                              _startDate != null && _endDate != null
                                  ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}'
                                  : 'Select date range',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: SizedBox(
                            height: 48, // Equal height for both buttons
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48, // Same height
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _applyFilters();
                              },
                              child: const Text('Apply'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      _page = 1;
      _hasMore = true;
      data.clear();
      _hasActiveFilters = _selectedGate.isNotEmpty || _selectedShift.isNotEmpty || _startDate != null || _endDate != null;
    });
    _fetchEntries();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Widget _buildGateFilterChip(String label, String value, StateSetter setModalState) {
    return FilterChip(
      label: Text(label),
      selected: _selectedGate == value,
      onSelected: (selected) {
        setModalState(() {
          _selectedGate = selected ? value : '';
        });
      },
    );
  }

  Widget _buildShiftFilterChip(String label, String value, StateSetter setModalState) {
    return FilterChip(
      label: Text(label),
      selected: _selectedShift == value,
      onSelected: (selected) {
        setModalState(() {
          _selectedShift = selected ? value : '';
        });
      },
    );
  }
}

