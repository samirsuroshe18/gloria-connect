import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../auth/bloc/auth_bloc.dart';

class VerificationPendingScreen extends StatefulWidget {
  const VerificationPendingScreen({super.key});

  @override
  State<VerificationPendingScreen> createState() => _VerificationPendingScreenState();
}

class _VerificationPendingScreenState extends State<VerificationPendingScreen> {
  String status = 'pending';
  String? profileImg;
  late SharedPreferences _prefs;
  String? contactEmail;

  Future<void> _refresh() async {
    context.read<AuthBloc>().add(AuthGetUser());
    context.read<AuthBloc>().add(AuthGetContactEmail());
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    context.read<AuthBloc>().add(AuthGetUser());
    context.read<AuthBloc>().add(AuthGetContactEmail());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Verification Status',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logoutUser,
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthGetUserSuccess) {
            profileImg = state.response.profile;

            if (state.response.role == 'admin') {
              if (state.response.residentStatus == 'approve') {
                Navigator.pushReplacementNamed(context, '/admin-home');
              }
            } else if (state.response.profileType == 'Security') {
              status = state.response.guardStatus!;
              if (state.response.guardStatus == 'approve') {
                Navigator.pushReplacementNamed(context, '/guard-home');
              }
            } else if (state.response.profileType == 'Resident') {
              status = state.response.residentStatus!;
              if (state.response.residentStatus == 'approve') {
                Navigator.pushReplacementNamed(context, '/resident-home');
              }
            }
          }

          if(state is AuthGetContactEmailSuccess){
            contactEmail = state.response['contactEmail'];
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Profile Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: profileImg != null
                                    ? NetworkImage(profileImg!)
                                    : const AssetImage(
                                    'assets/images/profile.png')
                                as ImageProvider,
                              ),
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _getStatusColor(status),
                                    width: 3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Verification in Progress',
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              color: const Color(0xFF1E3A8A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(status),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Progress Timeline
                    _buildVerificationTimeline(),
                    const SizedBox(height: 32),
                    // Information Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF1E3A8A),
                            size: 28,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Our team is reviewing your information. This process typically takes 24-48 hours. You will be notified once the verification is complete.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF1E3A8A),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Support Section
                    OutlinedButton(
                      onPressed: _contactSupport,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Color(0xFF1E3A8A)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(color: Color(0xFF1E3A8A)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approve':
        return Colors.green;
      case 'reject':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildVerificationTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Verification Process',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
              color: const Color(0xFF1E3A8A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildTimelineStep(
          icon: Icons.person_outline,
          title: 'Profile Submitted',
          description: 'Your profile information has been received',
          isCompleted: true,
        ),
        _buildTimelineStep(
          icon: Icons.document_scanner_outlined,
          title: 'Document Review',
          description: 'Verifying your submitted documents',
          isCompleted: status != 'pending',
          isLast: false,
        ),
        _buildTimelineStep(
          icon: Icons.verified_outlined,
          title: 'Verification Complete',
          description: 'Access will be granted upon approval',
          isCompleted: status == 'approve',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineStep({required IconData icon, required String title, required String description, required bool isCompleted, bool isLast = false,}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF1E3A8A)
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isCompleted ? Colors.white : Colors.grey,
                    size: 20,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey.shade200,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logoutUser() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              const SizedBox(width: 8),
              const Text('Confirm Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLogoutLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthLogoutSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    removeAccessToken();
                  });
                  return const SizedBox.shrink();
                } else {
                  return TextButton(
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Theme
                          .of(context)
                          .colorScheme
                          .error),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> removeAccessToken() async {
    await _prefs.remove("accessToken");
    await _prefs.remove("refreshMode");

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (Route<dynamic> route) => false,
    );
  }

  void _contactSupport() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: contactEmail ?? 'support@example.com', // Replace with your support email
    queryParameters: {
      'subject': 'Support Request',
      'body': 'Hello, I need help with...',
    },
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    debugPrint('Could not launch email app');
  }
}
}


