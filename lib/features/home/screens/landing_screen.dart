import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gloria_connect/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/utils/notification_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _currentCarouselIndex = 0;
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  final CarouselSliderController _carouselController = CarouselSliderController();

  // List of images for the carousel
  final List<Map<String, dynamic>> featuresList = [
    {
      'image': 'assets/images/landing_screen/apartment_building.png',
      'title': 'Smart Community Living',
      'description': 'Experience seamless community management through our integrated platform'
    },
    {
      'image': 'assets/images/landing_screen/security_system.png',
      'title': 'Enhanced Security',
      'description': 'Monitor visitors and strengthen your property\'s security protocols'
    },
    {
      'image': 'assets/images/landing_screen/community_space.png',
      'title': 'Community Engagement',
      'description': 'Stay connected with community events and important notifications'
    },
    {
      'image': 'assets/images/landing_screen/living_room.png',
      'title': 'Modern Living',
      'description': 'Elevate your residential experience with digital convenience'
    },
  ];

  // Quick action buttons data
  final List<Map<String, dynamic>> quickActions = [
    {'title': 'Visitors', 'icon': Icons.people, 'color': const Color(0xFFE53935), 'route': '/visitors-screen'},
    {'title': 'Pre-Approve', 'icon': Icons.person_add_alt_1, 'color': const Color(0xFFFF6D00), 'route': '/pre-approve-screen'},
    {'title': 'Notices', 'icon': Icons.announcement_outlined, 'color': const Color(0xFF00C853), 'route': '/general-notice-board-screen'},
    {'title': 'Complaints', 'icon': Icons.report, 'color': const Color(0xFF4A6FFF), 'route': '/complaint-screen' },
  ];

  // Recent activity data
  final List<Map<String, dynamic>> recentActivity = [
    {
      'title': 'Package Delivered',
      'details': 'Amazon package received at gate',
      'time': '10:30 AM',
      'icon': Icons.local_shipping_outlined,
      'color': const Color(0xFF00C853)
    },
    {
      'title': 'Guest: John Smith',
      'details': 'Arrived and checked in at main gate',
      'time': 'Yesterday, 2:15 PM',
      'icon': Icons.person_outlined,
      'color': const Color(0xFF4A6FFF)
    },
    {
      'title': 'Maintenance Notice',
      'details': 'Water supply will be interrupted on Sunday',
      'time': 'Yesterday, 9:00 AM',
      'icon': Icons.announcement_outlined,
      'color': const Color(0xFFFF6D00)
    },
  ];

  void getInitialAction() async {
    notificationAppLaunchDetails = NotificationController.notificationAppLaunchDetails;
    Map<String, dynamic>? payload;
    if(notificationAppLaunchDetails?.notificationResponse?.payload != null){
      payload = jsonDecode(notificationAppLaunchDetails!.notificationResponse!.payload!);
    }
    if (mounted ) {
      if (notificationAppLaunchDetails != null && payload?['action'] == 'VERIFY_RESIDENT_PROFILE_TYPE') {
        Navigator.pushNamedAndRemoveUntil(context, '/resident-approval', (route) => route.isFirst,);
      } else if (notificationAppLaunchDetails != null && payload?['action'] == 'VERIFY_GUARD_PROFILE_TYPE') {
        Navigator.pushNamedAndRemoveUntil(context, '/guard-approval', (route) => route.isFirst,);
      } else if (notificationAppLaunchDetails != null && payload?['action'] == 'VERIFY_DELIVERY_ENTRY') {
        Navigator.pushNamedAndRemoveUntil(context, '/delivery-approval-screen', (route) => route.isFirst, arguments: payload);
      }else if (notificationAppLaunchDetails != null && payload?['action'] == 'NOTIFY_NOTICE_CREATED') {
        Navigator.pushNamedAndRemoveUntil(context, '/notice-board-details-screen', (route) => route.isFirst, arguments: NoticeBoardModel.fromJson(payload!));
      }else if (notificationAppLaunchDetails != null && payload?['action'] == 'NOTIFY_COMPLAINT_CREATED') {
        Navigator.pushNamedAndRemoveUntil(context, '/complaint-details-screen', (route) => route.isFirst, arguments: {'id': payload?['id']});
      }else if (notificationAppLaunchDetails != null && payload?['action'] == 'NOTIFY_RESIDENT_REPLIED') {
        Navigator.pushNamedAndRemoveUntil(context, '/complaint-details-screen', (route) => route.isFirst, arguments: {'id': payload?['id']});
      }else if (notificationAppLaunchDetails != null && payload?['action'] == 'NOTIFY_ADMIN_REPLIED') {
        Navigator.pushNamedAndRemoveUntil(context, '/complaint-details-screen', (route) => route.isFirst, arguments: {'id': payload?['id']});
      } else {
        context.read<MyVisitorsBloc>().add(GetServiceRequest());
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<MyVisitorsBloc>().add(GetServiceRequest());
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInitialAction();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<MyVisitorsBloc, MyVisitorsState>(
        listener: (context, state){
          if (state is GetServiceRequestSuccess) {
            Navigator.pushNamed(context, '/delivery-approval-inside', arguments: state.response);
          }
        },
        builder: (context, state){
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header with carousel
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      // Carousel
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: size.height * 0.60,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentCarouselIndex = index;
                            });
                          },
                        ),
                        items: featuresList.map((feature) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: size.width,
                                height: size.height * 0.60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(feature['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Gradient overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.1),
                                            Colors.black.withOpacity(1),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Feature text
                                    Positioned(
                                      bottom: 50,
                                      left: 24,
                                      right: 24,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            feature['title'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            feature['description'],
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: 16,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),

                      // App Logo and Name
                      Positioned(
                        top: 50,
                        left: 24,
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.asset('assets/app_logo/app_logo.png'),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Gloria Connect",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Carousel indicator
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: featuresList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _carouselController.animateToPage(entry.key),
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(
                                    _currentCarouselIndex == entry.key ? 1.0 : 0.5,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Actions Section
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Quick Actions",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Manage your daily tasks efficiently",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: quickActions.map((action) {
                              return _buildQuickActionButton(
                                  title: action['title'],
                                  icon: action['icon'],
                                  color: action['color'],
                                  route: action['route']
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Recent Activity Section
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             const Text(
                //               "Recent Activity",
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //                 color: Color(0xFF2A3252),
                //               ),
                //             ),
                //             TextButton(
                //               onPressed: () {
                //                 // View all action
                //               },
                //               style: TextButton.styleFrom(
                //                 foregroundColor: const Color(0xFF4A6FFF),
                //               ),
                //               child: const Text("View All"),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(height: 16),
                //         ...recentActivity.map((activity) {
                //           return _buildActivityCard(
                //             title: activity['title'],
                //             details: activity['details'],
                //             time: activity['time'],
                //             icon: activity['icon'],
                //             color: activity['color'],
                //           );
                //         }).toList(),
                //       ],
                //     ),
                //   ),
                // ),

                // Community Updates Section
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const Text(
                //           "Community Updates",
                //           style: TextStyle(
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //             color: Color(0xFF2A3252),
                //           ),
                //         ),
                //         const SizedBox(height: 16),
                //         Container(
                //           padding: const EdgeInsets.all(16),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(16),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withOpacity(0.05),
                //                 blurRadius: 10,
                //                 offset: const Offset(0, 4),
                //               ),
                //             ],
                //           ),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 children: [
                //                   Container(
                //                     padding: const EdgeInsets.all(8),
                //                     decoration: BoxDecoration(
                //                       color: const Color(0xFFF0F4FF),
                //                       borderRadius: BorderRadius.circular(12),
                //                     ),
                //                     child: const Icon(
                //                       Icons.event_note_outlined,
                //                       color: Color(0xFF4A6FFF),
                //                       size: 22,
                //                     ),
                //                   ),
                //                   const SizedBox(width: 12),
                //                   const Column(
                //                     crossAxisAlignment: CrossAxisAlignment.start,
                //                     children: [
                //                       Text(
                //                         "Upcoming Community Meeting",
                //                         style: TextStyle(
                //                           fontSize: 16,
                //                           fontWeight: FontWeight.bold,
                //                           color: Color(0xFF2A3252),
                //                         ),
                //                       ),
                //                       SizedBox(height: 4),
                //                       Text(
                //                         "Sunday, 12:00 PM • Community Hall",
                //                         style: TextStyle(
                //                           fontSize: 14,
                //                           color: Color(0xFF6C7693),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               const SizedBox(height: 16),
                //               const Text(
                //                 "Annual budget discussion and new facility proposals. Please bring your suggestions and feedback.",
                //                 style: TextStyle(
                //                   fontSize: 14,
                //                   color: Color(0xFF6C7693),
                //                   height: 1.5,
                //                 ),
                //               ),
                //               const SizedBox(height: 16),
                //               Row(
                //                 children: [
                //                   OutlinedButton(
                //                     onPressed: () {
                //                       // RSVP action
                //                     },
                //                     style: OutlinedButton.styleFrom(
                //                       side: const BorderSide(color: Color(0xFF4A6FFF)),
                //                       shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(8),
                //                       ),
                //                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //                     ),
                //                     child: const Text("RSVP"),
                //                   ),
                //                   const SizedBox(width: 12),
                //                   OutlinedButton(
                //                     onPressed: () {
                //                       // Add to calendar action
                //                     },
                //                     style: OutlinedButton.styleFrom(
                //                       side: const BorderSide(color: Color(0xFF4A6FFF)),
                //                       shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(8),
                //                       ),
                //                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //                     ),
                //                     child: const Text("Add to Calendar"),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, route);
      },
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildActivityCard({
  //   required String title,
  //   required String details,
  //   required String time,
  //   required IconData icon,
  //   required Color color,
  // }) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 16),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           height: 48,
  //           width: 48,
  //           decoration: BoxDecoration(
  //             color: color.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Icon(
  //             icon,
  //             color: color,
  //             size: 24,
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF2A3252),
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 details,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Text(
  //               time,
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 color: Colors.grey[500],
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             const Icon(
  //               Icons.arrow_forward_ios,
  //               color: Color(0xFFCCD0D9),
  //               size: 14,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}