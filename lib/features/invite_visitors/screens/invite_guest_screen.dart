// // import 'package:flutter/material.dart';
// //
// // class InviteGuestScreen extends StatefulWidget {
// //   const InviteGuestScreen({super.key});
// //
// //   @override
// //   State<InviteGuestScreen> createState() => _InviteGuestScreenState();
// // }
// //
// // class _InviteGuestScreenState extends State<InviteGuestScreen> with WidgetsBindingObserver {
// //   bool isOnceSelected = true;
// //   DateTime selectedDate = DateTime.now();
// //   TimeOfDay selectedTime = TimeOfDay.now();
// //   String passValidity = '4 hours';
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addObserver(this);
// //   }
// //
// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     super.dispose();
// //   }
// //
// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (state == AppLifecycleState.resumed) {
// //       // Handle app coming back from background if needed
// //     }
// //   }
// //
// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate,
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );
// //     if (picked != null && picked != selectedDate) {
// //       setState(() {
// //         selectedDate = picked;
// //       });
// //     }
// //   }
// //
// //   Future<void> _selectTime(BuildContext context) async {
// //     final TimeOfDay? picked = await showTimePicker(
// //       context: context,
// //       initialTime: selectedTime,
// //     );
// //     if (picked != null && picked != selectedTime) {
// //       setState(() {
// //         selectedTime = picked;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Pre-approve',
// //           style: TextStyle(color: Colors.white),
// //         ),
// //         backgroundColor: Colors.blue,
// //       ),
// //       body: Container(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Center(
// //               child: Container(
// //                 width: 350,
// //                 height: 50,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[850],
// //                   borderRadius: BorderRadius.circular(15),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: GestureDetector(
// //                         onTap: () {
// //                           setState(() {
// //                             isOnceSelected = true;
// //                           });
// //                         },
// //                         child: Container(
// //                           decoration: BoxDecoration(
// //                             color: isOnceSelected
// //                                 ? Colors.white
// //                                 : Colors.blue,
// //                             borderRadius: const BorderRadius.horizontal(
// //                               left: Radius.circular(15),
// //                             ),
// //                             // Remove border here
// //                           ),
// //                           alignment: Alignment.center,
// //                           child: Text(
// //                             'Once',
// //                             style: TextStyle(
// //                               color: isOnceSelected
// //                                   ? Colors.black
// //                                   : Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: GestureDetector(
// //                         onTap: () {
// //                           setState(() {
// //                             isOnceSelected = false;
// //                           });
// //                         },
// //                         child: Container(
// //                           decoration: BoxDecoration(
// //                             color: isOnceSelected
// //                                 ? Colors.blue
// //                                 : Colors.white,
// //                             borderRadius: const BorderRadius.horizontal(
// //                               right: Radius.circular(15),
// //                             ),
// //                             // Remove border here
// //                           ),
// //                           alignment: Alignment.center,
// //                           child: Text(
// //                             'Frequently',
// //                             style: TextStyle(
// //                               color: isOnceSelected
// //                                   ? Colors.white
// //                                   : Colors.black,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Text(
// //                       'Select Date',
// //                       style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     GestureDetector(
// //                       onTap: () => _selectDate(context),
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
// //                         decoration: BoxDecoration(
// //                           color: Colors.blue,
// //                           border: Border.all(color: Colors.white.withOpacity(0.7)),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                         ),
// //                         child: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             const Icon(Icons.calendar_today, color: Colors.white),
// //                             const SizedBox(width: 10),
// //                             Text(
// //                               "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
// //                               style: const TextStyle(fontSize: 18, color: Colors.white),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(width: 30),
// //
// //                 Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Text(
// //                       'Select Time',
// //                       style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     GestureDetector(
// //                       onTap: () => _selectTime(context),
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
// //                         decoration: BoxDecoration(
// //                           color: Colors.blue,
// //                           border: Border.all(color: Colors.white.withOpacity(0.7)),
// //                           borderRadius: BorderRadius.circular(8.0),
// //                         ),
// //                         child: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             const Icon(Icons.access_time, color: Colors.white),
// //                             const SizedBox(width: 10),
// //                             Text(
// //                               selectedTime.format(context),
// //                               style: const TextStyle(fontSize: 18, color: Colors.white),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               'Pass Validity',
// //               style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
// //             ),
// //             const SizedBox(height: 8),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 _validityOption('4 hours'),
// //                 const SizedBox(width: 8),
// //                 _validityOption('8 hours'),
// //                 const SizedBox(width: 8),
// //                 _validityOption('12 hours'),
// //                 const SizedBox(width: 8),
// //                 _validityOption('24 hours'),
// //               ],
// //             ),
// //             // SizedBox(height: 20),
// //             // Center(
// //             //   child: GestureDetector(
// //             //     onTap: () {
// //             //       print('Add Guests button clicked');
// //             //     },
// //             //     child: Container(
// //             //       width: double.infinity,
// //             //       height: 50,
// //             //       decoration: BoxDecoration(
// //             //         color: Colors.grey[850],
// //             //         border: Border.all(color: Colors.white.withOpacity(0.7)),
// //             //         borderRadius: BorderRadius.circular(8.0),
// //             //       ),
// //             //       alignment: Alignment.center,
// //             //       child: Text(
// //             //         'Add Guests',
// //             //         style: TextStyle(fontSize: 18, color: Colors.white),
// //             //       ),
// //             //     ),
// //             //   ),
// //             // ),
// //             const Spacer(),
// //             // Row(
// //             //   children: [
// //             //     Checkbox(value: false, onChanged: (bool? value) {}),
// //             //     Text('Private Notification', style: TextStyle(color: Colors.white)),
// //             //   ],
// //             // ),
// //             // SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: () {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text('Guest is pre-approved successfully'),
// //                     backgroundColor: Colors.green,
// //                   ),
// //                 );
// //               },
// //               style: ElevatedButton.styleFrom(
// //                 minimumSize: const Size(double.infinity, 50),
// //                 backgroundColor: Colors.white,
// //               ),
// //               child: const Text('Pre-approve', style: TextStyle(color: Colors.black)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _validityOption(String option) {
// //     return Expanded(
// //       child: GestureDetector(
// //         onTap: () {
// //           setState(() {
// //             passValidity = option;
// //           });
// //         },
// //         child: Container(
// //           padding: const EdgeInsets.symmetric(vertical: 12),
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(8),
// //             color: passValidity == option ? Colors.white : Colors.blue,
// //             border: Border.all(
// //               color: Colors.white.withOpacity(0.7),
// //             ),
// //           ),
// //           alignment: Alignment.center,
// //           child: Text(
// //             option,
// //             style: TextStyle(
// //               color: passValidity == option ? Colors.black : Colors.white,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
//
// class InviteGuestScreen extends StatefulWidget {
//   const InviteGuestScreen({super.key});
//
//   @override
//   State<InviteGuestScreen> createState() => _InviteGuestScreenState();
// }
//
// class _InviteGuestScreenState extends State<InviteGuestScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Guest", style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.blue,
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: "Once"),
//             Tab(text: "Frequently"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Once Tab
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Select Date",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           side: const BorderSide(color: Colors.grey),
//                         ),
//                         onPressed: () {
//                           // Date picker logic
//                         },
//                         child: const Text("Today"),
//                       ),
//                     ),
//                     const SizedBox(width: 16.0),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           side: const BorderSide(color: Colors.grey),
//                         ),
//                         onPressed: () {
//                           // Time picker logic
//                         },
//                         child: const Text("01:17 PM"),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//                 const Text(
//                   "Pass Validity",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8.0),
//                 Wrap(
//                   spacing: 8.0,
//                   runSpacing: 8.0,
//                   children: [
//                     _buildPassValidityButton("4 hours", true),
//                     _buildPassValidityButton("8 hours", false),
//                     _buildPassValidityButton("12 hours", false),
//                     _buildPassValidityButton("24 hours", false),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Add Guests logic
//                   },
//                   style: ElevatedButton.styleFrom(
//                     side: const BorderSide(color: Colors.grey),
//                   ),
//                   child: const Text("Add Guests"),
//                 ),
//                 const Spacer(),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: false,
//                       onChanged: (value) {
//                         // Handle checkbox change
//                       },
//                     ),
//                     const Text("Private Notification"),
//                     const Spacer(),
//                     IconButton(
//                       icon: const Icon(Icons.info),
//                       onPressed: () {
//                         // Info action
//                       },
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Pre-approve logic
//                     },
//                     style: ElevatedButton.styleFrom(
//                     ),
//                     child: const Text("Pre-approve"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Frequently Tab
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Start Date",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Start date picker logic
//                   },
//                   style: ElevatedButton.styleFrom(
//                     side: const BorderSide(color: Colors.grey),
//                   ),
//                   child: const Text("Select Start Date"),
//                 ),
//                 const SizedBox(height: 16.0),
//                 const Text(
//                   "End Date",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // End date picker logic
//                   },
//                   style: ElevatedButton.styleFrom(
//                     side: const BorderSide(color: Colors.grey),
//                   ),
//                   child: const Text("Select End Date"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPassValidityButton(String label, bool selected) {
//     return ElevatedButton(
//       onPressed: () {
//         // Handle button click
//       },
//       style: ElevatedButton.styleFrom(
//         side: const BorderSide(color: Colors.grey),
//       ),
//       child: Text(label),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// class InviteGuestScreen extends StatefulWidget {
//   const InviteGuestScreen({super.key});
//
//   @override
//   State<InviteGuestScreen> createState() => _InviteGuestScreenState();
// }
//
// class _InviteGuestScreenState extends State<InviteGuestScreen> with WidgetsBindingObserver {
//   bool isOnceSelected = true;
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//   String passValidity = '4 hours';
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // Handle app coming back from background if needed
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (picked != null && picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Pre-approve',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 350,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[850],
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             isOnceSelected = true;
//                           });
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: isOnceSelected
//                                 ? Colors.white
//                                 : Colors.blue,
//                             borderRadius: const BorderRadius.horizontal(
//                               left: Radius.circular(15),
//                             ),
//                             // Remove border here
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             'Once',
//                             style: TextStyle(
//                               color: isOnceSelected
//                                   ? Colors.black
//                                   : Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             isOnceSelected = false;
//                           });
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: isOnceSelected
//                                 ? Colors.blue
//                                 : Colors.white,
//                             borderRadius: const BorderRadius.horizontal(
//                               right: Radius.circular(15),
//                             ),
//                             // Remove border here
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             'Frequently',
//                             style: TextStyle(
//                               color: isOnceSelected
//                                   ? Colors.white
//                                   : Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Select Date',
//                       style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: () => _selectDate(context),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           border: Border.all(color: Colors.white.withOpacity(0.7)),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(Icons.calendar_today, color: Colors.white),
//                             const SizedBox(width: 10),
//                             Text(
//                               "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
//                               style: const TextStyle(fontSize: 18, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 30),
//
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Select Time',
//                       style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: () => _selectTime(context),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           border: Border.all(color: Colors.white.withOpacity(0.7)),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(Icons.access_time, color: Colors.white),
//                             const SizedBox(width: 10),
//                             Text(
//                               selectedTime.format(context),
//                               style: const TextStyle(fontSize: 18, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Pass Validity',
//               style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _validityOption('4 hours'),
//                 const SizedBox(width: 8),
//                 _validityOption('8 hours'),
//                 const SizedBox(width: 8),
//                 _validityOption('12 hours'),
//                 const SizedBox(width: 8),
//                 _validityOption('24 hours'),
//               ],
//             ),
//             // SizedBox(height: 20),
//             // Center(
//             //   child: GestureDetector(
//             //     onTap: () {
//             //       print('Add Guests button clicked');
//             //     },
//             //     child: Container(
//             //       width: double.infinity,
//             //       height: 50,
//             //       decoration: BoxDecoration(
//             //         color: Colors.grey[850],
//             //         border: Border.all(color: Colors.white.withOpacity(0.7)),
//             //         borderRadius: BorderRadius.circular(8.0),
//             //       ),
//             //       alignment: Alignment.center,
//             //       child: Text(
//             //         'Add Guests',
//             //         style: TextStyle(fontSize: 18, color: Colors.white),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             const Spacer(),
//             // Row(
//             //   children: [
//             //     Checkbox(value: false, onChanged: (bool? value) {}),
//             //     Text('Private Notification', style: TextStyle(color: Colors.white)),
//             //   ],
//             // ),
//             // SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Guest is pre-approved successfully'),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: Colors.white,
//               ),
//               child: const Text('Pre-approve', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _validityOption(String option) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             passValidity = option;
//           });
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: passValidity == option ? Colors.white : Colors.blue,
//             border: Border.all(
//               color: Colors.white.withOpacity(0.7),
//             ),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             option,
//             style: TextStyle(
//               color: passValidity == option ? Colors.black : Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gloria_connect/features/invite_visitors/screens/frequently_tab.dart';
import 'package:gloria_connect/features/invite_visitors/screens/once_tab.dart';

class InviteGuestScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const InviteGuestScreen({super.key, this.data});

  @override
  State<InviteGuestScreen> createState() => _InviteGuestScreenState();
}

class _InviteGuestScreenState extends State<InviteGuestScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Guest', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              const TabBar(
                labelColor: Colors.blue,
                tabs: [
                  Tab(text: 'Once'),
                  Tab(text: 'Frequently'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    OnceTab(data: widget.data,),
                    FrequentlyTab(data: widget.data,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
