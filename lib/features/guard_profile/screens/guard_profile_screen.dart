import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/guard_profile/widgets/build_action_list.dart';
import 'package:gloria_connect/features/guard_profile/widgets/build_info_card.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                              CustomCachedNetworkImage(
                                imageUrl: data!.profile!,
                                isCircular: true,
                                size: 100,
                                errorImage: Icons.person,
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
                          BuildInfoCard(
                            title: 'Gate Assignment',
                            content: data?.gateAssign?.toUpperCase() ?? "NA",
                            icon: Icons.door_sliding_outlined,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),
                          // Passcode Card
                          BuildInfoCard(
                            title: 'Guard Passcode',
                            content: data?.checkInCode ?? "NA",
                            icon: Icons.lock,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),
                          // Quick Actions
                          BuildActionList(logoutUser: _logoutUser, data: data, onAddGatePass: _addGatePass,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (_isLoading) {
            return const CustomLoader();
          } else {
            return BuildErrorState(onRefresh: _refreshData);
          }
        },
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

  void _addGatePass() {
    context.read<CheckInBloc>().add(ClearFlat());
    Navigator.pushNamed(context, '/add-service-screen');
  }

  Future<void> removeAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.remove("refreshMode");
    if (mounted) {
      CustomSnackBar.show(context: context, message: 'Logged out successfully', type: SnackBarType.success);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (Route<dynamic> route) => false,
      );
    }
  }
}