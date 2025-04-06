import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../check_in/bloc/check_in_bloc.dart';

class GuardProfileScreen extends StatefulWidget {
  const GuardProfileScreen({super.key});

  @override
  State<GuardProfileScreen> createState() => _GuardProfileScreenState();
}

class _GuardProfileScreenState extends State<GuardProfileScreen> {
  GetUserModel? data;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthGetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthGetUserLoading) {
            _isLoading = true;
          }
          if (state is AuthGetUserSuccess) {
            _isLoading = false;
            data = state.response;
          }
          if (state is AuthGetUserFailure) {
            _isLoading = false;
          }
        },
        builder: (context, state) {
          if (data != null && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: CustomScrollView(
                slivers: [
                  // Custom App Bar with Profile Info
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: DateTime.now().toIso8601String(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white70,
                                      width: 4,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: data?.profile == null
                                        ? const AssetImage('assets/images/profile.png')
                                        : NetworkImage(data!.profile!) as ImageProvider,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                data?.userName ?? "NA",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data?.email ?? "NA",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/edit-profile-screen',
                                    arguments: data,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  foregroundColor: Colors.white70,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Edit Profile'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Main Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Gate Assignment Card
                          _buildInfoCard(
                            title: 'Gate Assignment',
                            content: data?.gateAssign?.toUpperCase() ?? "NA",
                            icon: Icons.door_sliding_outlined,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),
                          // Passcode Card
                          _buildInfoCard(
                            title: 'Guard Passcode',
                            content: data?.checkInCode ?? "NA",
                            icon: Icons.lock,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),
                          // Quick Actions
                          _buildActionsList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (_isLoading) {
            return Center(
              child: Lottie.asset(
                'assets/animations/loader.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            );
          } else {
            return _buildErrorState();
          }
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsList() {
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'View Checkout History',
        'icon': Icons.history,
        'color': Colors.white70,
        'route': '/checkout-history-screen',
      },
      {
        'title': 'View Gate Pass',
        'icon': Icons.visibility,
        'color': Colors.white70,
        'route': '/gate-pass-list-screen',
      },
      {
        'title': 'Add Gate Pass',
        'icon': Icons.add_circle,
        'color': Colors.white70,
        'onTap': () {
          context.read<CheckInBloc>().add(ClearFlat());
          Navigator.pushNamed(context, '/add-service-screen');
        },
      },
      {
        'title': 'Settings',
        'icon': Icons.settings,
        'color': Colors.white70,
        'route': '/setting-screen',
        'arguments': data,
      },
      {
        'title': 'Logout',
        'icon': Icons.logout,
        'color': Colors.redAccent,
        'onTap': _logoutUser,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        padding: EdgeInsets.only(top: 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final action = actions[index];
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: action['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                action['icon'],
                color: action['color'],
              ),
            ),
            title: Text(
              action['title'],
              style: TextStyle(
                color: action['title'] == 'Logout' ? Colors.redAccent : Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey,
            ),
            onTap: action['onTap'] ??
                    () => Navigator.pushNamed(context, action['route'], arguments: action['arguments']),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    context.read<AuthBloc>().add(AuthGetUser());
  }

  void _logoutUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Logout'),
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
                  onPressed() {
                    removeAccessToken();
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Logout'),
                  );
                } else {
                  return TextButton(
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.remove("refreshMode");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (Route<dynamic> route) => false,
      );
    }
  }
}